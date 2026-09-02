<?php

namespace App\Http\Controllers\Admin;

use App\Enums\BusinessStatus;
use App\Enums\PaymentStatus;
use App\Enums\SubscriptionStatus;
use App\Http\Controllers\Controller;
use App\Models\Business;
use App\Models\Subscription;
use App\Models\SubscriptionPayment;
use App\Models\User;
use Illuminate\View\View;

class DashboardController extends Controller
{
    public function __invoke(): View
    {
        $usableSubscriptionStatuses = [
            SubscriptionStatus::Trialing->value,
            SubscriptionStatus::Active->value,
            SubscriptionStatus::Grace->value,
        ];

        return view('admin.dashboard', [
            'metrics' => [
                'businesses' => Business::query()->count(),
                'activeBusinesses' => Business::query()
                    ->where('status', BusinessStatus::Active->value)
                    ->count(),
                'users' => User::query()->count(),
                'usableSubscriptions' => Subscription::query()
                    ->whereIn('status', $usableSubscriptionStatuses)
                    ->count(),
                'pendingPayments' => SubscriptionPayment::query()
                    ->where('status', PaymentStatus::Pending->value)
                    ->count(),
            ],
            'recentBusinesses' => Business::query()
                ->with('creator:id,name,phone_e164')
                ->withCount('memberships')
                ->latest()
                ->limit(5)
                ->get(),
            'pendingPayments' => SubscriptionPayment::query()
                ->with(['business:id,name', 'plan:id,name', 'submittedBy:id,name,phone_e164'])
                ->where('status', PaymentStatus::Pending->value)
                ->latest('submitted_at')
                ->limit(5)
                ->get(),
            'expiringTrials' => Subscription::query()
                ->with(['business:id,name', 'plan:id,name'])
                ->where('status', SubscriptionStatus::Trialing->value)
                ->whereBetween('expires_at', [now(), now()->addDays(7)])
                ->orderBy('expires_at')
                ->limit(5)
                ->get(),
        ]);
    }
}
