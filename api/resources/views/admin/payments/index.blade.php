@extends('layouts.admin')

@section('title', 'Payment requests')

@section('content')
<section class="page-heading">
    <div>
        <h1>Payment requests</h1>
        <p>Review outside payments and activate subscriptions from one clear queue.</p>
    </div>
    <span class="page-heading__count">{{ number_format($statusCounts['pending']) }} pending</span>
</section>

<section class="payment-status-grid" aria-label="Payment status summary">
    @foreach ([
        ['all', 'All requests'],
        ['pending', 'Pending'],
        ['verified', 'Verified'],
        ['rejected', 'Rejected'],
        ['refunded', 'Refunded'],
    ] as [$key, $label])
        <a
            @class([
                'business-status-card',
                'is-selected' => ($key === 'all' && ! $filters['status']) || $filters['status'] === $key,
            ])
            href="{{ $key === 'all' ? route('admin.payments.index') : route('admin.payments.index', ['status' => $key]) }}"
        >
            <span>{{ $label }}</span>
            <strong>{{ number_format($statusCounts[$key]) }}</strong>
        </a>
    @endforeach
</section>

<section class="content-card business-list-card">
    <header class="business-list-toolbar">
        <form class="business-filter" method="GET" action="{{ route('admin.payments.index') }}">
            <label class="search-control">
                <span class="sr-only">Search payment requests</span>
                <x-admin.icon name="search" size="18" />
                <input name="q" type="search" value="{{ $filters['q'] }}" placeholder="Search business, customer or reference" autocomplete="off">
            </label>

            <label class="select-control">
                <span class="sr-only">Payment status</span>
                <select name="status">
                    <option value="">All statuses</option>
                    @foreach (\App\Enums\PaymentStatus::cases() as $status)
                        <option value="{{ $status->value }}" @selected($filters['status'] === $status->value)>{{ str($status->value)->headline() }}</option>
                    @endforeach
                </select>
            </label>

            <label class="select-control">
                <span class="sr-only">Payment method</span>
                <select name="method">
                    <option value="">All methods</option>
                    @foreach (\App\Enums\PaymentMethod::cases() as $method)
                        <option value="{{ $method->value }}" @selected($filters['method'] === $method->value)>{{ str($method->value)->headline() }}</option>
                    @endforeach
                </select>
            </label>

            <button class="filter-button" type="submit">Apply filters</button>
            @if ($filters['q'] || $filters['status'] || $filters['method'])
                <a class="clear-filter" href="{{ route('admin.payments.index') }}">Clear</a>
            @endif
        </form>
    </header>

    @if ($payments->isEmpty())
        <div class="empty-state">
            <span><x-admin.icon name="payment" size="24" /></span>
            <h3>No payment requests found</h3>
            <p>Try different filters or return when a customer submits a payment.</p>
        </div>
    @else
        <div class="table-scroll">
            <table class="data-table payment-table">
                <thead>
                    <tr><th>Business</th><th>Plan</th><th>Payment</th><th>Reference</th><th>Status</th><th>Submitted</th><th><span class="sr-only">Action</span></th></tr>
                </thead>
                <tbody>
                @foreach ($payments as $payment)
                    <tr>
                        <td>
                            <a class="business-identity" href="{{ route('admin.payments.show', $payment) }}">
                                <span>{{ mb_strtoupper(mb_substr($payment->business->name, 0, 1)) }}</span>
                                <div><strong>{{ $payment->business->name }}</strong><small>{{ $payment->submittedBy?->name ?: 'Submitter not recorded' }}</small></div>
                            </a>
                        </td>
                        <td><strong>{{ $payment->plan->name }}</strong><small>{{ str($payment->plan->billing_period->value)->headline() }}</small></td>
                        <td><strong>{{ $payment->currency_code }} {{ number_format((float) $payment->amount, 2) }}</strong><small>{{ str($payment->method->value)->headline() }}</small></td>
                        <td><span class="reference-code">{{ $payment->transaction_reference ?: '—' }}</span></td>
                        <td><span class="status-pill status-pill--{{ $payment->status->value }}">{{ str($payment->status->value)->headline() }}</span></td>
                        <td><span>{{ ($payment->submitted_at ?: $payment->created_at)->format('d M Y') }}</span><small>{{ ($payment->submitted_at ?: $payment->created_at)->diffForHumans() }}</small></td>
                        <td><a class="row-action" href="{{ route('admin.payments.show', $payment) }}">Review <x-admin.icon name="arrow-right" size="15" /></a></td>
                    </tr>
                @endforeach
                </tbody>
            </table>
        </div>
        <x-admin.pagination :paginator="$payments" />
    @endif
</section>
@endsection
