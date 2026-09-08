<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\CustomerStatus;
use App\Exceptions\CustomerLimitReached;
use App\Exceptions\CustomerOperationConflict;
use App\Exceptions\CustomerVersionConflict;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\V1\CustomerIndexRequest;
use App\Http\Requests\Api\V1\CustomerStateRequest;
use App\Http\Requests\Api\V1\UpsertCustomerRequest;
use App\Http\Resources\Api\V1\CustomerResource;
use App\Models\Business;
use App\Models\Customer;
use App\Models\Subscription;
use App\Models\User;
use App\Services\Customers\CustomerMutationService;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class CustomerController extends Controller
{
    public function __construct(private readonly CustomerMutationService $mutationService) {}

    public function index(CustomerIndexRequest $request, Business $business): JsonResponse
    {
        $data = $request->validated();
        $status = $data['status'] ?? 'active';
        $search = $data['search'] ?? null;

        $query = $business->customers()
            ->when($status !== 'all', fn (Builder $query) => $query->where('status', $status))
            ->when($search, function (Builder $query, string $search): void {
                $like = '%'.addcslashes($search, '%_\\').'%';
                $query->where(function (Builder $query) use ($like): void {
                    $query->where('name', 'like', $like)
                        ->orWhere('phone_e164', 'like', $like)
                        ->orWhere('alternate_phone_e164', 'like', $like);
                });
            })
            ->when(
                $data['updated_since'] ?? null,
                fn (Builder $query, string $updatedSince) => $query->where('updated_at', '>', $updatedSince),
            )
            ->orderBy('name')
            ->orderBy('id');

        $customers = $query->paginate((int) ($data['per_page'] ?? 50));

        return response()->json([
            'success' => true,
            'data' => CustomerResource::collection($customers->items())->resolve($request),
            'meta' => [
                'current_page' => $customers->currentPage(),
                'last_page' => $customers->lastPage(),
                'per_page' => $customers->perPage(),
                'total' => $customers->total(),
                'synced_at' => now()->toIso8601String(),
            ],
        ]);
    }

    public function show(Request $request, Business $business, string $customer): JsonResponse
    {
        $model = $this->findCustomer($business, $customer);

        return response()->json([
            'success' => true,
            'data' => CustomerResource::make($model)->resolve($request),
        ]);
    }

    public function upsert(UpsertCustomerRequest $request, Business $business, string $customer): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        /** @var Subscription|null $subscription */
        $subscription = $request->attributes->get('business_subscription');

        try {
            $result = $this->mutationService->upsert(
                $business,
                $user,
                $subscription,
                $customer,
                $request->validated(),
            );
        } catch (CustomerVersionConflict $exception) {
            return $this->versionConflict($request, $exception);
        } catch (CustomerOperationConflict $exception) {
            return $this->operationConflict($exception);
        } catch (CustomerLimitReached $exception) {
            return $this->limitReached($exception);
        }

        return response()->json([
            'success' => true,
            'message' => $result['created'] ? 'Customer created.' : 'Customer updated.',
            'data' => CustomerResource::make($result['customer'])->resolve($request),
            'meta' => ['replayed' => $result['replayed']],
        ], $result['created'] ? 201 : 200);
    }

    public function archive(CustomerStateRequest $request, Business $business, string $customer): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();

        try {
            $model = $this->mutationService->archive($business, $user, $customer, $request->validated());
        } catch (CustomerVersionConflict $exception) {
            return $this->versionConflict($request, $exception);
        } catch (CustomerOperationConflict $exception) {
            return $this->operationConflict($exception);
        }

        return response()->json([
            'success' => true,
            'message' => 'Customer archived.',
            'data' => CustomerResource::make($model)->resolve($request),
        ]);
    }

    public function restore(CustomerStateRequest $request, Business $business, string $customer): JsonResponse
    {
        /** @var User $user */
        $user = $request->user();
        /** @var Subscription|null $subscription */
        $subscription = $request->attributes->get('business_subscription');

        try {
            $model = $this->mutationService->restore(
                $business,
                $user,
                $subscription,
                $customer,
                $request->validated(),
            );
        } catch (CustomerVersionConflict $exception) {
            return $this->versionConflict($request, $exception);
        } catch (CustomerOperationConflict $exception) {
            return $this->operationConflict($exception);
        } catch (CustomerLimitReached $exception) {
            return $this->limitReached($exception);
        }

        return response()->json([
            'success' => true,
            'message' => 'Customer restored.',
            'data' => CustomerResource::make($model)->resolve($request),
        ]);
    }

    public function deletePermanently(
        CustomerStateRequest $request,
        Business $business,
        string $customer,
    ): JsonResponse {
        /** @var User $user */
        $user = $request->user();

        try {
            $result = $this->mutationService->deletePermanently(
                $business,
                $user,
                $customer,
                $request->validated(),
            );
        } catch (CustomerVersionConflict $exception) {
            return $this->versionConflict($request, $exception);
        } catch (CustomerOperationConflict $exception) {
            return $this->operationConflict($exception);
        }

        if ($result['photo_path']) {
            Storage::disk('public')->delete($result['photo_path']);
        }

        return response()->json([
            'success' => true,
            'message' => 'Customer permanently deleted.',
            'data' => CustomerResource::make($result['customer'])->resolve($request),
            'meta' => ['replayed' => $result['replayed']],
        ]);
    }

    public function updatePhoto(Request $request, Business $business, string $customer): JsonResponse
    {
        $request->validate([
            'photo' => ['required', 'image', 'mimes:jpeg,jpg,png,webp', 'max:5120'],
        ], [
            'photo.required' => 'Choose a customer photo.',
            'photo.image' => 'The selected file must be an image.',
            'photo.mimes' => 'Use a JPG, PNG, or WebP image.',
            'photo.max' => 'The customer photo must not exceed 5 MB.',
        ]);

        $model = $this->findCustomer($business, $customer);
        $path = $request->file('photo')->store(
            "businesses/{$business->id}/customers",
            'public',
        );

        $previousPath = $model->photo_path;
        $model->forceFill(['photo_path' => $path])->save();
        if ($previousPath && $previousPath !== $path) {
            Storage::disk('public')->delete($previousPath);
        }

        return response()->json([
            'success' => true,
            'message' => 'Customer photo updated.',
            'data' => CustomerResource::make($model->fresh())->resolve($request),
        ]);
    }

    public function removePhoto(Request $request, Business $business, string $customer): JsonResponse
    {
        $model = $this->findCustomer($business, $customer);
        $previousPath = $model->photo_path;
        $model->forceFill(['photo_path' => null])->save();
        if ($previousPath) {
            Storage::disk('public')->delete($previousPath);
        }

        return response()->json([
            'success' => true,
            'message' => 'Customer photo removed.',
            'data' => CustomerResource::make($model->fresh())->resolve($request),
        ]);
    }

    private function findCustomer(Business $business, string $clientUuid): Customer
    {
        return $business->customers()
            ->where('client_uuid', $clientUuid)
            ->where('status', '!=', CustomerStatus::Deleted->value)
            ->firstOrFail();
    }

    private function versionConflict(Request $request, CustomerVersionConflict $exception): JsonResponse
    {
        return response()->json([
            'success' => false,
            'message' => $exception->getMessage(),
            'code' => 'customer_version_conflict',
            'data' => [
                'customer' => CustomerResource::make($exception->customer)->resolve($request),
            ],
        ], 409);
    }

    private function operationConflict(CustomerOperationConflict $exception): JsonResponse
    {
        return response()->json([
            'success' => false,
            'message' => $exception->getMessage(),
            'code' => 'customer_operation_conflict',
        ], 409);
    }

    private function limitReached(CustomerLimitReached $exception): JsonResponse
    {
        return response()->json([
            'success' => false,
            'message' => $exception->getMessage(),
            'code' => 'customer_limit_reached',
            'data' => ['limit' => $exception->limit],
        ], 422);
    }
}
