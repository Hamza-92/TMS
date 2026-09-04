<?php

namespace App\Http\Controllers\Admin;

use App\Enums\PaymentStatus;
use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\PlanIndexRequest;
use App\Http\Requests\Admin\StorePlanRequest;
use App\Http\Requests\Admin\UpdatePlanRequest;
use App\Models\AdminUser;
use App\Models\Plan;
use App\Services\Admin\PlanManagementService;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class PlanController extends Controller
{
    public function index(PlanIndexRequest $request): View
    {
        $filters = $request->validated();
        $search = trim((string) ($filters['q'] ?? ''));
        $status = $filters['status'] ?? null;

        $plans = Plan::query()
            ->withCount([
                'subscriptions',
                'payments',
                'payments as pending_payments_count' => fn (Builder $query) => $query
                    ->where('status', PaymentStatus::Pending->value),
            ])
            ->when($search !== '', function (Builder $query) use ($search): void {
                $query->where(function (Builder $query) use ($search): void {
                    $query
                        ->where('name', 'like', "%{$search}%")
                        ->orWhere('code', 'like', "%{$search}%");
                });
            })
            ->when($status === 'active', fn (Builder $query) => $query->where('is_active', true))
            ->when($status === 'inactive', fn (Builder $query) => $query->where('is_active', false))
            ->orderBy('sort_order')
            ->orderBy('name')
            ->paginate(12)
            ->withQueryString();

        $editingPlan = isset($filters['edit'])
            ? Plan::query()->withCount(['subscriptions', 'payments'])->findOrFail($filters['edit'])
            : null;

        return view('admin.plans.index', [
            'plans' => $plans,
            'editingPlan' => $editingPlan,
            'createMode' => (bool) ($filters['create'] ?? false),
            'filters' => [
                'q' => $search,
                'status' => $status,
            ],
            'counts' => [
                'all' => Plan::query()->count(),
                'active' => Plan::query()->where('is_active', true)->count(),
                'inactive' => Plan::query()->where('is_active', false)->count(),
            ],
        ]);
    }

    public function store(
        StorePlanRequest $request,
        PlanManagementService $managementService,
    ): RedirectResponse {
        /** @var AdminUser $admin */
        $admin = $request->user('admin');
        $plan = $managementService->create(
            data: $request->validated(),
            admin: $admin,
            ipAddress: $request->ip(),
            userAgent: $request->userAgent(),
        );

        return to_route('admin.plans.index', ['edit' => $plan->id])
            ->with('status', "{$plan->name} was created and is ready for payment requests.");
    }

    public function update(
        UpdatePlanRequest $request,
        Plan $plan,
        PlanManagementService $managementService,
    ): RedirectResponse {
        /** @var AdminUser $admin */
        $admin = $request->user('admin');
        $managementService->update(
            plan: $plan,
            data: $request->validated(),
            admin: $admin,
            ipAddress: $request->ip(),
            userAgent: $request->userAgent(),
        );

        return to_route('admin.plans.index', ['edit' => $plan->id])
            ->with('status', "{$plan->name} was updated.");
    }

    public function toggle(
        Request $request,
        Plan $plan,
        PlanManagementService $managementService,
    ): RedirectResponse {
        /** @var AdminUser $admin */
        $admin = $request->user('admin');
        $updatedPlan = $managementService->toggleActive(
            plan: $plan,
            admin: $admin,
            ipAddress: $request->ip(),
            userAgent: $request->userAgent(),
        );

        return back()->with(
            'status',
            $updatedPlan->is_active
                ? "{$updatedPlan->name} is available for new payment requests."
                : "{$updatedPlan->name} is no longer available for new payment requests.",
        );
    }
}
