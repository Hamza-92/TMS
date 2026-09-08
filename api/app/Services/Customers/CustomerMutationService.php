<?php

namespace App\Services\Customers;

use App\Enums\CustomerStatus;
use App\Exceptions\CustomerLimitReached;
use App\Exceptions\CustomerOperationConflict;
use App\Exceptions\CustomerVersionConflict;
use App\Models\Business;
use App\Models\Customer;
use App\Models\CustomerOperation;
use App\Models\Subscription;
use App\Models\User;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class CustomerMutationService
{
    /** @param array<string, mixed> $data
     * @return array{customer: Customer, created: bool, replayed: bool}
     */
    public function upsert(
        Business $business,
        User $user,
        ?Subscription $subscription,
        string $clientUuid,
        array $data,
    ): array {
        return DB::transaction(function () use ($business, $user, $subscription, $clientUuid, $data): array {
            $hash = $this->requestHash('upsert', $clientUuid, $data);
            $replayed = $this->replayed($business, $data['operation_uuid'], $hash, $clientUuid);

            if ($replayed) {
                return ['customer' => $replayed, 'created' => false, 'replayed' => true];
            }

            $customer = Customer::query()
                ->where('business_id', $business->id)
                ->where('client_uuid', $clientUuid)
                ->lockForUpdate()
                ->first();
            $created = ! $customer;

            if ($created) {
                if ((int) $data['base_version'] !== 0) {
                    throw ValidationException::withMessages([
                        'base_version' => ['Use version 0 when creating a customer.'],
                    ]);
                }

                $this->ensureWithinLimit($business, $subscription);
                $customer = new Customer([
                    'business_id' => $business->id,
                    'client_uuid' => $clientUuid,
                    'created_by_user_id' => $user->id,
                    'status' => CustomerStatus::Active,
                    'version' => 1,
                ]);
            } else {
                $this->ensureVersion($customer, (int) $data['base_version']);

                if ($customer->status === CustomerStatus::Deleted) {
                    throw ValidationException::withMessages([
                        'customer' => ['This customer has been permanently deleted.'],
                    ]);
                }

                if ($customer->status === CustomerStatus::Archived) {
                    throw ValidationException::withMessages([
                        'customer' => ['Restore this customer before editing it.'],
                    ]);
                }

                $customer->version++;
            }

            $customer->fill(Arr::only($data, [
                'name',
                'phone_e164',
                'alternate_phone_e164',
                'address',
                'notes',
            ]));
            $customer->updated_by_user_id = $user->id;
            $customer->save();

            $this->recordOperation($business, $user, $customer, $data['operation_uuid'], 'upsert', $hash);

            return ['customer' => $customer, 'created' => $created, 'replayed' => false];
        });
    }

    /** @param array<string, mixed> $data */
    public function archive(Business $business, User $user, string $clientUuid, array $data): Customer
    {
        return $this->changeStatus($business, $user, null, $clientUuid, $data, CustomerStatus::Archived);
    }

    /** @param array<string, mixed> $data */
    public function restore(
        Business $business,
        User $user,
        ?Subscription $subscription,
        string $clientUuid,
        array $data,
    ): Customer {
        return $this->changeStatus($business, $user, $subscription, $clientUuid, $data, CustomerStatus::Active);
    }

    /** @param array<string, mixed> $data
     * @return array{customer: Customer, replayed: bool, photo_path: ?string}
     */
    public function deletePermanently(
        Business $business,
        User $user,
        string $clientUuid,
        array $data,
    ): array {
        return DB::transaction(function () use ($business, $user, $clientUuid, $data): array {
            $hash = $this->requestHash('delete', $clientUuid, $data);
            $replayed = $this->replayed($business, $data['operation_uuid'], $hash, $clientUuid);

            if ($replayed) {
                return ['customer' => $replayed, 'replayed' => true, 'photo_path' => null];
            }

            $customer = Customer::query()
                ->where('business_id', $business->id)
                ->where('client_uuid', $clientUuid)
                ->lockForUpdate()
                ->firstOrFail();
            $this->ensureVersion($customer, (int) $data['base_version']);

            if ($customer->status !== CustomerStatus::Archived) {
                throw ValidationException::withMessages([
                    'customer' => ['Archive this customer before deleting it permanently.'],
                ]);
            }

            $photoPath = $customer->photo_path;
            $customer->measurementProfiles()->delete();
            $customer->forceFill([
                'name' => 'Deleted customer',
                'phone_e164' => null,
                'alternate_phone_e164' => null,
                'address' => null,
                'notes' => null,
                'photo_path' => null,
                'status' => CustomerStatus::Deleted,
                'version' => $customer->version + 1,
                'updated_by_user_id' => $user->id,
            ])->save();

            $this->recordOperation($business, $user, $customer, $data['operation_uuid'], 'delete', $hash);

            return ['customer' => $customer, 'replayed' => false, 'photo_path' => $photoPath];
        });
    }

    /** @param array<string, mixed> $data */
    private function changeStatus(
        Business $business,
        User $user,
        ?Subscription $subscription,
        string $clientUuid,
        array $data,
        CustomerStatus $status,
    ): Customer {
        return DB::transaction(function () use ($business, $user, $subscription, $clientUuid, $data, $status): Customer {
            $action = $status === CustomerStatus::Archived ? 'archive' : 'restore';
            $hash = $this->requestHash($action, $clientUuid, $data);
            $replayed = $this->replayed($business, $data['operation_uuid'], $hash, $clientUuid);

            if ($replayed) {
                return $replayed;
            }

            $customer = Customer::query()
                ->where('business_id', $business->id)
                ->where('client_uuid', $clientUuid)
                ->lockForUpdate()
                ->firstOrFail();
            $this->ensureVersion($customer, (int) $data['base_version']);

            if ($customer->status === CustomerStatus::Deleted) {
                throw ValidationException::withMessages([
                    'customer' => ['This customer has been permanently deleted.'],
                ]);
            }

            if ($customer->status === $status) {
                throw ValidationException::withMessages([
                    'customer' => [$status === CustomerStatus::Archived
                        ? 'This customer is already archived.'
                        : 'This customer is already active.'],
                ]);
            }

            if ($status === CustomerStatus::Active) {
                $this->ensureWithinLimit($business, $subscription);
            }

            $customer->forceFill([
                'status' => $status,
                'version' => $customer->version + 1,
                'updated_by_user_id' => $user->id,
                'archived_at' => $status === CustomerStatus::Archived ? now() : null,
            ])->save();

            $this->recordOperation($business, $user, $customer, $data['operation_uuid'], $action, $hash);

            return $customer;
        });
    }

    private function ensureVersion(Customer $customer, int $baseVersion): void
    {
        if ($customer->version !== $baseVersion) {
            throw new CustomerVersionConflict($customer);
        }
    }

    private function ensureWithinLimit(Business $business, ?Subscription $subscription): void
    {
        $limit = (int) data_get($subscription?->plan?->limits, 'customers', 0);

        if ($limit > 0 && $business->customers()->where('status', CustomerStatus::Active)->count() >= $limit) {
            throw new CustomerLimitReached($limit);
        }
    }

    private function replayed(Business $business, string $operationUuid, string $hash, string $clientUuid): ?Customer
    {
        $operation = CustomerOperation::query()
            ->where('business_id', $business->id)
            ->where('operation_uuid', $operationUuid)
            ->lockForUpdate()
            ->first();

        if (! $operation) {
            return null;
        }

        if (! hash_equals($operation->request_hash, $hash)) {
            throw new CustomerOperationConflict;
        }

        return Customer::query()
            ->where('business_id', $business->id)
            ->where('client_uuid', $clientUuid)
            ->firstOrFail();
    }

    private function recordOperation(
        Business $business,
        User $user,
        Customer $customer,
        string $operationUuid,
        string $action,
        string $hash,
    ): void {
        CustomerOperation::query()->create([
            'business_id' => $business->id,
            'user_id' => $user->id,
            'operation_uuid' => $operationUuid,
            'customer_client_uuid' => $customer->client_uuid,
            'action' => $action,
            'request_hash' => $hash,
            'response_version' => $customer->version,
        ]);
    }

    /** @param array<string, mixed> $data */
    private function requestHash(string $action, string $clientUuid, array $data): string
    {
        return hash('sha256', json_encode([
            'action' => $action,
            'client_uuid' => $clientUuid,
            'data' => $data,
        ], JSON_THROW_ON_ERROR));
    }
}
