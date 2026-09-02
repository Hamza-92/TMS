<?php

namespace App\Services\Auth;

use App\Enums\BusinessStatus;
use App\Enums\MembershipStatus;
use App\Enums\SubscriptionStatus;
use App\Http\Resources\Api\V1\BusinessResource;
use App\Http\Resources\Api\V1\SubscriptionResource;
use App\Http\Resources\Api\V1\UserResource;
use App\Models\BusinessMember;
use App\Models\Subscription;
use App\Models\User;
use Illuminate\Http\Request;

class AuthBootstrapService
{
    /** @return array<string, mixed> */
    public function forUser(User $user, Request $request): array
    {
        $memberships = $user->businessMemberships()
            ->with(['business.subscriptions.plan'])
            ->get();

        return [
            'user' => UserResource::make($user)->resolve($request),
            'businesses' => $memberships
                ->map(fn (BusinessMember $membership): array => $this->businessContext($membership, $request))
                ->values(),
            'synced_at' => now()->toIso8601String(),
        ];
    }

    /** @return array<string, mixed> */
    private function businessContext(BusinessMember $membership, Request $request): array
    {
        $business = $membership->business;
        $subscription = $business->subscriptions
            ->sortByDesc(fn (Subscription $item): int => $item->starts_at->getTimestamp())
            ->first();

        return [
            ...BusinessResource::make($business)->resolve($request),
            'role' => $membership->role->value,
            'membership_status' => $membership->status->value,
            'business_status' => $business->status->value,
            'subscription' => $subscription
                ? SubscriptionResource::make($subscription)->resolve($request)
                : null,
            'access' => $this->accessFor($membership, $subscription),
        ];
    }

    /** @return array<string, mixed> */
    private function accessFor(BusinessMember $membership, ?Subscription $subscription): array
    {
        if ($membership->status !== MembershipStatus::Active) {
            return $this->blockedAccess('membership_'.$membership->status->value);
        }

        if ($membership->business->status !== BusinessStatus::Active) {
            return $this->blockedAccess('business_'.$membership->business->status->value);
        }

        if (! $subscription) {
            return $this->blockedAccess('subscription_missing');
        }

        if (! in_array($subscription->status, [
            SubscriptionStatus::Trialing,
            SubscriptionStatus::Active,
            SubscriptionStatus::Grace,
        ], true)) {
            return $this->blockedAccess('subscription_'.$subscription->status->value);
        }

        if ($subscription->expires_at->isFuture()) {
            return [
                'state' => 'active',
                'can_use_app' => true,
                'online_verification_required' => false,
                'reason' => null,
                'valid_until' => $subscription->expires_at->toIso8601String(),
            ];
        }

        if ($subscription->offline_grace_until?->isFuture()) {
            return [
                'state' => 'offline_grace',
                'can_use_app' => true,
                'online_verification_required' => true,
                'reason' => 'subscription_offline_grace',
                'valid_until' => $subscription->offline_grace_until->toIso8601String(),
            ];
        }

        return $this->blockedAccess('subscription_expired');
    }

    /** @return array<string, mixed> */
    private function blockedAccess(string $reason): array
    {
        return [
            'state' => 'blocked',
            'can_use_app' => false,
            'online_verification_required' => false,
            'reason' => $reason,
            'valid_until' => null,
        ];
    }
}
