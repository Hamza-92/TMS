@extends('layouts.admin')

@section('title', 'Subscription plans')

@section('content')
@php
    $canManage = auth('admin')->user()->role === \App\Enums\AdminRole::Superadmin;
    $showEditor = ($createMode && $canManage) || $editingPlan;
    $isEditing = (bool) $editingPlan;
    $billingLocked = $isEditing && ($editingPlan->subscriptions_count > 0 || $editingPlan->payments_count > 0);
    $isSystemPlan = $isEditing && $editingPlan->code === config('authentication.trial.plan_code');
    $formDisabled = ! $canManage || $isSystemPlan;
    $selectedPlan = $editingPlan;
@endphp

<section class="page-heading">
    <div>
        <h1>Subscription plans</h1>
        <p>Configure pricing, access limits and availability without leaving this workspace.</p>
    </div>
    @if ($canManage)
        <a class="filter-button page-heading__action" href="{{ route('admin.plans.index', ['create' => 1]) }}#plan-editor">Add paid plan</a>
    @endif
</section>

<section class="plan-status-grid" aria-label="Plan status summary">
    @foreach ([['all', 'All plans'], ['active', 'Available'], ['inactive', 'Unavailable']] as [$key, $label])
        <a
            @class([
                'business-status-card',
                'is-selected' => ($key === 'all' && ! $filters['status']) || $filters['status'] === $key,
            ])
            href="{{ $key === 'all' ? route('admin.plans.index') : route('admin.plans.index', ['status' => $key]) }}"
        >
            <span>{{ $label }}</span>
            <strong>{{ number_format($counts[$key]) }}</strong>
        </a>
    @endforeach
</section>

<div @class(['plan-workspace', 'plan-workspace--editing' => $showEditor])>
    <section class="content-card plan-list-card">
        <header class="business-list-toolbar">
            <form class="business-filter" method="GET" action="{{ route('admin.plans.index') }}">
                <label class="search-control">
                    <span class="sr-only">Search plans</span>
                    <x-admin.icon name="search" size="18" />
                    <input name="q" type="search" value="{{ $filters['q'] }}" placeholder="Search plan name or code" autocomplete="off">
                </label>
                <label class="select-control">
                    <span class="sr-only">Plan availability</span>
                    <select name="status">
                        <option value="">All availability</option>
                        <option value="active" @selected($filters['status'] === 'active')>Available</option>
                        <option value="inactive" @selected($filters['status'] === 'inactive')>Unavailable</option>
                    </select>
                </label>
                <button class="filter-button" type="submit">Apply</button>
                @if ($filters['q'] || $filters['status'])
                    <a class="clear-filter" href="{{ route('admin.plans.index') }}">Clear</a>
                @endif
            </form>
        </header>

        @if ($plans->isEmpty())
            <div class="empty-state">
                <span><x-admin.icon name="subscription" size="24" /></span>
                <h3>No plans found</h3>
                <p>Clear the filters or create the first paid plan.</p>
            </div>
        @else
            <div class="plan-list">
                @foreach ($plans as $plan)
                    @php($planIsSystem = $plan->code === config('authentication.trial.plan_code'))
                    <article @class(['plan-list__item', 'is-selected' => $editingPlan?->is($plan)])>
                        <a class="plan-list__main" href="{{ route('admin.plans.index', ['edit' => $plan->id]) }}#plan-editor">
                            <span class="plan-list__icon"><x-admin.icon name="subscription" size="19" /></span>
                            <div class="plan-list__identity">
                                <div><strong>{{ $plan->name }}</strong><span class="status-pill status-pill--{{ $plan->is_active ? 'active' : 'blocked' }}">{{ $plan->is_active ? 'Available' : 'Unavailable' }}</span></div>
                                <small>{{ $planIsSystem ? 'Automatic demo' : str($plan->billing_period->value)->headline() }} · {{ $plan->currency_code }} {{ number_format((float) $plan->price, 2) }}</small>
                            </div>
                            <dl class="plan-list__metrics">
                                <div><dt>Subscriptions</dt><dd>{{ number_format($plan->subscriptions_count) }}</dd></div>
                                <div><dt>Pending</dt><dd>{{ number_format($plan->pending_payments_count) }}</dd></div>
                            </dl>
                            <span class="row-action">{{ $canManage && ! $planIsSystem ? 'Edit' : 'View' }} <x-admin.icon name="arrow-right" size="15" /></span>
                        </a>

                        @if ($canManage && ! $planIsSystem)
                            <form class="plan-list__toggle" method="POST" action="{{ route('admin.plans.toggle', $plan) }}">
                                @csrf
                                <button class="{{ $plan->is_active ? 'quiet-danger-button' : 'quiet-success-button' }}" type="submit">
                                    {{ $plan->is_active ? 'Make unavailable' : 'Make available' }}
                                </button>
                            </form>
                        @elseif ($canManage && $planIsSystem)
                            <div class="plan-list__toggle"><span class="required-plan-label">Required for registration</span></div>
                        @endif
                    </article>
                @endforeach
            </div>
            <x-admin.pagination :paginator="$plans" />
        @endif
    </section>

    @if ($showEditor)
        <section class="content-card plan-editor" id="plan-editor">
            <header class="content-card__header">
                <div>
                    <h2>{{ $isEditing ? ($formDisabled ? 'Plan details' : 'Edit plan') : 'Add paid plan' }}</h2>
                    <p>{{ $isEditing ? 'Code: '.$editingPlan->code : 'Complete the full paid-plan setup below.' }}</p>
                </div>
                <a class="editor-close" href="{{ route('admin.plans.index') }}" aria-label="Close plan editor">×</a>
            </header>

            @if ($isSystemPlan)
                <div class="editor-notice"><x-admin.icon name="alert" size="17" /><p>This demo plan starts automatically during customer registration. It is intentionally read-only here.</p></div>
            @elseif ($billingLocked)
                <div class="editor-notice"><x-admin.icon name="alert" size="17" /><p>Billing is locked because this plan has history. Create a new plan to introduce a different price or period.</p></div>
            @endif

            <form class="plan-form" method="POST" action="{{ $isEditing ? route('admin.plans.update', $editingPlan) : route('admin.plans.store') }}">
                @csrf
                @if ($isEditing) @method('PUT') @endif

                <fieldset @disabled($formDisabled)>
                    <legend><span>1</span><div><strong>Plan identity</strong><small>Customer-facing name and explanation.</small></div></legend>
                    <label class="admin-field">
                        <span>Plan name</span>
                        <input name="name" value="{{ old('name', $selectedPlan?->name) }}" maxlength="100" required placeholder="For example: Professional Monthly">
                        @error('name')<small class="field-error">{{ $message }}</small>@enderror
                    </label>
                    <label class="admin-field">
                        <span>Description <small>Optional</small></span>
                        <textarea name="description" rows="3" maxlength="1000" placeholder="Explain who this plan is suitable for">{{ old('description', $selectedPlan?->description) }}</textarea>
                        @error('description')<small class="field-error">{{ $message }}</small>@enderror
                    </label>
                </fieldset>

                <fieldset @disabled($formDisabled)>
                    <legend><span>2</span><div><strong>Billing</strong><small>Price and access duration.</small></div></legend>
                    <div class="admin-field-grid">
                        <label class="admin-field">
                            <span>Billing period</span>
                            @if ($billingLocked || $isSystemPlan)
                                <input type="hidden" name="billing_period" value="{{ old('billing_period', $selectedPlan?->billing_period->value) }}">
                            @endif
                            <select name="billing_period" required @disabled($billingLocked || $formDisabled)>
                                @foreach ([
                                    \App\Enums\BillingPeriod::Monthly,
                                    \App\Enums\BillingPeriod::Quarterly,
                                    \App\Enums\BillingPeriod::Yearly,
                                ] as $period)
                                    <option value="{{ $period->value }}" @selected(old('billing_period', $selectedPlan?->billing_period->value ?? 'monthly') === $period->value)>{{ str($period->value)->headline() }}</option>
                                @endforeach
                                @if ($isSystemPlan)<option value="custom" selected>Custom demo period</option>@endif
                            </select>
                            @error('billing_period')<small class="field-error">{{ $message }}</small>@enderror
                        </label>
                        <label class="admin-field">
                            <span>Price</span>
                            @if ($billingLocked || $isSystemPlan)
                                <input type="hidden" name="price" value="{{ old('price', $selectedPlan?->price) }}">
                            @endif
                            <span class="money-input"><b>PKR</b><input name="price" type="number" min="1" max="9999999999.99" step="0.01" value="{{ old('price', $selectedPlan?->price) }}" required placeholder="1500" @disabled($billingLocked || $formDisabled)></span>
                            @error('price')<small class="field-error">{{ $message }}</small>@enderror
                        </label>
                    </div>
                </fieldset>

                <fieldset @disabled($formDisabled)>
                    <legend><span>3</span><div><strong>Included access</strong><small>Features and practical account limits.</small></div></legend>
                    <div class="feature-options">
                        @foreach ([
                            ['cloud_backup', 'Cloud backup'],
                            ['reports', 'Reports'],
                            ['staff_accounts', 'Staff accounts'],
                        ] as [$key, $label])
                            <label><input type="hidden" name="features[{{ $key }}]" value="0"><input type="checkbox" name="features[{{ $key }}]" value="1" @checked(old("features.{$key}", data_get($selectedPlan?->features, $key, true)))><span>{{ $label }}</span></label>
                        @endforeach
                    </div>
                    <div class="admin-field-grid admin-field-grid--three">
                        @foreach ([
                            ['staff', 'Staff accounts', 5],
                            ['devices', 'Devices', 3],
                            ['customers', 'Customers', 1000],
                        ] as [$key, $label, $default])
                            <label class="admin-field">
                                <span>{{ $label }}</span>
                                <input name="limits[{{ $key }}]" type="number" min="1" value="{{ old("limits.{$key}", data_get($selectedPlan?->limits, $key, $default)) }}" required>
                                @error("limits.{$key}")<small class="field-error">{{ $message }}</small>@enderror
                            </label>
                        @endforeach
                    </div>
                </fieldset>

                @if ($canManage && ! $isSystemPlan)
                    <div class="plan-form__footer">
                        <label class="availability-toggle">
                            <input type="hidden" name="is_active" value="0">
                            <input type="checkbox" name="is_active" value="1" @checked(old('is_active', $selectedPlan?->is_active ?? true))>
                            <span><strong>Available for new payment requests</strong><small>Existing subscriptions are never removed when availability changes.</small></span>
                        </label>
                        <button class="filter-button" type="submit">{{ $isEditing ? 'Save plan' : 'Create plan' }}</button>
                    </div>
                @endif
            </form>
        </section>
    @else
        <aside class="content-card plan-editor-placeholder" id="plan-editor">
            <span><x-admin.icon name="subscription" size="24" /></span>
            <h2>Select a plan</h2>
            <p>Open a plan to inspect its complete setup{{ $canManage ? ', or add a paid plan here.' : '.' }}</p>
            @if ($canManage)<a class="filter-button" href="{{ route('admin.plans.index', ['create' => 1]) }}#plan-editor">Add paid plan</a>@endif
        </aside>
    @endif
</div>
@endsection
