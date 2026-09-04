<?php

namespace App\Http\Controllers\Admin;

use App\Enums\PaymentStatus;
use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\ApprovePaymentRequest;
use App\Http\Requests\Admin\PaymentIndexRequest;
use App\Http\Requests\Admin\RejectPaymentRequest;
use App\Models\AdminUser;
use App\Models\SubscriptionPayment;
use App\Services\Admin\PaymentReviewService;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\RedirectResponse;
use Illuminate\View\View;

class PaymentController extends Controller
{
    public function index(PaymentIndexRequest $request): View
    {
        $filters = $request->validated();
        $search = trim((string) ($filters['q'] ?? ''));
        $status = $filters['status'] ?? null;
        $method = $filters['method'] ?? null;

        $payments = SubscriptionPayment::query()
            ->with([
                'business:id,name,phone_e164,status',
                'plan:id,name,code,billing_period,price,currency_code',
                'submittedBy:id,name,phone_e164',
                'verifiedBy:id,name',
            ])
            ->when($search !== '', function (Builder $query) use ($search): void {
                $query->where(function (Builder $query) use ($search): void {
                    $query
                        ->where('transaction_reference', 'like', "%{$search}%")
                        ->orWhereHas('business', function (Builder $query) use ($search): void {
                            $query
                                ->where('name', 'like', "%{$search}%")
                                ->orWhere('phone_e164', 'like', "%{$search}%");
                        })
                        ->orWhereHas('submittedBy', function (Builder $query) use ($search): void {
                            $query
                                ->where('name', 'like', "%{$search}%")
                                ->orWhere('phone_e164', 'like', "%{$search}%");
                        });
                });
            })
            ->when($status, fn (Builder $query, string $status) => $query->where('status', $status))
            ->when($method, fn (Builder $query, string $method) => $query->where('method', $method))
            ->orderByRaw('CASE WHEN status = ? THEN 0 ELSE 1 END', [PaymentStatus::Pending->value])
            ->latest('submitted_at')
            ->latest('created_at')
            ->paginate(15)
            ->withQueryString();

        return view('admin.payments.index', [
            'payments' => $payments,
            'filters' => [
                'q' => $search,
                'status' => $status,
                'method' => $method,
            ],
            'statusCounts' => [
                'all' => SubscriptionPayment::query()->count(),
                'pending' => SubscriptionPayment::query()->where('status', PaymentStatus::Pending->value)->count(),
                'verified' => SubscriptionPayment::query()->where('status', PaymentStatus::Verified->value)->count(),
                'rejected' => SubscriptionPayment::query()->where('status', PaymentStatus::Rejected->value)->count(),
                'refunded' => SubscriptionPayment::query()->where('status', PaymentStatus::Refunded->value)->count(),
            ],
        ]);
    }

    public function show(SubscriptionPayment $payment): View
    {
        $payment->load([
            'business:id,name,phone_e164,status,currency_code,created_by_user_id',
            'business.creator:id,name,phone_e164,email',
            'plan:id,name,code,description,billing_period,price,currency_code,is_active',
            'submittedBy:id,name,phone_e164,email',
            'verifiedBy:id,name,email',
            'subscription:id,business_id,plan_id,source,status,starts_at,expires_at,offline_grace_until,activated_by_admin_id',
        ]);

        return view('admin.payments.show', ['payment' => $payment]);
    }

    public function approve(
        ApprovePaymentRequest $request,
        SubscriptionPayment $payment,
        PaymentReviewService $reviewService,
    ): RedirectResponse {
        /** @var AdminUser $admin */
        $admin = $request->user('admin');

        $reviewService->approve(
            payment: $payment,
            admin: $admin,
            adminNotes: $request->string('admin_notes')->trim()->value() ?: null,
            ipAddress: $request->ip(),
            userAgent: $request->userAgent(),
        );

        return to_route('admin.payments.show', $payment)
            ->with('status', 'Payment verified and paid subscription activated.');
    }

    public function reject(
        RejectPaymentRequest $request,
        SubscriptionPayment $payment,
        PaymentReviewService $reviewService,
    ): RedirectResponse {
        /** @var AdminUser $admin */
        $admin = $request->user('admin');

        $reviewService->reject(
            payment: $payment,
            admin: $admin,
            reason: $request->string('rejection_reason')->trim()->value(),
            adminNotes: $request->string('admin_notes')->trim()->value() ?: null,
            ipAddress: $request->ip(),
            userAgent: $request->userAgent(),
        );

        return to_route('admin.payments.show', $payment)
            ->with('status', 'Payment request rejected. No subscription access was changed.');
    }
}
