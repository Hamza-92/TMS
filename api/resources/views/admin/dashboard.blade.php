@extends('layouts.admin')

@section('title', 'Dashboard')

@section('content')
<section class="page-heading">
    <div>
        <!-- <span class="eyebrow">Platform overview</span> -->
        <h1>Dashboard</h1>
        <p>Monitor accounts, subscriptions and actions that need your attention.</p>
    </div>
    <div class="page-heading__date">
        <span>Today</span>
        <strong>{{ now()->format('d M Y') }}</strong>
    </div>
</section>

<section class="metric-grid" aria-label="Platform summary">
    <article class="metric-card metric-card--primary">
        <span class="metric-card__icon"><x-admin.icon name="business" /></span>
        <div><span>Total businesses</span><strong>{{ number_format($metrics['businesses']) }}</strong><small>{{ number_format($metrics['activeBusinesses']) }} active</small></div>
    </article>
    <article class="metric-card">
        <span class="metric-card__icon metric-card__icon--cyan"><x-admin.icon name="users" /></span>
        <div><span>Registered users</span><strong>{{ number_format($metrics['users']) }}</strong><small>Verified app accounts</small></div>
    </article>
    <article class="metric-card">
        <span class="metric-card__icon metric-card__icon--amber"><x-admin.icon name="subscription" /></span>
        <div><span>Usable subscriptions</span><strong>{{ number_format($metrics['usableSubscriptions']) }}</strong><small>Trial, active or grace</small></div>
    </article>
    <article class="metric-card">
        <span class="metric-card__icon metric-card__icon--pink"><x-admin.icon name="payment" /></span>
        <div><span>Pending payments</span><strong>{{ number_format($metrics['pendingPayments']) }}</strong><small>Awaiting manual review</small></div>
    </article>
</section>

<div class="dashboard-grid">
    <section class="content-card content-card--wide">
        <header class="content-card__header">
            <div><h2>Recent businesses</h2><p>Newest businesses registered on the platform.</p></div>
            <span class="section-count">{{ $recentBusinesses->count() }}</span>
        </header>

        @if ($recentBusinesses->isEmpty())
            <div class="empty-state"><span><x-admin.icon name="business" size="24" /></span><h3>No businesses yet</h3><p>Newly registered tailor businesses will appear here.</p></div>
        @else
            <div class="table-scroll">
                <table class="data-table">
                    <thead><tr><th>Business</th><th>Owner</th><th>Members</th><th>Status</th><th>Joined</th></tr></thead>
                    <tbody>
                    @foreach ($recentBusinesses as $business)
                        <tr>
                            <td><a class="table-primary-link" href="{{ route('admin.businesses.show', $business) }}"><strong>{{ $business->name }}</strong></a><small>{{ $business->phone_e164 ?: 'No business phone' }}</small></td>
                            <td><span>{{ $business->creator->name }}</span><small>{{ $business->creator->phone_e164 }}</small></td>
                            <td>{{ $business->memberships_count }}</td>
                            <td><span class="status-pill status-pill--{{ $business->status->value }}">{{ str($business->status->value)->headline() }}</span></td>
                            <td><span>{{ $business->created_at->format('d M Y') }}</span><small>{{ $business->created_at->diffForHumans() }}</small></td>
                        </tr>
                    @endforeach
                    </tbody>
                </table>
            </div>
        @endif
    </section>

    <section class="content-card">
        <header class="content-card__header"><div><h2>Trials ending soon</h2><p>Expiring in the next seven days.</p></div></header>
        @if ($expiringTrials->isEmpty())
            <div class="empty-state empty-state--compact"><span><x-admin.icon name="subscription" size="22" /></span><h3>Nothing urgent</h3><p>No trials expire during the next seven days.</p></div>
        @else
            <div class="stack-list">
                @foreach ($expiringTrials as $subscription)
                    <div class="stack-list__item">
                        <span class="stack-list__avatar">{{ mb_strtoupper(mb_substr($subscription->business->name, 0, 1)) }}</span>
                        <div><strong>{{ $subscription->business->name }}</strong><small>{{ $subscription->plan->name }}</small></div>
                        <time datetime="{{ $subscription->expires_at->toDateString() }}">{{ $subscription->expires_at->diffForHumans() }}</time>
                    </div>
                @endforeach
            </div>
        @endif
    </section>

    <section class="content-card dashboard-grid__full">
        <header class="content-card__header">
            <div><h2>Payments awaiting review</h2><p>Bank and offline payments requiring administrator verification.</p></div>
            <a class="row-action" href="{{ route('admin.payments.index', ['status' => 'pending']) }}">{{ $metrics['pendingPayments'] > 0 ? 'Review queue' : 'View payments' }} <x-admin.icon name="arrow-right" size="15" /></a>
        </header>
        @if ($pendingPayments->isEmpty())
            <div class="empty-state empty-state--compact"><span><x-admin.icon name="payment" size="22" /></span><h3>Payment queue is clear</h3><p>Submitted payment proofs will be listed here for review.</p></div>
        @else
            <div class="table-scroll">
                <table class="data-table">
                    <thead><tr><th>Business</th><th>Submitted by</th><th>Plan</th><th>Reference</th><th>Amount</th><th>Submitted</th></tr></thead>
                    <tbody>
                    @foreach ($pendingPayments as $payment)
                        <tr>
                            <td><a class="table-primary-link" href="{{ route('admin.payments.show', $payment) }}"><strong>{{ $payment->business->name }}</strong></a></td>
                            <td><span>{{ $payment->submittedBy?->name ?: 'Not recorded' }}</span><small>{{ $payment->submittedBy?->phone_e164 }}</small></td>
                            <td>{{ $payment->plan->name }}</td>
                            <td><span class="reference-code">{{ $payment->transaction_reference ?: '—' }}</span></td>
                            <td><strong>{{ $payment->currency_code }} {{ number_format((float) $payment->amount, 2) }}</strong></td>
                            <td>{{ ($payment->submitted_at ?: $payment->created_at)->diffForHumans() }}</td>
                        </tr>
                    @endforeach
                    </tbody>
                </table>
            </div>
        @endif
    </section>
</div>
@endsection
