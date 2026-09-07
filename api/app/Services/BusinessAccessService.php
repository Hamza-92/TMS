<?php

namespace App\Services;

use App\Enums\BusinessStatus;
use App\Enums\MembershipStatus;
use App\Enums\SubscriptionStatus;
use App\Models\BusinessMember;
use App\Models\Subscription;

class BusinessAccessService
{
    /** @return array<string, mixed> */
    public function for(BusinessMember $membership, ?Subscription $subscription): array
    {
        if ($membership->status !== MembershipStatus::Active) {
            return $this->blocked('membership_'.$membership->status->value);
        }

        if ($membership->business->status !== BusinessStatus::Active) {
            return $this->blocked('business_'.$membership->business->status->value);
        }

        if (! $subscription) {
            return $this->blocked('subscription_missing');
        }

        if (! in_array($subscription->status, [
            SubscriptionStatus::Trialing,
            SubscriptionStatus::Active,
            SubscriptionStatus::Grace,
        ], true)) {
            return $this->blocked('subscription_'.$subscription->status->value);
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

        return $this->blocked('subscription_expired');
    }

    /** @return array<string, mixed> */
    private function blocked(string $reason): array
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
