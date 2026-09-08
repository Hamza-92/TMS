<?php

namespace App\Services\Measurements;

use App\Enums\CustomerStatus;
use App\Enums\MeasurementStatus;
use App\Enums\MeasurementTemplateSource;
use App\Exceptions\MeasurementOperationConflict;
use App\Exceptions\MeasurementVersionConflict;
use App\Models\Business;
use App\Models\Customer;
use App\Models\CustomerMeasurementProfile;
use App\Models\CustomerMeasurementRevision;
use App\Models\MeasurementOperation;
use App\Models\MeasurementTemplate;
use App\Models\MeasurementTemplateField;
use App\Models\MeasurementTemplateVersion;
use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class MeasurementMutationService
{
    /** @param array<string, mixed> $data
     * @return array{template: MeasurementTemplate, created: bool, replayed: bool}
     */
    public function upsertTemplate(
        Business $business,
        User $user,
        string $clientUuid,
        array $data,
    ): array {
        return DB::transaction(function () use ($business, $user, $clientUuid, $data): array {
            $hash = $this->requestHash('template_upsert', $clientUuid, $data);
            $replayed = $this->replayedTemplate($business, $data['operation_uuid'], $hash, $clientUuid);
            if ($replayed) {
                return ['template' => $this->loadTemplate($replayed), 'created' => false, 'replayed' => true];
            }

            $template = MeasurementTemplate::query()
                ->where('business_id', $business->id)
                ->where('client_uuid', $clientUuid)
                ->lockForUpdate()
                ->first();
            $created = ! $template;

            if ($created) {
                if ((int) $data['base_version'] !== 0) {
                    throw ValidationException::withMessages([
                        'base_version' => ['Use version 0 when creating a measurement template.'],
                    ]);
                }

                $template = new MeasurementTemplate([
                    'business_id' => $business->id,
                    'client_uuid' => $clientUuid,
                    'source' => MeasurementTemplateSource::Business,
                    'version' => 1,
                    'current_definition_version' => 1,
                    'created_by_user_id' => $user->id,
                ]);
            } else {
                $this->ensureVersion($template, (int) $data['base_version'], 'template');
                if ($template->status !== MeasurementStatus::Active) {
                    throw ValidationException::withMessages([
                        'template' => ['Restore this measurement template before editing it.'],
                    ]);
                }

                $template->version++;
                $template->current_definition_version++;
            }

            if ($created && ($sourceUuid = $data['source_template_uuid'] ?? null)) {
                $template->source_template_id = $this->accessibleTemplate($business, $sourceUuid)->id;
            }

            $template->fill(Arr::only($data, [
                'name', 'name_ur', 'name_roman_ur', 'category', 'default_unit', 'description',
            ]));
            $template->updated_by_user_id = $user->id;
            $template->save();

            $definition = $template->versions()->create([
                'version_number' => $template->current_definition_version,
                'name' => $template->name,
                'name_ur' => $template->name_ur,
                'name_roman_ur' => $template->name_roman_ur,
                'category' => $template->category,
                'default_unit' => $template->default_unit,
                'description' => $template->description,
                'created_by_user_id' => $user->id,
            ]);
            $this->createFields($definition, $data['fields']);

            $this->recordOperation(
                $business,
                $user,
                'template',
                $clientUuid,
                'upsert',
                $hash,
                $template->version,
                $data['operation_uuid'],
            );

            return ['template' => $this->loadTemplate($template), 'created' => $created, 'replayed' => false];
        });
    }

    /** @param array<string, mixed> $data */
    public function changeTemplateStatus(
        Business $business,
        User $user,
        string $clientUuid,
        array $data,
        MeasurementStatus $status,
    ): MeasurementTemplate {
        return DB::transaction(function () use ($business, $user, $clientUuid, $data, $status): MeasurementTemplate {
            $action = $status === MeasurementStatus::Archived ? 'archive' : 'restore';
            $hash = $this->requestHash("template_{$action}", $clientUuid, $data);
            $replayed = $this->replayedTemplate($business, $data['operation_uuid'], $hash, $clientUuid);
            if ($replayed) {
                return $this->loadTemplate($replayed);
            }

            $template = MeasurementTemplate::query()
                ->where('business_id', $business->id)
                ->where('client_uuid', $clientUuid)
                ->lockForUpdate()
                ->firstOrFail();
            $this->ensureVersion($template, (int) $data['base_version'], 'template');
            if ($template->status === $status) {
                throw ValidationException::withMessages([
                    'template' => [$status === MeasurementStatus::Archived
                        ? 'This measurement template is already archived.'
                        : 'This measurement template is already active.'],
                ]);
            }

            $template->forceFill([
                'status' => $status,
                'version' => $template->version + 1,
                'updated_by_user_id' => $user->id,
                'archived_at' => $status === MeasurementStatus::Archived ? now() : null,
            ])->save();

            $this->recordOperation(
                $business,
                $user,
                'template',
                $clientUuid,
                $action,
                $hash,
                $template->version,
                $data['operation_uuid'],
            );

            return $this->loadTemplate($template);
        });
    }

    /** @param array<string, mixed> $data
     * @return array{profile: CustomerMeasurementProfile, created: bool, replayed: bool}
     */
    public function upsertProfile(
        Business $business,
        User $user,
        Customer $customer,
        string $clientUuid,
        array $data,
    ): array {
        return DB::transaction(function () use ($business, $user, $customer, $clientUuid, $data): array {
            $hash = $this->requestHash('profile_upsert', $clientUuid, $data);
            $replayed = $this->replayedProfile($business, $data['operation_uuid'], $hash, $clientUuid);
            if ($replayed) {
                return ['profile' => $this->loadProfile($replayed), 'created' => false, 'replayed' => true];
            }

            if ($customer->status !== CustomerStatus::Active) {
                throw ValidationException::withMessages([
                    'customer' => ['Restore this customer before changing measurements.'],
                ]);
            }

            $template = $this->accessibleTemplate($business, $data['template_client_uuid']);
            if ($template->status !== MeasurementStatus::Active) {
                throw ValidationException::withMessages([
                    'template_client_uuid' => ['Select an active measurement template.'],
                ]);
            }
            $definition = $template->versions()
                ->where('version_number', (int) $data['template_definition_version'])
                ->first();
            if (! $definition) {
                throw ValidationException::withMessages([
                    'template_definition_version' => ['The selected template version was not found.'],
                ]);
            }

            $profile = CustomerMeasurementProfile::query()
                ->where('business_id', $business->id)
                ->where('client_uuid', $clientUuid)
                ->lockForUpdate()
                ->first();
            $created = ! $profile;

            if ($created) {
                if ((int) $data['base_version'] !== 0) {
                    throw ValidationException::withMessages([
                        'base_version' => ['Use version 0 when creating a measurement profile.'],
                    ]);
                }

                $profile = new CustomerMeasurementProfile([
                    'business_id' => $business->id,
                    'customer_id' => $customer->id,
                    'client_uuid' => $clientUuid,
                    'version' => 1,
                    'created_by_user_id' => $user->id,
                ]);
            } else {
                if ($profile->customer_id !== $customer->id) {
                    throw ValidationException::withMessages([
                        'profile' => ['This measurement profile belongs to another customer.'],
                    ]);
                }
                $this->ensureVersion($profile, (int) $data['base_version'], 'profile');
                if ($profile->status !== MeasurementStatus::Active) {
                    throw ValidationException::withMessages([
                        'profile' => ['Restore this measurement profile before editing it.'],
                    ]);
                }
                $profile->version++;
            }

            $profile->fill([
                'measurement_template_id' => $template->id,
                'measurement_template_version_id' => $definition->id,
                'name' => $data['name'],
                'preferred_unit' => $data['preferred_unit'],
                'notes' => $data['notes'] ?? null,
            ]);
            $profile->updated_by_user_id = $user->id;
            $profile->save();

            $this->recordOperation(
                $business,
                $user,
                'profile',
                $clientUuid,
                'upsert',
                $hash,
                $profile->version,
                $data['operation_uuid'],
            );

            return ['profile' => $this->loadProfile($profile), 'created' => $created, 'replayed' => false];
        });
    }

    /** @param array<string, mixed> $data
     * @return array{profile: CustomerMeasurementProfile, revision: CustomerMeasurementRevision, replayed: bool}
     */
    public function addRevision(
        Business $business,
        User $user,
        CustomerMeasurementProfile $profile,
        array $data,
    ): array {
        return DB::transaction(function () use ($business, $user, $profile, $data): array {
            $profile = CustomerMeasurementProfile::query()->lockForUpdate()->findOrFail($profile->id);
            $hash = $this->requestHash('revision_create', $profile->client_uuid, $data);
            $operation = $this->replayedOperation($business, $data['operation_uuid'], $hash);
            if ($operation) {
                $revision = CustomerMeasurementRevision::query()
                    ->where('business_id', $business->id)
                    ->where('client_uuid', $data['revision_client_uuid'])
                    ->firstOrFail();

                return [
                    'profile' => $this->loadProfile($profile),
                    'revision' => $this->loadRevision($revision),
                    'replayed' => true,
                ];
            }

            $this->ensureVersion($profile, (int) $data['base_version'], 'profile');
            if ($profile->status !== MeasurementStatus::Active) {
                throw ValidationException::withMessages([
                    'profile' => ['Restore this measurement profile before adding measurements.'],
                ]);
            }

            $definition = MeasurementTemplateVersion::query()
                ->with('fields')
                ->findOrFail($profile->measurement_template_version_id);
            $values = $this->normalizeValues($definition, $profile, $data['values']);

            $revision = $profile->revisions()->create([
                'business_id' => $business->id,
                'client_uuid' => $data['revision_client_uuid'],
                'revision_number' => $profile->latest_revision_number + 1,
                'measurement_template_version_id' => $definition->id,
                'values' => $values,
                'notes' => $data['notes'] ?? null,
                'measured_at' => $data['measured_at'],
                'created_by_user_id' => $user->id,
            ]);

            $profile->forceFill([
                'latest_revision_number' => $revision->revision_number,
                'version' => $profile->version + 1,
                'updated_by_user_id' => $user->id,
            ])->save();

            $this->recordOperation(
                $business,
                $user,
                'profile',
                $profile->client_uuid,
                'revision_create',
                $hash,
                $profile->version,
                $data['operation_uuid'],
            );

            return [
                'profile' => $this->loadProfile($profile),
                'revision' => $this->loadRevision($revision),
                'replayed' => false,
            ];
        });
    }

    /** @param array<string, mixed> $data */
    public function changeProfileStatus(
        Business $business,
        User $user,
        CustomerMeasurementProfile $profile,
        array $data,
        MeasurementStatus $status,
    ): CustomerMeasurementProfile {
        return DB::transaction(function () use ($business, $user, $profile, $data, $status): CustomerMeasurementProfile {
            $action = $status === MeasurementStatus::Archived ? 'archive' : 'restore';
            $hash = $this->requestHash("profile_{$action}", $profile->client_uuid, $data);
            $replayed = $this->replayedProfile(
                $business,
                $data['operation_uuid'],
                $hash,
                $profile->client_uuid,
            );
            if ($replayed) {
                return $this->loadProfile($replayed);
            }

            $profile = CustomerMeasurementProfile::query()->lockForUpdate()->findOrFail($profile->id);
            $this->ensureVersion($profile, (int) $data['base_version'], 'profile');
            if ($profile->status === $status) {
                throw ValidationException::withMessages([
                    'profile' => [$status === MeasurementStatus::Archived
                        ? 'This measurement profile is already archived.'
                        : 'This measurement profile is already active.'],
                ]);
            }

            $profile->forceFill([
                'status' => $status,
                'version' => $profile->version + 1,
                'updated_by_user_id' => $user->id,
                'archived_at' => $status === MeasurementStatus::Archived ? now() : null,
            ])->save();

            $this->recordOperation(
                $business,
                $user,
                'profile',
                $profile->client_uuid,
                $action,
                $hash,
                $profile->version,
                $data['operation_uuid'],
            );

            return $this->loadProfile($profile);
        });
    }

    public function accessibleTemplate(Business $business, string $clientUuid): MeasurementTemplate
    {
        return MeasurementTemplate::query()
            ->where('client_uuid', $clientUuid)
            ->where(function ($query) use ($business): void {
                $query->whereNull('business_id')->orWhere('business_id', $business->id);
            })
            ->firstOrFail();
    }

    /** @param array<int, array<string, mixed>> $fields */
    private function createFields(MeasurementTemplateVersion $definition, array $fields): void
    {
        foreach ($fields as $field) {
            $definition->fields()->create(Arr::only($field, [
                'client_uuid', 'field_key', 'label', 'label_ur', 'label_roman_ur',
                'section', 'value_type', 'unit_type', 'is_required',
                'minimum_value_mm', 'maximum_value_mm', 'sort_order',
                'help_text', 'help_text_ur', 'help_text_roman_ur',
            ]));
        }
    }

    /** @param array<int, array<string, mixed>> $submitted
     * @return array<int, array<string, mixed>>
     */
    private function normalizeValues(
        MeasurementTemplateVersion $definition,
        CustomerMeasurementProfile $profile,
        array $submitted,
    ): array {
        $fields = $definition->fields->keyBy('client_uuid');
        $submittedByUuid = collect($submitted)->keyBy('field_uuid');
        $errors = [];

        foreach ($fields as $field) {
            if ($field->is_required && ! $submittedByUuid->has($field->client_uuid)) {
                $errors['values'][] = "Enter {$field->label}.";
            }
        }

        $normalized = [];
        foreach ($submitted as $index => $item) {
            /** @var MeasurementTemplateField|null $field */
            $field = $fields->get($item['field_uuid']);
            if (! $field) {
                $errors["values.{$index}.field_uuid"][] = 'This field does not belong to the selected template version.';

                continue;
            }

            if ($field->value_type === 'text') {
                $value = trim((string) $item['value']);
                if ($value === '') {
                    $errors["values.{$index}.value"][] = "Enter {$field->label}.";

                    continue;
                }
                if (mb_strlen($value) > 500) {
                    $errors["values.{$index}.value"][] = "{$field->label} must not exceed 500 characters.";

                    continue;
                }
                $normalized[] = [
                    'field_uuid' => $field->client_uuid,
                    'value' => $value,
                    'unit' => null,
                    'value_mm' => null,
                ];

                continue;
            }

            if (! is_numeric($item['value'])) {
                $errors["values.{$index}.value"][] = "Enter a valid number for {$field->label}.";

                continue;
            }
            $value = (float) $item['value'];
            if ($value <= 0 || $value > 10000) {
                $errors["values.{$index}.value"][] = "Enter a valid value for {$field->label}.";

                continue;
            }
            $unit = $field->unit_type === 'length'
                ? ($item['unit'] ?? $profile->preferred_unit->value)
                : null;
            $valueMm = $field->unit_type === 'length'
                ? round($unit === 'inch' ? $value * 25.4 : $value * 10, 2)
                : $value;

            if ($field->minimum_value_mm !== null && $valueMm < (float) $field->minimum_value_mm) {
                $errors["values.{$index}.value"][] = "{$field->label} is below the allowed minimum.";
            }
            if ($field->maximum_value_mm !== null && $valueMm > (float) $field->maximum_value_mm) {
                $errors["values.{$index}.value"][] = "{$field->label} exceeds the allowed maximum.";
            }

            $normalized[] = [
                'field_uuid' => $field->client_uuid,
                'value' => number_format($value, 3, '.', ''),
                'unit' => $unit,
                'value_mm' => number_format($valueMm, 2, '.', ''),
            ];
        }

        if ($errors) {
            throw ValidationException::withMessages($errors);
        }

        return $normalized;
    }

    private function ensureVersion(Model $record, int $baseVersion, string $entityType): void
    {
        if ((int) $record->getAttribute('version') !== $baseVersion) {
            throw new MeasurementVersionConflict($record, $entityType);
        }
    }

    private function replayedTemplate(
        Business $business,
        string $operationUuid,
        string $hash,
        string $clientUuid,
    ): ?MeasurementTemplate {
        if (! $this->replayedOperation($business, $operationUuid, $hash)) {
            return null;
        }

        return MeasurementTemplate::query()
            ->where('business_id', $business->id)
            ->where('client_uuid', $clientUuid)
            ->firstOrFail();
    }

    private function replayedProfile(
        Business $business,
        string $operationUuid,
        string $hash,
        string $clientUuid,
    ): ?CustomerMeasurementProfile {
        if (! $this->replayedOperation($business, $operationUuid, $hash)) {
            return null;
        }

        return CustomerMeasurementProfile::query()
            ->where('business_id', $business->id)
            ->where('client_uuid', $clientUuid)
            ->firstOrFail();
    }

    private function replayedOperation(Business $business, string $operationUuid, string $hash): ?MeasurementOperation
    {
        $operation = MeasurementOperation::query()
            ->where('business_id', $business->id)
            ->where('operation_uuid', $operationUuid)
            ->lockForUpdate()
            ->first();

        if (! $operation) {
            return null;
        }
        if (! hash_equals($operation->request_hash, $hash)) {
            throw new MeasurementOperationConflict;
        }

        return $operation;
    }

    private function recordOperation(
        Business $business,
        User $user,
        string $entityType,
        string $entityClientUuid,
        string $action,
        string $hash,
        int $responseVersion,
        string $operationUuid,
    ): void {
        MeasurementOperation::query()->create([
            'business_id' => $business->id,
            'user_id' => $user->id,
            'operation_uuid' => $operationUuid,
            'entity_type' => $entityType,
            'entity_client_uuid' => $entityClientUuid,
            'action' => $action,
            'request_hash' => $hash,
            'response_version' => $responseVersion,
        ]);
    }

    /** @param array<string, mixed> $data */
    private function requestHash(string $action, string $clientUuid, array $data): string
    {
        return hash('sha256', json_encode([
            'action' => $action,
            'client_uuid' => $clientUuid,
            'data' => $this->canonicalize($data),
        ], JSON_THROW_ON_ERROR));
    }

    private function canonicalize(mixed $value): mixed
    {
        if (! is_array($value)) {
            return $value;
        }
        if (array_is_list($value)) {
            return array_map(fn (mixed $item): mixed => $this->canonicalize($item), $value);
        }
        ksort($value);

        return array_map(fn (mixed $item): mixed => $this->canonicalize($item), $value);
    }

    private function loadTemplate(MeasurementTemplate $template): MeasurementTemplate
    {
        return $template->load(['sourceTemplate', 'currentDefinition.fields']);
    }

    private function loadProfile(CustomerMeasurementProfile $profile): CustomerMeasurementProfile
    {
        return $profile->load(['customer', 'template', 'templateVersion', 'latestRevision.templateVersion']);
    }

    private function loadRevision(CustomerMeasurementRevision $revision): CustomerMeasurementRevision
    {
        return $revision->load(['profile', 'templateVersion']);
    }
}
