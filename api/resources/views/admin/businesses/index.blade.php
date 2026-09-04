@extends('layouts.admin')

@section('title', 'Businesses')

@section('content')
<section class="page-heading">
    <div>
        <h1>Businesses</h1>
        <p>Find accounts, review their access and open the complete business record.</p>
    </div>
    <span class="page-heading__count">{{ number_format($statusCounts['all']) }} total</span>
</section>

<section class="business-status-grid" aria-label="Business status summary">
    @foreach ([
        ['all', 'All businesses'],
        ['active', 'Active'],
        ['suspended', 'Suspended'],
        ['closed', 'Closed'],
    ] as [$key, $label])
        <a
            @class([
                'business-status-card',
                'is-selected' => ($key === 'all' && ! $filters['status']) || $filters['status'] === $key,
            ])
            href="{{ $key === 'all' ? route('admin.businesses.index') : route('admin.businesses.index', ['status' => $key]) }}"
        >
            <span>{{ $label }}</span>
            <strong>{{ number_format($statusCounts[$key]) }}</strong>
        </a>
    @endforeach
</section>

<section class="content-card business-list-card">
    <header class="business-list-toolbar">
        <form class="business-filter" method="GET" action="{{ route('admin.businesses.index') }}">
            <label class="search-control">
                <span class="sr-only">Search businesses</span>
                <x-admin.icon name="search" size="18" />
                <input name="q" type="search" value="{{ $filters['q'] }}" placeholder="Search business, owner or phone" autocomplete="off">
            </label>

            <label class="select-control">
                <span class="sr-only">Business status</span>
                <select name="status">
                    <option value="">All statuses</option>
                    @foreach (\App\Enums\BusinessStatus::cases() as $status)
                        <option value="{{ $status->value }}" @selected($filters['status'] === $status->value)>{{ str($status->value)->headline() }}</option>
                    @endforeach
                </select>
            </label>

            <label class="select-control">
                <span class="sr-only">Subscription status</span>
                <select name="subscription">
                    <option value="">All subscriptions</option>
                    <option value="none" @selected($filters['subscription'] === 'none')>No subscription</option>
                    @foreach (\App\Enums\SubscriptionStatus::cases() as $status)
                        <option value="{{ $status->value }}" @selected($filters['subscription'] === $status->value)>{{ str($status->value)->headline() }}</option>
                    @endforeach
                </select>
            </label>

            <button class="filter-button" type="submit">Apply filters</button>
            @if ($filters['q'] || $filters['status'] || $filters['subscription'])
                <a class="clear-filter" href="{{ route('admin.businesses.index') }}">Clear</a>
            @endif
        </form>
    </header>

    @if ($businesses->isEmpty())
        <div class="empty-state">
            <span><x-admin.icon name="business" size="24" /></span>
            <h3>No businesses found</h3>
            <p>Try a different search term or clear one of the filters.</p>
        </div>
    @else
        <div class="table-scroll">
            <table class="data-table business-table">
                <thead>
                    <tr><th>Business</th><th>Owner</th><th>Subscription</th><th>Members</th><th>Status</th><th>Registered</th><th><span class="sr-only">Action</span></th></tr>
                </thead>
                <tbody>
                @foreach ($businesses as $business)
                    @php($subscription = $business->latestSubscription)
                    <tr>
                        <td>
                            <a class="business-identity" href="{{ route('admin.businesses.show', $business) }}">
                                <span>{{ mb_strtoupper(mb_substr($business->name, 0, 1)) }}</span>
                                <div><strong>{{ $business->name }}</strong><small>{{ $business->phone_e164 ?: 'No business phone' }}</small></div>
                            </a>
                        </td>
                        <td><strong>{{ $business->creator?->name ?: 'Owner unavailable' }}</strong><small>{{ $business->creator?->phone_e164 }}</small></td>
                        <td>
                            @if ($subscription)
                                <span class="status-pill status-pill--{{ $subscription->status->value }}">{{ str($subscription->status->value)->headline() }}</span>
                                <small>{{ $subscription->plan?->name ?: 'Plan unavailable' }} · ends {{ $subscription->expires_at->format('d M Y') }}</small>
                            @else
                                <span class="muted-value">Not assigned</span>
                            @endif
                        </td>
                        <td>{{ number_format($business->active_members_count) }}</td>
                        <td><span class="status-pill status-pill--{{ $business->status->value }}">{{ str($business->status->value)->headline() }}</span></td>
                        <td><span>{{ $business->created_at->format('d M Y') }}</span><small>{{ $business->created_at->diffForHumans() }}</small></td>
                        <td><a class="row-action" href="{{ route('admin.businesses.show', $business) }}">View <x-admin.icon name="arrow-right" size="15" /></a></td>
                    </tr>
                @endforeach
                </tbody>
            </table>
        </div>
        <x-admin.pagination :paginator="$businesses" />
    @endif
</section>
@endsection
