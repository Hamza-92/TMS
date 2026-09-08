# Tailor App

Production-oriented foundation for an offline-first Tailor Management mobile
application and its Laravel SaaS API. Authentication, subscription-aware tenant
access, superadmin operations, customer management, and the Laravel foundation
for versioned measurement templates and customer measurement histories are
implemented.

## Repository structure

```text
.
├── mobile/   Flutter/Dart Android application
├── api/      Laravel 13 REST API
├── docs/     Architecture documentation
├── .vscode/  Recommended editor setup
├── .gitignore
└── README.md
```

## Requirements

- Flutter 3.47.0 stable with Dart 3.13.0
- Android Studio/Android SDK and Android platform tools
- PHP 8.3 or newer with the extensions listed in `api/php.ini.example`
- Composer 2
- MySQL 8-compatible server
- VS Code with the recommended Dart, Flutter, and PHP extensions (optional)

On this Windows workstation, Flutter is installed at
`C:\flutter\flutter` and PHP 8.3 at `C:\php8.3`. Add their executable
directories to your user `Path` if you want to call `flutter`, `dart`, and
`php` without absolute paths.

## Mobile setup

```powershell
cd mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

The app uses Riverpod, `go_router`, Drift/SQLite, Dio, secure token storage, and
device-generated UUIDs for offline-created records.

Generated Drift and localization files are produced from source definitions.
Re-run the build-runner command after changing Drift tables. Flutter generates
localizations during `flutter pub get`, `flutter run`, or `flutter gen-l10n`.

### Environment configuration

Runtime configuration uses Dart defines; API URLs are not embedded in widgets
or repositories.

```powershell
flutter run `
  --dart-define=APP_ENV=development `
  --dart-define=API_BASE_URL=http://<computer-lan-ip>:8000
```

Use `APP_ENV=staging` or `APP_ENV=production` with the appropriate HTTPS API
URL for those environments. Cleartext HTTP is allowed only by the Android debug
manifest for LAN development.

## Physical Android phone

1. Install Android Studio and its Android SDK/platform tools.
2. Enable Developer Options on the phone (usually by tapping Build Number seven
   times in Settings > About phone).
3. Enable USB Debugging.
4. Connect the phone by USB and approve the debugging authorization prompt.
5. Run `flutter doctor`, then `flutter devices`.
6. Start the app from `mobile` with the `flutter run` command above.

An emulator is not required. Wireless Debugging can be paired later from the
phone's Developer Options and Android platform tools.

### Connect the phone to the local API

The phone's `localhost` is the phone itself. Put the computer and phone on the
same trusted network, find the computer's LAN IPv4 address, start Laravel on all
interfaces, and pass that address as `API_BASE_URL`:

```powershell
php artisan serve --host=0.0.0.0 --port=8000
flutter run --dart-define=APP_ENV=development `
  --dart-define=API_BASE_URL=http://<computer-lan-ip>:8000
```

Allow inbound TCP port 8000 through the Windows firewall only for the trusted
private network profile. Test `http://<computer-lan-ip>:8000/api/v1/health`
from the phone's browser before debugging the app.

## Localization

ARB files provide English (`en`, LTR), Urdu (`ur-Arab-PK`, RTL), and Roman Urdu
(`ur-Latn-PK`, LTR). Flutter's global widget localizations classify Urdu by
language as RTL, so the app explicitly respects the `Latn` script override for
Roman Urdu. The foundation screen includes a temporary language selector solely
to verify all three locales.

## Laravel API setup

Copy the PHP extension example when using the portable PHP directory, then
install dependencies and configure a local environment:

```powershell
Copy-Item api/php.ini.example C:\php8.3\php.ini
cd api
Copy-Item .env.example .env
composer install
php artisan key:generate
```

Create an empty MySQL database and update only the local `api/.env` values:

```dotenv
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=tailor_app
DB_USERNAME=root
DB_PASSWORD=
```

Then run:

```powershell
php artisan migrate
php artisan serve --host=0.0.0.0 --port=8000
```

Verify the public endpoint at `GET /api/v1/health`. All mobile-facing routes
remain below `/api/v1`. See `api/docs/AUTHENTICATION_API.md`,
`api/docs/CUSTOMERS_API.md`, and `api/docs/MEASUREMENTS_API.md` for the
implemented contracts.

## Offline-first rule

SQLite is the mobile application's primary operational data source. Laravel is
for synchronization, backup, account, subscription, and recovery services.
Normal tailor data must save locally without internet access, and future UI code
must not wait for an HTTP request before treating a local operation as saved.

See `docs/architecture/README.md` for the layer boundary and future sync flow.

## Staging deployment

The Laravel staging CI/CD workflow and its one-time hPanel transition are
documented in `docs/deployment/STAGING.md`.
