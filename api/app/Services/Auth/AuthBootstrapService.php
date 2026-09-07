<?php

namespace App\Services\Auth;

use App\Http\Resources\Api\V1\BusinessResource;
use App\Http\Resources\Api\V1\SubscriptionResource;
use App\Http\Resources\Api\V1\UserResource;
use App\Models\BusinessMember;
use App\Models\Subscription;
use App\Models\User;
use App\Services\BusinessAccessService;
use Illuminate\Http\Request;

class AuthBootstrapService
{
    public function __construct(private readonly BusinessAccessService $accessService) {}

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
            'access' => $this->accessService->for($membership, $subscription),
        ];
    }
}
