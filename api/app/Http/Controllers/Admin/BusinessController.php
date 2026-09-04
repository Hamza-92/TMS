<?php

namespace App\Http\Controllers\Admin;

use App\Enums\BusinessRole;
use App\Enums\BusinessStatus;
use App\Enums\MembershipStatus;
use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\BusinessIndexRequest;
use App\Http\Requests\Admin\SuspendBusinessRequest;
use App\Models\AdminUser;
use App\Models\Business;
use App\Services\Admin\BusinessStatusService;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class BusinessController extends Controller
{
    public function index(BusinessIndexRequest $request): View
    {
        $filters = $request->validated();
        $search = trim((string) ($filters['q'] ?? ''));
        $status = $filters['status'] ?? null;
        $subscription = $filters['subscription'] ?? null;

        $businesses = Business::query()
            ->with([
                'creator:id,name,phone_e164',
                'latestSubscription.plan:id,name',
            ])
            ->withCount([
                'memberships as active_members_count' => fn (Builder $query) => $query
                    ->where('status', MembershipStatus::Active->value),
            ])
            ->when($search !== '', function (Builder $query) use ($search): void {
                $query->where(function (Builder $query) use ($search): void {
                    $query
                        ->where('name', 'like', "%{$search}%")
                        ->orWhere('phone_e164', 'like', "%{$search}%")
                        ->orWhereHas('creator', function (Builder $query) use ($search): void {
                            $query
                                ->where('name', 'like', "%{$search}%")
                                ->orWhere('phone_e164', 'like', "%{$search}%");
                        });
                });
            })
            ->when($status, fn (Builder $query, string $status) => $query->where('status', $status))
            ->when($subscription === 'none', fn (Builder $query) => $query->whereDoesntHave('subscriptions'))
            ->when(
                $subscription && $subscription !== 'none',
                fn (Builder $query) => $query->whereHas(
                    'latestSubscription',
                    fn (Builder $query) => $query->where('status', $subscription),
                ),
            )
            ->latest()
            ->paginate(15)
            ->withQueryString();

        return view('admin.businesses.index', [
            'businesses' => $businesses,
            'filters' => [
                'q' => $search,
                'status' => $status,
                'subscription' => $subscription,
            ],
            'statusCounts' => [
                'all' => Business::query()->count(),
                'active' => Business::query()->where('status', BusinessStatus::Active->value)->count(),
                'suspended' => Business::query()->where('status', BusinessStatus::Suspended->value)->count(),
                'closed' => Business::query()->where('status', BusinessStatus::Closed->value)->count(),
            ],
        ]);
    }

    public function show(Business $business): View
    {
        $business->load([
            'creator:id,name,phone_e164,email,preferred_locale,last_login_at',
            'latestSubscription.plan:id,name,code,billing_period,price,currency_code',
        ])->loadCount(['memberships', 'subscriptionPayments']);

        $memberships = $business->memberships()
            ->with('user:id,name,phone_e164,email,status,last_login_at')
            ->oldest('created_at')
            ->limit(25)
            ->get();

        $subscriptions = $business->subscriptions()
            ->with(['plan:id,name,code', 'activatedBy:id,name'])
            ->latest('starts_at')
            ->limit(10)
            ->get();

        $payments = $business->subscriptionPayments()
            ->with(['plan:id,name', 'submittedBy:id,name,phone_e164', 'verifiedBy:id,name'])
            ->latest('created_at')
            ->limit(10)
            ->get();

        $auditLogs = $business->auditLogs()
            ->with('adminUser:id,name')
            ->latest('created_at')
            ->limit(10)
            ->get();

        return view('admin.businesses.show', [
            'business' => $business,
            'memberships' => $memberships,
            'ownerMembership' => $memberships->first(
                fn ($membership) => $membership->role === BusinessRole::Owner,
            ),
            'subscriptions' => $subscriptions,
            'payments' => $payments,
            'auditLogs' => $auditLogs,
        ]);
    }

    public function suspend(
        SuspendBusinessRequest $request,
        Business $business,
        BusinessStatusService $statusService,
    ): RedirectResponse {
        /** @var AdminUser $admin */
        $admin = $request->user('admin');

        $statusService->suspend(
            business: $business,
            admin: $admin,
            reason: $request->string('reason')->trim()->value(),
            ipAddress: $request->ip(),
            userAgent: $request->userAgent(),
        );

        return to_route('admin.businesses.show', $business)
            ->with('status', "{$business->name} has been suspended. App access is now paused.");
    }

    public function reactivate(
        Request $request,
        Business $business,
        BusinessStatusService $statusService,
    ): RedirectResponse {
        /** @var AdminUser $admin */
        $admin = $request->user('admin');

        $statusService->reactivate(
            business: $business,
            admin: $admin,
            ipAddress: $request->ip(),
            userAgent: $request->userAgent(),
        );

        return to_route('admin.businesses.show', $business)
            ->with('status', "{$business->name} has been reactivated.");
    }
}
