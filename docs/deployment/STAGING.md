# Staging deployment

The Laravel API is deployed to:

```text
/home/u496151366/domains/counterpos.pk/public_html/TailorApp/api
```

The `tailor.counterpos.pk` document root must remain pointed at:

```text
/home/u496151366/domains/counterpos.pk/public_html/TailorApp/api/public
```

GitHub Actions is the single deployment owner. Do not enable hPanel automatic
deployment at the same time because both systems would react to the same push
and could update the application concurrently.

## One-time transition from hPanel auto-deployment

The deployment job is guarded by the GitHub repository variable
`SSH_DEPLOY_ENABLED`. Follow this order:

1. Leave `SSH_DEPLOY_ENABLED` absent or set it to `false`.
2. Push the workflow and confirm that the `Test Laravel API` job passes. The
   deploy job will be skipped during this transition.
3. Disable automatic deployment in hPanel. The GitHub integration can remain
   connected for visibility or manual recovery, but it must not deploy on push.
4. Add and verify all required GitHub Actions secrets listed below.
5. Create the repository variable `SSH_DEPLOY_ENABLED` with the value `true`.
6. Run the workflow manually once and confirm both jobs and the health check
   pass.

After the transition, pushes to `main` that change `api/**` or the deployment
workflow are tested and deployed automatically.

## Required GitHub configuration

Repository variable:

```text
SSH_DEPLOY_ENABLED=true
```

Repository or `staging` environment secrets:

```text
DEPLOY_PATH=/home/u496151366/domains/counterpos.pk/public_html/TailorApp
SSH_HOST=<Hostinger SSH hostname>
SSH_PORT=<Hostinger SSH port>
SSH_USERNAME=<Hostinger SSH username>
SSH_PRIVATE_KEY=<private deployment key>
SSH_KNOWN_HOSTS=<verified known_hosts line>
```

Generate the `SSH_KNOWN_HOSTS` value from a trusted computer:

```bash
ssh-keyscan -p <SSH_PORT> <SSH_HOST>
```

Verify the displayed fingerprint against Hostinger's SSH information before
saving the complete output line as the secret. Do not copy an unverified scan
directly from a CI run.

## Deployment behavior

The workflow:

- runs Pint and the complete Laravel test suite first;
- serializes deployments so two pushes cannot deploy concurrently;
- packages only the contents of `api/`;
- validates the exact allowed server path before file synchronization;
- keeps the server-side `.env`, `storage/`, and `public/storage` intact;
- installs production dependencies in a temporary staging directory;
- places the application in maintenance mode before synchronizing files;
- removes files that were deleted from Git while preserving runtime data;
- runs `optimize:clear`, isolated forced migrations, `optimize`, and
  `queue:restart`;
- restores normal service and checks the public API health endpoint.

Database seeding is intentionally not automatic. Seeders can change business
data and must be run manually only when a reviewed release explicitly requires
them.

## Failed deployment recovery

Dependency and archive failures happen before maintenance mode and do not alter
the live application. If synchronization, migration, or optimization fails
after maintenance mode starts, the application intentionally remains in
maintenance mode rather than serving a potentially inconsistent release.

After resolving the failure through SSH, restore service with:

```bash
cd /home/u496151366/domains/counterpos.pk/public_html/TailorApp/api
php artisan optimize
php artisan up
```

Then rerun the failed GitHub Actions workflow and verify:

```text
https://tailor.counterpos.pk/api/v1/health
```
