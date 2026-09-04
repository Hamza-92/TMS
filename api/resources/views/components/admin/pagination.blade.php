@props(['paginator'])

@if ($paginator->hasPages())
    <nav class="pagination" aria-label="Pagination">
        <p>
            Showing <strong>{{ number_format($paginator->firstItem()) }}</strong>–<strong>{{ number_format($paginator->lastItem()) }}</strong>
            of <strong>{{ number_format($paginator->total()) }}</strong>
        </p>
        <div class="pagination__controls">
            @if ($paginator->onFirstPage())
                <span class="pagination__button is-disabled" aria-disabled="true">Previous</span>
            @else
                <a class="pagination__button" href="{{ $paginator->previousPageUrl() }}" rel="prev">Previous</a>
            @endif

            <span class="pagination__page">Page {{ $paginator->currentPage() }} of {{ $paginator->lastPage() }}</span>

            @if ($paginator->hasMorePages())
                <a class="pagination__button" href="{{ $paginator->nextPageUrl() }}" rel="next">Next</a>
            @else
                <span class="pagination__button is-disabled" aria-disabled="true">Next</span>
            @endif
        </div>
    </nav>
@endif
