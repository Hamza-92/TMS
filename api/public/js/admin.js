document.addEventListener('DOMContentLoaded', () => {
    const shell = document.querySelector('[data-admin-shell]');
    const openButton = document.querySelector('[data-sidebar-open]');
    const closeButton = document.querySelector('[data-sidebar-close]');

    const setSidebar = (open) => {
        if (!shell || !openButton) return;
        shell.classList.toggle('sidebar-is-open', open);
        openButton.setAttribute('aria-expanded', String(open));
        document.body.classList.toggle('has-dialog-open', open);
    };

    openButton?.addEventListener('click', () => setSidebar(true));
    closeButton?.addEventListener('click', () => setSidebar(false));
    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') setSidebar(false);
    });

    document.querySelectorAll('[data-password-toggle]').forEach((button) => {
        button.addEventListener('click', () => {
            const input = button.closest('.password-field')?.querySelector('input');
            if (!input) return;

            const showing = input.type === 'text';
            input.type = showing ? 'password' : 'text';
            button.setAttribute('aria-pressed', String(!showing));
            button.setAttribute('aria-label', showing ? 'Show password' : 'Hide password');
            input.focus();
        });
    });

    document.querySelectorAll('[data-copy-value]').forEach((button) => {
        button.addEventListener('click', async () => {
            const value = button.getAttribute('data-copy-value');
            const label = button.querySelector('[data-copy-label]');
            if (!value || !navigator.clipboard) return;

            await navigator.clipboard.writeText(value);
            if (label) label.textContent = 'Copied';
            window.setTimeout(() => {
                if (label) label.textContent = 'Copy';
            }, 1600);
        });
    });
});
