@props(['name', 'size' => 20])

@switch($name)
    @case('dashboard')
        <svg {{ $attributes }} width="{{ $size }}" height="{{ $size }}" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M4 13h6V4H4v9Zm0 7h6v-4H4v4Zm10 0h6v-9h-6v9Zm0-16v4h6V4h-6Z" fill="currentColor"/>
        </svg>
        @break
    @case('business')
        <svg {{ $attributes }} width="{{ $size }}" height="{{ $size }}" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M4 21V5.8c0-.56 0-.84.11-1.05.1-.19.25-.34.44-.44.21-.11.49-.11 1.05-.11h8.8c.56 0 .84 0 1.05.11.19.1.34.25.44.44.11.21.11.49.11 1.05V9h2.4c.56 0 .84 0 1.05.11.19.1.34.25.44.44.11.21.11.49.11 1.05V21M2 21h20M8 8h4m-4 4h4m-4 4h4" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        @break
    @case('users')
        <svg {{ $attributes }} width="{{ $size }}" height="{{ $size }}" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2m7-10a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm13 10v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        @break
    @case('subscription')
        <svg {{ $attributes }} width="{{ $size }}" height="{{ $size }}" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <rect x="3" y="5" width="18" height="14" rx="3" stroke="currentColor" stroke-width="1.8"/>
            <path d="M3 10h18M7 15h3" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
        </svg>
        @break
    @case('payment')
        <svg {{ $attributes }} width="{{ $size }}" height="{{ $size }}" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M4 7.5h13a3 3 0 0 1 3 3v7a2 2 0 0 1-2 2H5a3 3 0 0 1-3-3v-10a2 2 0 0 1 2-2h12" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M20 11h-4a2 2 0 1 0 0 4h4v-4Z" stroke="currentColor" stroke-width="1.8"/><circle cx="16" cy="13" r=".8" fill="currentColor"/>
        </svg>
        @break
    @case('audit')
        <svg {{ $attributes }} width="{{ $size }}" height="{{ $size }}" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M9 5h10M9 9h10M9 13h6M5 5h.01M5 9h.01M5 13h.01M4 21h16a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2Z" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        @break
    @case('key')
        <svg {{ $attributes }} width="{{ $size }}" height="{{ $size }}" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <circle cx="8" cy="15" r="4" stroke="currentColor" stroke-width="1.8"/>
            <path d="m11 12 8-8m-2 2 2 2m-5 1 2 2" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        @break
    @case('settings')
        <svg {{ $attributes }} width="{{ $size }}" height="{{ $size }}" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.8"/>
            <path d="M19.4 15a1.7 1.7 0 0 0 .34 1.88l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.7 1.7 0 0 0-1.88-.34 1.7 1.7 0 0 0-1.03 1.56V21a2 2 0 1 1-4 0v-.09A1.7 1.7 0 0 0 9 19.37a1.7 1.7 0 0 0-1.88.34l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.7 1.7 0 0 0 4.63 15 1.7 1.7 0 0 0 3.09 14H3a2 2 0 1 1 0-4h.09A1.7 1.7 0 0 0 4.63 9a1.7 1.7 0 0 0-.34-1.88l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06A1.7 1.7 0 0 0 9 4.63h.01A1.7 1.7 0 0 0 10 3.09V3a2 2 0 1 1 4 0v.09a1.7 1.7 0 0 0 1.03 1.54 1.7 1.7 0 0 0 1.88-.34l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06A1.7 1.7 0 0 0 19.37 9v.01A1.7 1.7 0 0 0 20.91 10H21a2 2 0 1 1 0 4h-.09A1.7 1.7 0 0 0 19.4 15Z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        @break
    @case('logout')
        <svg {{ $attributes }} width="{{ $size }}" height="{{ $size }}" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M10 17l5-5-5-5m5 5H3m12-9h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        @break
    @case('menu')
        <svg {{ $attributes }} width="{{ $size }}" height="{{ $size }}" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M4 7h16M4 12h16M4 17h16" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
        </svg>
        @break
    @case('eye')
        <svg {{ $attributes }} width="{{ $size }}" height="{{ $size }}" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M2.5 12s3.5-6 9.5-6 9.5 6 9.5 6-3.5 6-9.5 6-9.5-6-9.5-6Z" stroke="currentColor" stroke-width="1.8"/><circle cx="12" cy="12" r="2.5" stroke="currentColor" stroke-width="1.8"/>
        </svg>
        @break
    @default
        <svg {{ $attributes }} width="{{ $size }}" height="{{ $size }}" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.8"/>
        </svg>
@endswitch
