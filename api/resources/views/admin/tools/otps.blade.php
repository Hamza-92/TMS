@extends('layouts.admin')

@section('title', 'Test OTPs')

@section('content')
<section class="page-heading page-heading--tools">
    <div>
        <span class="eyebrow">Restricted testing tool</span>
        <h1>Test OTPs</h1>
        <p>View short-lived authentication codes while WhatsApp delivery is being prepared.</p>
    </div>
    <a class="secondary-button" href="{{ route('admin.tools.otps', array_filter(['phone' => $phone])) }}">Refresh codes</a>
</section>

<div class="security-notice" role="note">
    <span class="security-notice__icon"><x-admin.icon name="key" /></span>
    <div>
        <strong>Temporary and tightly restricted</strong>
        <p>Codes are encrypted in the cache, visible only to a superadmin, expire with their challenge, and disappear immediately after successful verification.</p>
    </div>
</div>

<section class="content-card otp-card">
    <header class="content-card__header otp-card__header">
        <div><h2>Recent verification requests</h2><p>Showing up to 50 requests created during the last 24 hours.</p></div>
        <form class="otp-filter" method="GET" action="{{ route('admin.tools.otps') }}">
            <label class="sr-only" for="phone">Filter by phone number</label>
            <input id="phone" name="phone" type="search" value="{{ $phone }}" placeholder="Filter by phone number" maxlength="20">
            <button type="submit">Filter</button>
            @if ($phone !== '')<a href="{{ route('admin.tools.otps') }}">Clear</a>@endif
        </form>
    </header>

    @if ($challenges->isEmpty())
        <div class="empty-state">
            <span><x-admin.icon name="key" size="24" /></span>
            <h3>No verification requests found</h3>
            <p>Request a code from the mobile app, then refresh this page.</p>
        </div>
    @else
        <div class="table-scroll">
            <table class="data-table otp-table">
                <thead><tr><th>Phone number</th><th>Purpose</th><th>Code</th><th>Status</th><th>Expires</th><th>Requested</th></tr></thead>
                <tbody>
                @foreach ($challenges as $item)
                    @php($challenge = $item['challenge'])
                    <tr>
                        <td><strong>{{ $challenge->phone_e164 }}</strong><small>{{ $challenge->user?->name ?: 'Account not created yet' }}</small></td>
                        <td>{{ str($challenge->purpose->value)->replace('_', ' ')->headline() }}</td>
                        <td>
                            @if ($item['code'])
                                <button class="otp-code" type="button" data-copy-value="{{ $item['code'] }}" title="Copy this code">
                                    <span>{{ $item['code'] }}</span><small data-copy-label>Copy</small>
                                </button>
                            @else
                                <span class="otp-unavailable">Unavailable</span>
                            @endif
                        </td>
                        <td><span class="status-pill status-pill--{{ $challenge->status->value }}">{{ str($challenge->status->value)->headline() }}</span></td>
                        <td>
                            @if ($challenge->expires_at->isFuture())
                                <span>{{ $challenge->expires_at->diffForHumans() }}</span><small>{{ $challenge->expires_at->format('h:i A') }}</small>
                            @else
                                <span>Expired</span><small>{{ $challenge->expires_at->format('h:i A') }}</small>
                            @endif
                        </td>
                        <td><span>{{ $challenge->created_at->diffForHumans() }}</span><small>{{ $challenge->created_at->format('d M, h:i A') }}</small></td>
                    </tr>
                @endforeach
                </tbody>
            </table>
        </div>
    @endif
</section>
@endsection
