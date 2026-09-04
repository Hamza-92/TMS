@extends('layouts.admin')

@section('title', 'Payment review')

@section('content')
<a class="back-link" href="{{ route('admin.payments.index') }}"><x-admin.icon name="arrow-left" size="16" /> Back to payment requests</a>

<section class="business-detail-heading payment-detail-heading">
    <div class="business-detail-heading__identity">
        <span><x-admin.icon name="payment" size="23" /></span>
        <div>
            <div class="business-title-line">
                <h1>{{ $payment->business->name }}</h1>
                <span class="status-pill status-pill--{{ $payment->status->value }}">{{ str($payment->status->value)->headline() }}</span>
            </div>
            <p>Payment request {{ $payment->id }}</p>
        </div>
    </div>

    @if ($payment->status === \App\Enums\PaymentStatus::Pending && in_array(auth('admin')->user()->role, [\App\Enums\AdminRole::Superadmin, \App\Enums\AdminRole::Finance], true))
        <div class="payment-review-actions">
            <button class="danger-outline-button" type="button" data-dialog-open="reject-payment-dialog">Reject</button>
            <button class="success-button" type="button" data-dialog-open="approve-payment-dialog">Verify and activate</button>
        </div>
    @endif
</section>

@if ($payment->status === \App\Enums\PaymentStatus::Rejected)
    <div class="suspension-banner">
        <span><x-admin.icon name="alert" size="20" /></span>
        <div><strong>Payment could not be verified</strong><p>{{ $payment->rejection_reason }}</p></div>
    </div>
@endif

<section class="detail-summary-grid" aria-label="Payment summary">
    <article><span>Amount submitted</span><strong>{{ $payment->currency_code }} {{ number_format((float) $payment->amount, 2) }}</strong><small>Plan price: {{ $payment->plan->currency_code }} {{ number_format((float) $payment->plan->price, 2) }}</small></article>
    <article><span>Payment method</span><strong>{{ str($payment->method->value)->headline() }}</strong><small>{{ $payment->transaction_reference ?: 'No reference supplied' }}</small></article>
    <article><span>Requested plan</span><strong>{{ $payment->plan->name }}</strong><small>{{ str($payment->plan->billing_period->value)->headline() }}</small></article>
    <article><span>Submitted</span><strong>{{ ($payment->submitted_at ?: $payment->created_at)->format('d M Y') }}</strong><small>{{ ($payment->submitted_at ?: $payment->created_at)->diffForHumans() }}</small></article>
</section>

<div class="business-detail-grid payment-detail-grid">
    <div class="business-detail-grid__main">
        <section class="content-card detail-card">
            <header class="content-card__header"><div><h2>Review checklist</h2><p>Everything needed for a safe decision is kept on this screen.</p></div></header>
            <dl class="detail-list payment-checklist">
                <div><dt>Transaction reference</dt><dd class="reference-code">{{ $payment->transaction_reference ?: 'Not supplied' }}</dd></div>
                <div><dt>Amount matches plan</dt><dd class="{{ $payment->amount === $payment->plan->price && $payment->currency_code === $payment->plan->currency_code ? 'check-value--success' : 'check-value--danger' }}">{{ $payment->amount === $payment->plan->price && $payment->currency_code === $payment->plan->currency_code ? 'Yes' : 'No' }}</dd></div>
                <div><dt>Plan can be assigned</dt><dd class="{{ $payment->plan->is_active && $payment->plan->billing_period !== \App\Enums\BillingPeriod::Custom && (float) $payment->plan->price > 0 ? 'check-value--success' : 'check-value--danger' }}">{{ $payment->plan->is_active && $payment->plan->billing_period !== \App\Enums\BillingPeriod::Custom && (float) $payment->plan->price > 0 ? 'Yes' : 'Needs plan correction' }}</dd></div>
                <div><dt>Business can receive access</dt><dd class="{{ $payment->business->status === \App\Enums\BusinessStatus::Active ? 'check-value--success' : 'check-value--danger' }}">{{ str($payment->business->status->value)->headline() }}</dd></div>
                <div><dt>Receipt</dt><dd>{{ $payment->receipt_path ? 'Receipt recorded' : 'No receipt uploaded' }}</dd></div>
            </dl>
        </section>

        @if ($payment->subscription)
            <section class="content-card detail-card">
                <header class="content-card__header"><div><h2>Activated subscription</h2><p>The access term created from this payment.</p></div><span class="status-pill status-pill--{{ $payment->subscription->status->value }}">{{ str($payment->subscription->status->value)->headline() }}</span></header>
                <dl class="detail-list">
                    <div><dt>Subscription ID</dt><dd class="reference-code">{{ $payment->subscription->id }}</dd></div>
                    <div><dt>Access period</dt><dd>{{ $payment->subscription->starts_at->format('d M Y') }} to {{ $payment->subscription->expires_at->format('d M Y') }}</dd></div>
                    <div><dt>Offline grace ends</dt><dd>{{ $payment->subscription->offline_grace_until?->format('d M Y') ?: 'Not configured' }}</dd></div>
                    <div><dt>Source</dt><dd>{{ str($payment->subscription->source->value)->headline() }}</dd></div>
                </dl>
            </section>
        @endif
    </div>

    <aside class="business-detail-grid__aside">
        <section class="content-card detail-card">
            <header class="content-card__header"><div><h2>Customer and business</h2><p>Account receiving the subscription.</p></div></header>
            <dl class="detail-list">
                <div><dt>Business</dt><dd><a class="detail-link" href="{{ route('admin.businesses.show', $payment->business) }}">{{ $payment->business->name }}</a></dd></div>
                <div><dt>Business phone</dt><dd>{{ $payment->business->phone_e164 ?: 'Not provided' }}</dd></div>
                <div><dt>Submitted by</dt><dd>{{ $payment->submittedBy?->name ?: 'Not recorded' }}</dd></div>
                <div><dt>Customer phone</dt><dd>{{ $payment->submittedBy?->phone_e164 ?: $payment->business->creator?->phone_e164 ?: 'Not provided' }}</dd></div>
                <div><dt>Customer email</dt><dd>{{ $payment->submittedBy?->email ?: $payment->business->creator?->email ?: 'Not provided' }}</dd></div>
            </dl>
        </section>

        <section class="content-card detail-card">
            <header class="content-card__header"><div><h2>Decision record</h2><p>Who reviewed this request.</p></div></header>
            <dl class="detail-list">
                <div><dt>Current status</dt><dd><span class="status-pill status-pill--{{ $payment->status->value }}">{{ str($payment->status->value)->headline() }}</span></dd></div>
                <div><dt>Reviewed by</dt><dd>{{ $payment->verifiedBy?->name ?: 'Not reviewed' }}</dd></div>
                <div><dt>Decision date</dt><dd>{{ ($payment->verified_at ?: $payment->rejected_at)?->format('d M Y, H:i') ?: '—' }}</dd></div>
                <div><dt>Internal notes</dt><dd>{{ $payment->admin_notes ?: 'No internal notes' }}</dd></div>
            </dl>
        </section>
    </aside>
</div>

@if ($payment->status === \App\Enums\PaymentStatus::Pending && in_array(auth('admin')->user()->role, [\App\Enums\AdminRole::Superadmin, \App\Enums\AdminRole::Finance], true))
    <dialog class="admin-dialog" id="approve-payment-dialog" @if($errors->has('admin_notes') || $errors->has('payment')) data-dialog-auto-open @endif>
        <form method="POST" action="{{ route('admin.payments.approve', $payment) }}">
            @csrf
            <div class="admin-dialog__icon admin-dialog__icon--success"><x-admin.icon name="check" size="23" /></div>
            <h2>Verify payment and activate access?</h2>
            <p>This marks the payment as verified, ends the current trial or usable term, and immediately activates a new {{ str($payment->plan->billing_period->value)->headline() }} {{ $payment->plan->name }} subscription.</p>
            <label class="dialog-field">
                <span>Internal notes <small>Optional</small></span>
                <textarea name="admin_notes" rows="3" maxlength="1000" placeholder="Add information useful to other administrators">{{ old('admin_notes') }}</textarea>
            </label>
            @error('admin_notes')<p class="field-error">{{ $message }}</p>@enderror
            @error('payment')<p class="field-error">{{ $message }}</p>@enderror
            <div class="admin-dialog__actions">
                <button class="secondary-button" type="button" data-dialog-close>Cancel</button>
                <button class="success-button" type="submit">Verify and activate</button>
            </div>
        </form>
    </dialog>

    <dialog class="admin-dialog" id="reject-payment-dialog" @if($errors->has('rejection_reason')) data-dialog-auto-open @endif>
        <form method="POST" action="{{ route('admin.payments.reject', $payment) }}">
            @csrf
            <div class="admin-dialog__icon admin-dialog__icon--danger"><x-admin.icon name="alert" size="23" /></div>
            <h2>Reject this payment?</h2>
            <p>No subscription access will be changed. Give a concise reason that can be used when following up with the customer.</p>
            <label class="dialog-field">
                <span>Reason for rejection</span>
                <textarea name="rejection_reason" rows="3" maxlength="500" required placeholder="For example: The bank reference could not be found">{{ old('rejection_reason') }}</textarea>
            </label>
            @error('rejection_reason')<p class="field-error">{{ $message }}</p>@enderror
            <label class="dialog-field">
                <span>Internal notes <small>Optional</small></span>
                <textarea name="admin_notes" rows="3" maxlength="1000" placeholder="Add private context for administrators">{{ old('admin_notes') }}</textarea>
            </label>
            <div class="admin-dialog__actions">
                <button class="secondary-button" type="button" data-dialog-close>Cancel</button>
                <button class="danger-button" type="submit">Reject payment</button>
            </div>
        </form>
    </dialog>
@endif
@endsection
