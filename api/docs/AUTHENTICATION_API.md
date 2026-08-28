# Authentication API

The customer authentication API is versioned below `/api/v1/auth`. It uses a
phone number in E.164 format, such as `+923001234567`.

## Endpoints

| Method | Endpoint | Purpose | Authentication |
| --- | --- | --- | --- |
| POST | `/register/request-otp` | Request a registration OTP | Public |
| POST | `/register` | Verify OTP and create the account, business and trial | Public |
| POST | `/login` | Sign in with phone number and password | Public |
| POST | `/token/refresh` | Rotate access and refresh tokens | Refresh token |
| POST | `/password/request-otp` | Request a password-recovery OTP | Public |
| POST | `/password/verify-otp` | Verify recovery OTP and receive a reset token | Public |
| POST | `/password/reset` | Change the password and revoke existing sessions | Reset token |
| GET | `/me` | Get the authenticated customer and memberships | Bearer token |
| POST | `/logout` | Revoke the current session | Bearer token |
| POST | `/logout-all` | Revoke every session for the customer | Bearer token |

## Local OTP testing

The development driver is `log`. It records delivery in `whatsapp_messages` and
writes the plain OTP only to `storage/logs/laravel.log`:

```powershell
Get-Content storage\logs\laravel.log -Tail 30
```

The log driver must not be used in production. A real WhatsApp implementation
will replace `LogOtpDeliveryGateway` while keeping the same
`OtpDeliveryGateway` contract.

## Example registration

Start the server:

```powershell
& 'C:\php8.3\php.exe' artisan serve --host=127.0.0.1 --port=8000
```

Request an OTP:

```http
POST /api/v1/auth/register/request-otp
Content-Type: application/json

{
  "phone_e164": "+923001234567",
  "installation_uuid": "b2ab3047-cfc8-4b2f-86e0-a72345c84991",
  "device_model": "Android phone",
  "os_version": "7.0",
  "app_version": "1.0.0"
}
```

Read the local OTP from the log, then complete registration using the returned
`otp_challenge_id`:

```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "otp_challenge_id": "01K...",
  "otp": "123456",
  "name": "Ayesha Khan",
  "business_name": "Ayesha Tailors",
  "preferred_locale": "ur",
  "password": "Tailor123",
  "password_confirmation": "Tailor123",
  "installation_uuid": "b2ab3047-cfc8-4b2f-86e0-a72345c84991",
  "device_model": "Android phone",
  "os_version": "7.0",
  "app_version": "1.0.0"
}
```

Send the returned access token on protected requests:

```http
Authorization: Bearer ACCESS_TOKEN
```

## How a Laravel API request works

```text
Flutter request
    -> Route
    -> Middleware
    -> Form Request validation
    -> Controller
    -> Service/business rules
    -> Eloquent models
    -> MySQL
    -> API Resource/JSON response
```

## Terminology

- **API**: A defined way for Flutter and Laravel to exchange requests and data.
- **Endpoint**: One HTTP method and URL, such as `POST /api/v1/auth/login`.
- **Route**: Laravel's mapping from an endpoint to a controller method.
- **Controller**: Receives a valid HTTP request and chooses the application action.
- **Form Request**: A Laravel class that authorizes and validates incoming fields.
- **Service**: A class containing business rules that should not live in a controller.
- **Model / Eloquent**: The PHP representation of a database record and its relationships.
- **Migration**: Version-controlled instructions for creating or changing database tables.
- **Middleware**: Code that runs around a request; `auth.access` validates bearer tokens.
- **API Resource**: Controls which model fields are exposed in a JSON response.
- **Dependency injection**: Laravel supplies a controller or service's required objects automatically.
- **Contract / interface**: A promise describing methods an implementation must provide. It lets the log OTP sender later be replaced by a WhatsApp provider.
- **Driver / provider**: A concrete implementation of a capability, such as local log delivery or WhatsApp delivery.
- **E.164**: International phone-number notation beginning with `+` and a country code.
- **OTP**: A short-lived one-time password used to prove control of a phone number.
- **Access token**: A short-lived bearer credential used on protected API requests.
- **Refresh token**: A longer-lived, one-use credential that rotates both tokens without asking for the password again.
- **Hashing**: One-way storage used for passwords, OTPs and tokens so plaintext secrets are not stored in MySQL.
- **Rate limiting**: Restricts repeated OTP or login requests to reduce abuse.
- **Database transaction**: Makes registration all-or-nothing; partial users or subscriptions cannot remain after a failure.
- **Tenant**: One customer business whose data must remain isolated from other businesses.
- **Authorization**: Decides what an authenticated user may do within a tenant. Authentication only proves who the user is.
- **HTTP status code**: Numeric result such as `200` success, `201` created, `202` accepted, `401` unauthenticated or `422` validation failed.

## Creating another API endpoint

1. Add the route in `routes/api.php`.
2. Create a Form Request for input validation.
3. Add a controller method.
4. Put reusable business rules in a service.
5. Read or write data through Eloquent models.
6. Return a stable JSON shape, preferably through an API Resource.
7. Add feature tests for success, validation, authorization and failure cases.
8. Run `php artisan test` and `vendor/bin/pint --test`.
