<?php

namespace App\Http\Middleware;

use App\Models\Business;
use App\Models\BusinessMember;
use App\Models\User;
use App\Services\BusinessAccessService;
use Closure;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureBusinessAccess
{
    public function __construct(private readonly BusinessAccessService $accessService) {}

    public function handle(Request $request, Closure $next): Response
    {
        /** @var User $user */
        $user = $request->user();
        $business = $request->route('business');

        if (! $business instanceof Business) {
            return $this->denied('business_not_found', 'The selected business was not found.', 404);
        }

        $membership = BusinessMember::query()
            ->where('business_id', $business->id)
            ->where('user_id', $user->id)
            ->first();

        if (! $membership) {
            return $this->denied('business_access_denied', 'You do not have access to this business.');
        }

        $membership->setRelation('business', $business);
        $subscription = $business->subscriptions()
            ->with('plan')
            ->orderByDesc('starts_at')
            ->first();
        $access = $this->accessService->for($membership, $subscription);

        if (! $access['can_use_app']) {
            return $this->denied(
                (string) $access['reason'],
                'This business is not currently available.',
            );
        }

        $request->attributes->set('business_membership', $membership);
        $request->attributes->set('business_subscription', $subscription);

        return $next($request);
    }

    private function denied(string $code, string $message, int $status = 403): JsonResponse
    {
        return response()->json([
            'success' => false,
            'message' => $message,
            'code' => $code,
        ], $status);
    }
}
