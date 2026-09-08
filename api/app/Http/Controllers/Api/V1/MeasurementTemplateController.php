<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\BusinessRole;
use App\Enums\MeasurementStatus;
use App\Exceptions\MeasurementOperationConflict;
use App\Exceptions\MeasurementVersionConflict;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\V1\MeasurementStateRequest;
use App\Http\Requests\Api\V1\MeasurementTemplateIndexRequest;
use App\Http\Requests\Api\V1\UpsertMeasurementTemplateRequest;
use App\Http\Resources\Api\V1\MeasurementTemplateResource;
use App\Http\Resources\Api\V1\MeasurementTemplateVersionResource;
use App\Models\Business;
use App\Models\BusinessMember;
use App\Models\MeasurementTemplate;
use App\Models\User;
use App\Services\Measurements\MeasurementMutationService;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MeasurementTemplateController extends Controller
{
    public function __construct(private readonly MeasurementMutationService $mutationService) {}

    public function index(MeasurementTemplateIndexRequest $request, Business $business): JsonResponse
    {
        $data = $request->validated();
        $status = $data['status'] ?? 'active';
        $search = $data['search'] ?? null;

        $query = MeasurementTemplate::query()
            ->with(['sourceTemplate', 'currentDefinition.fields'])
            ->where(function (Builder $query) use ($business): void {
                $query->whereNull('business_id')->orWhere('business_id', $business->id);
            })
            ->when($status !== 'all', fn (Builder $query) => $query->where('status', $status))
            ->when($data['category'] ?? null, fn (Builder $query, string $category) => $query->where('category', $category))
            ->when($search, function (Builder $query, string $search): void {
                $like = '%'.addcslashes($search, '%_\\').'%';
                $query->where(function (Builder $query) use ($like): void {
                    $query->where('name', 'like', $like)
                        ->orWhere('name_ur', 'like', $like)
                        ->orWhere('name_roman_ur', 'like', $like);
                });
            })
            ->when(
                $data['updated_since'] ?? null,
                fn (Builder $query, string $updatedSince) => $query->where('updated_at', '>', $updatedSince),
            )
            ->orderByRaw('business_id is not null')
            ->orderBy('category')
            ->orderBy('name');

        $templates = $query->paginate((int) ($data['per_page'] ?? 50));

        return response()->json([
            'success' => true,
            'data' => MeasurementTemplateResource::collection($templates->items())->resolve($request),
            'meta' => [
                'current_page' => $templates->currentPage(),
                'last_page' => $templates->lastPage(),
                'per_page' => $templates->perPage(),
                'total' => $templates->total(),
                'synced_at' => now()->toIso8601String(),
            ],
        ]);
    }

    public function show(Request $request, Business $business, string $template): JsonResponse
    {
        $model = $this->mutationService->accessibleTemplate($business, $template)
            ->load(['sourceTemplate', 'currentDefinition.fields']);

        return response()->json([
            'success' => true,
            'data' => MeasurementTemplateResource::make($model)->resolve($request),
        ]);
    }

    public function version(
        Request $request,
        Business $business,
        string $template,
        int $version,
    ): JsonResponse {
        $model = $this->mutationService->accessibleTemplate($business, $template);
        $definition = $model->versions()
            ->with(['template', 'fields'])
            ->where('version_number', $version)
            ->firstOrFail();

        return response()->json([
            'success' => true,
            'data' => MeasurementTemplateVersionResource::make($definition)->resolve($request),
        ]);
    }

    public function upsert(
        UpsertMeasurementTemplateRequest $request,
        Business $business,
        string $template,
    ): JsonResponse {
        if ($denied = $this->managePermissionDenied($request)) {
            return $denied;
        }

        /** @var User $user */
        $user = $request->user();
        try {
            $result = $this->mutationService->upsertTemplate($business, $user, $template, $request->validated());
        } catch (MeasurementVersionConflict $exception) {
            return $this->versionConflict($request, $exception);
        } catch (MeasurementOperationConflict $exception) {
            return $this->operationConflict($exception);
        }

        return response()->json([
            'success' => true,
            'message' => $result['created'] ? 'Measurement template created.' : 'Measurement template updated.',
            'data' => MeasurementTemplateResource::make($result['template'])->resolve($request),
            'meta' => ['replayed' => $result['replayed']],
        ], $result['created'] ? 201 : 200);
    }

    public function archive(MeasurementStateRequest $request, Business $business, string $template): JsonResponse
    {
        return $this->changeStatus($request, $business, $template, MeasurementStatus::Archived);
    }

    public function restore(MeasurementStateRequest $request, Business $business, string $template): JsonResponse
    {
        return $this->changeStatus($request, $business, $template, MeasurementStatus::Active);
    }

    private function changeStatus(
        MeasurementStateRequest $request,
        Business $business,
        string $template,
        MeasurementStatus $status,
    ): JsonResponse {
        if ($denied = $this->managePermissionDenied($request)) {
            return $denied;
        }

        /** @var User $user */
        $user = $request->user();
        try {
            $model = $this->mutationService->changeTemplateStatus(
                $business,
                $user,
                $template,
                $request->validated(),
                $status,
            );
        } catch (MeasurementVersionConflict $exception) {
            return $this->versionConflict($request, $exception);
        } catch (MeasurementOperationConflict $exception) {
            return $this->operationConflict($exception);
        }

        return response()->json([
            'success' => true,
            'message' => $status === MeasurementStatus::Archived
                ? 'Measurement template archived.'
                : 'Measurement template restored.',
            'data' => MeasurementTemplateResource::make($model)->resolve($request),
        ]);
    }

    private function managePermissionDenied(Request $request): ?JsonResponse
    {
        /** @var BusinessMember|null $membership */
        $membership = $request->attributes->get('business_membership');
        if ($membership && in_array($membership->role, [BusinessRole::Owner, BusinessRole::Manager], true)) {
            return null;
        }

        return response()->json([
            'success' => false,
            'message' => 'Only an owner or manager can change measurement templates.',
            'code' => 'measurement_template_permission_denied',
        ], 403);
    }

    private function versionConflict(Request $request, MeasurementVersionConflict $exception): JsonResponse
    {
        /** @var MeasurementTemplate $template */
        $template = $exception->record;

        return response()->json([
            'success' => false,
            'message' => $exception->getMessage(),
            'code' => 'measurement_template_version_conflict',
            'data' => [
                'template' => MeasurementTemplateResource::make(
                    $template->load(['sourceTemplate', 'currentDefinition.fields']),
                )->resolve($request),
            ],
        ], 409);
    }

    private function operationConflict(MeasurementOperationConflict $exception): JsonResponse
    {
        return response()->json([
            'success' => false,
            'message' => $exception->getMessage(),
            'code' => 'measurement_operation_conflict',
        ], 409);
    }
}
