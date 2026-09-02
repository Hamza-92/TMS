class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.phoneE164,
    required this.preferredLocale,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'] as String,
    name: json['name'] as String,
    phoneE164: json['phone_e164'] as String,
    preferredLocale: json['preferred_locale'] as String? ?? 'en',
  );

  final String id;
  final String name;
  final String phoneE164;
  final String preferredLocale;
}

class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String,
  );

  final String accessToken;
  final String refreshToken;
}

class AuthResult {
  const AuthResult({required this.user, required this.tokens});

  final AuthUser user;
  final AuthTokens tokens;
}

class LoginDraft {
  const LoginDraft({required this.phoneE164});

  final String phoneE164;
}

class OtpChallengeResult {
  const OtpChallengeResult({
    required this.challengeId,
    required this.expiresAt,
    required this.resendAt,
  });

  final String challengeId;
  final DateTime expiresAt;
  final DateTime resendAt;
}

class RegistrationDraft {
  const RegistrationDraft({
    required this.challengeId,
    required this.name,
    required this.businessName,
    required this.phoneE164,
    required this.password,
    required this.preferredLocale,
    required this.installationUuid,
    required this.expiresAt,
    required this.resendAt,
  });

  final String challengeId;
  final String name;
  final String businessName;
  final String phoneE164;
  final String password;
  final String preferredLocale;
  final String installationUuid;
  final DateTime expiresAt;
  final DateTime resendAt;
}

class PasswordOtpDraft {
  const PasswordOtpDraft({
    required this.challengeId,
    required this.phoneE164,
    required this.expiresAt,
    required this.resendAt,
  });

  final String challengeId;
  final String phoneE164;
  final DateTime expiresAt;
  final DateTime resendAt;
}

class PasswordResetDraft {
  const PasswordResetDraft({
    required this.challengeId,
    required this.resetToken,
  });

  final String challengeId;
  final String resetToken;
}
