<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\CustomerStatus;
use App\Enums\MeasurementStatus;
use App\Exceptions\MeasurementOperationConflict;
use App\Exceptions\MeasurementVersionConflict;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\V1\MeasurementProfileIndexRequest;
use App\Http\Requests\Api\V1\MeasurementStateRequest;
use App\Http\Requests\Api\V1\StoreMeasurementRevisionRequest;
use App\Http\Requests\Api\V1\UpsertMeasurementProfileRequest;
use App\Http\Resources\Api\V1\MeasurementProfileResource;
use App\Http\Resources\Api\V1\MeasurementRevisionResource;
use App\Models\Business;
use App\Models\Customer;
use App\Models\CustomerMeasurementProfile;
use App\Models\User;
use App\Services\Measurements\MeasurementMutationService;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CustomerMeasurementController extends Controller
{
    public function __construct(private readonly MeasurementMutationService $mutationService) {}

    public function index(
        MeasurementProfileIndexRequest $request,
        Business $business,
        string $customer,
    ): JsonResponse {
        $customerModel = $this->findCustomer($business, $customer);
        $data = $request->validated();
        $status = $data['status'] ?? 'active';

        $query = $customerModel->measurementProfiles()
            ->with(['customer', 'template', 'templateVersion', 'latestRevision.templateVersion'])
            ->when($status !== 'all', fn (Builder $query) => $query->where('status', $status))
            ->when(
                $data['updated_since'] ?? null,
                fn (Builder $query, string $updatedSince) => $query->where('updated_at', '>', $updatedSince),
            )
            ->orderBy('name')
            ->orderBy('id');
        $profiles = $query->paginate((int) ($data['per_page'] ?? 50));

        return response()->json([
            'success' => true,
            'data' => MeasurementProfileResource::collection($profiles->items())->resolve($request),
            'meta' => [
                'current_page' => $profiles->currentPage(),
                'last_page' => $profiles->lastPage(),
                'per_page' => $profiles->perPage(),
                'total' => $profiles->total(),
                'synced_at' => now()->toIso8601String(),
            ],
        ]);
    }

    public function show(
        Request $request,
        Business $business,
        string $customer,
        string $profile,
    ): JsonResponse {
        $customerModel = $this->findCustomer($business, $customer);
        $model = $this->findProfile($customerModel, $profile)
            ->load(['customer', 'template', 'templateVersion', 'latestRevision.templateVersion']);

        return response()->json([
            'success' => true,
            'data' => MeasurementProfileResource::make($model)->resolve($request),
        ]);
    }

    public function upsert(
        UpsertMeasurementProfileRequest $request,
        Business $business,
        string $customer,
        string $profile,
    ): JsonResponse {
        $customerModel = $this->findCustomer($business, $customer);
        /** @var User $user */
        $user = $request->user();

        try {
            $result = $this->mutationService->upsertProfile(
                $business,
                $user,
                $customerModel,
                $profile,
                $request->validated(),
            );
        } catch (MeasurementVersionConflict $exception) {
            return $this->versionConflict($request, $exception);
        } catch (MeasurementOperationConflict $exception) {
            return $this->operationConflict($exception);
        }

        return response()->json([
            'success' => true,
            'message' => $result['created'] ? 'Measurement profile created.' : 'Measurement profile updated.',
            'data' => MeasurementProfileResource::make($result['profile'])->resolve($request),
            'meta' => ['replayed' => $result['replayed']],
        ], $result['created'] ? 201 : 200);
    }

    public function revisions(
        Request $request,
        Business $business,
        string $customer,
        string $profile,
    ): JsonResponse {
        $customerModel = $this->findCustomer($business, $customer);
        $profileModel = $this->findProfile($customerModel, $profile);
        $revisions = $profileModel->revisions()->with(['profile', 'templateVersion'])->paginate(50);

        return response()->json([
            'success' => true,
            'data' => MeasurementRevisionResource::collection($revisions->items())->resolve($request),
            'meta' => [
                'current_page' => $revisions->currentPage(),
                'last_page' => $revisions->lastPage(),
                'per_page' => $revisions->perPage(),
                'total' => $revisions->total(),
            ],
        ]);
    }

    public function storeRevision(
        StoreMeasurementRevisionRequest $request,
        Business $business,
        string $customer,
        string $profile,
    ): JsonResponse {
        $customerModel = $this->findCustomer($business, $customer);
        $profileModel = $this->findProfile($customerModel, $profile);
        /** @var User $user */
        $user = $request->user();

        try {
            $result = $this->mutationService->addRevision(
                $business,
                $user,
                $profileModel,
                $request->validated(),
            );
        } catch (MeasurementVersionConflict $exception) {
            return $this->versionConflict($request, $exception);
        } catch (MeasurementOperationConflict $exception) {
            return $this->operationConflict($exception);
        }

        return response()->json([
            'success' => true,
            'message' => $result['replayed'] ? 'Measurement revision already saved.' : 'Measurements saved.',
            'data' => [
                'profile' => MeasurementProfileResource::make($result['profile'])->resolve($request),
                'revision' => MeasurementRevisionResource::make($result['revision'])->resolve($request),
            ],
            'meta' => ['replayed' => $result['replayed']],
        ], $result['replayed'] ? 200 : 201);
    }

    public function archive(
        MeasurementStateRequest $request,
        Business $business,
        string $customer,
        string $profile,
    ): JsonResponse {
        return $this->changeStatus($request, $business, $customer, $profile, MeasurementStatus::Archived);
    }

    public function restore(
        MeasurementStateRequest $request,
        Business $business,
        string $customer,
        string $profile,
    ): JsonResponse {
        return $this->changeStatus($request, $business, $customer, $profile, MeasurementStatus::Active);
    }

    private function changeStatus(
        MeasurementStateRequest $request,
        Business $business,
        string $customer,
        string $profile,
        MeasurementStatus $status,
    ): JsonResponse {
        $customerModel = $this->findCustomer($business, $customer);
        $profileModel = $this->findProfile($customerModel, $profile);
        /** @var User $user */
        $user = $request->user();

        try {
            $model = $this->mutationService->changeProfileStatus(
                $business,
                $user,
                $profileModel,
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
                ? 'Measurement profile archived.'
                : 'Measurement profile restored.',
            'data' => MeasurementProfileResource::make($model)->resolve($request),
        ]);
    }

    private function findCustomer(Business $business, string $clientUuid): Customer
    {
        return $business->customers()
            ->where('client_uuid', $clientUuid)
            ->where('status', '!=', CustomerStatus::Deleted->value)
            ->firstOrFail();
    }

    private function findProfile(Customer $customer, string $clientUuid): CustomerMeasurementProfile
    {
        return $customer->measurementProfiles()->where('client_uuid', $clientUuid)->firstOrFail();
    }

    private function versionConflict(Request $request, MeasurementVersionConflict $exception): JsonResponse
    {
        /** @var CustomerMeasurementProfile $profile */
        $profile = $exception->record;

        return response()->json([
            'success' => false,
            'message' => $exception->getMessage(),
            'code' => 'measurement_profile_version_conflict',
            'data' => [
                'profile' => MeasurementProfileResource::make(
                    $profile->load(['customer', 'template', 'templateVersion', 'latestRevision.templateVersion']),
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
