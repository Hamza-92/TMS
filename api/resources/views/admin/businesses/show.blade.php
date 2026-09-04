@extends('layouts.admin')

@section('title', $business->name)

@section('content')
<a class="back-link" href="{{ route('admin.businesses.index') }}"><x-admin.icon name="arrow-left" size="16" /> Back to businesses</a>

<section class="business-detail-heading">
    <div class="business-detail-heading__identity">
        <span>{{ mb_strtoupper(mb_substr($business->name, 0, 1)) }}</span>
        <div>
            <div class="business-title-line"><h1>{{ $business->name }}</h1><span class="status-pill status-pill--{{ $business->status->value }}">{{ str($business->status->value)->headline() }}</span></div>
            <p>{{ $business->phone_e164 ?: 'No business phone' }} · Registered {{ $business->created_at->format('d M Y') }}</p>
        </div>
    </div>

    @if (auth('admin')->user()->role === \App\Enums\AdminRole::Superadmin)
        @if ($business->status === \App\Enums\BusinessStatus::Active)
            <button class="danger-outline-button" type="button" data-dialog-open="suspend-business-dialog">Suspend business</button>
        @elseif ($business->status === \App\Enums\BusinessStatus::Suspended)
            <button class="success-button" type="button" data-dialog-open="reactivate-business-dialog">Reactivate business</button>
        @endif
    @endif
</section>

@if ($business->status === \App\Enums\BusinessStatus::Suspended)
    <div class="suspension-banner">
        <span><x-admin.icon name="alert" size="20" /></span>
        <div><strong>Business access is paused</strong><p>{{ $business->suspension_reason }} · Suspended {{ $business->suspended_at?->diffForHumans() }}</p></div>
    </div>
@endif

<section class="detail-summary-grid" aria-label="Business summary">
    <article><span>Current subscription</span><strong>{{ $business->latestSubscription?->plan?->name ?: 'No plan' }}</strong><small>{{ $business->latestSubscription ? str($business->latestSubscription->status->value)->headline() : 'Not assigned' }}</small></article>
    <article><span>Subscription ends</span><strong>{{ $business->latestSubscription?->expires_at?->format('d M Y') ?: '—' }}</strong><small>{{ $business->latestSubscription?->expires_at?->diffForHumans() ?: 'No active term' }}</small></article>
    <article><span>Members</span><strong>{{ number_format($business->memberships_count) }}</strong><small>{{ $memberships->where('status', \App\Enums\MembershipStatus::Active)->count() }} active</small></article>
    <article><span>Payment records</span><strong>{{ number_format($business->subscription_payments_count) }}</strong><small>{{ $payments->where('status', \App\Enums\PaymentStatus::Pending)->count() }} pending in recent records</small></article>
</section>

<div class="business-detail-grid">
    <div class="business-detail-grid__main">
        <section class="content-card">
            <header class="content-card__header"><div><h2>Members</h2><p>People who can access this business.</p></div><span class="section-count">{{ $business->memberships_count }}</span></header>
            @if ($memberships->isEmpty())
                <div class="empty-state empty-state--compact"><span><x-admin.icon name="users" size="22" /></span><h3>No members</h3><p>No membership records are attached to this business.</p></div>
            @else
                <div class="table-scroll">
                    <table class="data-table">
                        <thead><tr><th>Member</th><th>Role</th><th>Status</th><th>Joined</th><th>Last sign in</th></tr></thead>
                        <tbody>
                        @foreach ($memberships as $membership)
                            <tr>
                                <td><strong>{{ $membership->user?->name ?: 'Deleted user' }}</strong><small>{{ $membership->user?->phone_e164 ?: $membership->user?->email }}</small></td>
                                <td>{{ str($membership->role->value)->headline() }}</td>
                                <td><span class="status-pill status-pill--{{ $membership->status->value }}">{{ str($membership->status->value)->headline() }}</span></td>
                                <td>{{ ($membership->joined_at ?: $membership->created_at)->format('d M Y') }}</td>
                                <td>{{ $membership->user?->last_login_at?->diffForHumans() ?: 'Never' }}</td>
                            </tr>
                        @endforeach
                        </tbody>
                    </table>
                </div>
            @endif
        </section>

        <section class="content-card">
            <header class="content-card__header"><div><h2>Subscription history</h2><p>Trials and paid access assigned to this business.</p></div></header>
            @if ($subscriptions->isEmpty())
                <div class="empty-state empty-state--compact"><span><x-admin.icon name="subscription" size="22" /></span><h3>No subscriptions</h3><p>Subscription history will appear here.</p></div>
            @else
                <div class="table-scroll">
                    <table class="data-table">
                        <thead><tr><th>Plan</th><th>Source</th><th>Status</th><th>Period</th><th>Activated by</th></tr></thead>
                        <tbody>
                        @foreach ($subscriptions as $subscription)
                            <tr>
                                <td><strong>{{ $subscription->plan?->name ?: 'Deleted plan' }}</strong><small>{{ $subscription->plan?->code }}</small></td>
                                <td>{{ str($subscription->source->value)->headline() }}</td>
                                <td><span class="status-pill status-pill--{{ $subscription->status->value }}">{{ str($subscription->status->value)->headline() }}</span></td>
                                <td><span>{{ $subscription->starts_at->format('d M Y') }}</span><small>to {{ $subscription->expires_at->format('d M Y') }}</small></td>
                                <td>{{ $subscription->activatedBy?->name ?: ($subscription->source->value === 'trial' ? 'Automatic trial' : 'System') }}</td>
                            </tr>
                        @endforeach
                        </tbody>
                    </table>
                </div>
            @endif
        </section>

        <section class="content-card">
            <header class="content-card__header"><div><h2>Recent payments</h2><p>Latest subscription payment submissions and decisions.</p></div></header>
            @if ($payments->isEmpty())
                <div class="empty-state empty-state--compact"><span><x-admin.icon name="payment" size="22" /></span><h3>No payments</h3><p>Payment requests for this business will appear here.</p></div>
            @else
                <div class="table-scroll">
                    <table class="data-table">
                        <thead><tr><th>Plan</th><th>Amount</th><th>Method</th><th>Reference</th><th>Status</th><th>Submitted</th></tr></thead>
                        <tbody>
                        @foreach ($payments as $payment)
                            <tr>
                                <td>{{ $payment->plan?->name ?: 'Deleted plan' }}</td>
                                <td><strong>{{ $payment->currency_code }} {{ number_format((float) $payment->amount, 2) }}</strong></td>
                                <td>{{ str($payment->method->value)->headline() }}</td>
                                <td><a class="reference-code detail-link" href="{{ route('admin.payments.show', $payment) }}">{{ $payment->transaction_reference ?: 'View request' }}</a></td>
                                <td><span class="status-pill status-pill--{{ $payment->status->value }}">{{ str($payment->status->value)->headline() }}</span></td>
                                <td>{{ ($payment->submitted_at ?: $payment->created_at)->diffForHumans() }}</td>
                            </tr>
                        @endforeach
                        </tbody>
                    </table>
                </div>
            @endif
        </section>
    </div>

    <aside class="business-detail-grid__aside">
        <section class="content-card detail-card">
            <header class="content-card__header"><div><h2>Business details</h2><p>Account configuration.</p></div></header>
            <dl class="detail-list">
                <div><dt>Business ID</dt><dd class="reference-code">{{ $business->id }}</dd></div>
                <div><dt>Owner</dt><dd>{{ $ownerMembership?->user?->name ?: $business->creator?->name ?: 'Unavailable' }}</dd></div>
                <div><dt>Owner phone</dt><dd>{{ $ownerMembership?->user?->phone_e164 ?: $business->creator?->phone_e164 ?: 'Not provided' }}</dd></div>
                <div><dt>Locale</dt><dd>{{ str($business->preferred_locale)->upper() }}</dd></div>
                <div><dt>Country / currency</dt><dd>{{ $business->country_code }} · {{ $business->currency_code }}</dd></div>
                <div><dt>Timezone</dt><dd>{{ $business->timezone }}</dd></div>
            </dl>
        </section>

        <section class="content-card detail-card">
            <header class="content-card__header"><div><h2>Recent admin activity</h2><p>Status changes for this business.</p></div></header>
            @if ($auditLogs->isEmpty())
                <div class="empty-state empty-state--small"><span><x-admin.icon name="audit" size="20" /></span><h3>No admin actions</h3><p>Audited changes will appear here.</p></div>
            @else
                <div class="activity-list">
                    @foreach ($auditLogs as $log)
                        <div class="activity-list__item">
                            <span></span>
                            <div><strong>{{ str($log->action)->after('business.')->headline() }}</strong><small>{{ $log->adminUser?->name ?: 'Former administrator' }} · {{ $log->created_at->diffForHumans() }}</small></div>
                        </div>
                    @endforeach
                </div>
            @endif
        </section>
    </aside>
</div>

@if (auth('admin')->user()->role === \App\Enums\AdminRole::Superadmin && $business->status === \App\Enums\BusinessStatus::Active)
    <dialog class="admin-dialog" id="suspend-business-dialog" @if($errors->has('reason')) data-dialog-auto-open @endif>
        <form method="POST" action="{{ route('admin.businesses.suspend', $business) }}">
            @csrf
            <div class="admin-dialog__icon admin-dialog__icon--danger"><x-admin.icon name="alert" size="23" /></div>
            <h2>Suspend {{ $business->name }}?</h2>
            <p>Users will keep their accounts, but access to this business will be paused immediately. Other businesses on their accounts are not affected.</p>
            <label class="dialog-field">
                <span>Reason for suspension</span>
                <textarea name="reason" rows="4" maxlength="500" required placeholder="Explain why access is being paused">{{ old('reason') }}</textarea>
            </label>
            @error('reason')<p class="field-error">{{ $message }}</p>@enderror
            <div class="admin-dialog__actions">
                <button class="secondary-button" type="button" data-dialog-close>Cancel</button>
                <button class="danger-button" type="submit">Suspend business</button>
            </div>
        </form>
    </dialog>
@endif

@if (auth('admin')->user()->role === \App\Enums\AdminRole::Superadmin && $business->status === \App\Enums\BusinessStatus::Suspended)
    <dialog class="admin-dialog" id="reactivate-business-dialog">
        <form method="POST" action="{{ route('admin.businesses.reactivate', $business) }}">
            @csrf
            <div class="admin-dialog__icon admin-dialog__icon--success"><x-admin.icon name="check" size="23" /></div>
            <h2>Reactivate {{ $business->name }}?</h2>
            <p>Business access will be restored immediately. Subscription rules will continue to apply as usual.</p>
            <div class="admin-dialog__actions">
                <button class="secondary-button" type="button" data-dialog-close>Cancel</button>
                <button class="success-button" type="submit">Reactivate business</button>
            </div>
        </form>
    </dialog>
@endif
@endsection
