class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.phoneE164,
    required this.preferredLocale,
    this.status = 'active',
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'] as String,
    name: json['name'] as String,
    phoneE164: json['phone_e164'] as String,
    preferredLocale: json['preferred_locale'] as String? ?? 'en',
    status: json['status'] as String? ?? 'active',
  );

  final String id;
  final String name;
  final String phoneE164;
  final String preferredLocale;
  final String status;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone_e164': phoneE164,
    'preferred_locale': preferredLocale,
    'status': status,
  };
}

class AuthSubscription {
  const AuthSubscription({
    required this.id,
    required this.planCode,
    required this.source,
    required this.status,
    required this.startsAt,
    required this.expiresAt,
    this.offlineGraceUntil,
  });

  factory AuthSubscription.fromJson(Map<String, dynamic> json) =>
      AuthSubscription(
        id: json['id'] as String,
        planCode: json['plan_code'] as String? ?? '',
        source: json['source'] as String,
        status: json['status'] as String,
        startsAt: DateTime.parse(json['starts_at'] as String),
        expiresAt: DateTime.parse(json['expires_at'] as String),
        offlineGraceUntil: _optionalDate(json['offline_grace_until']),
      );

  final String id;
  final String planCode;
  final String source;
  final String status;
  final DateTime startsAt;
  final DateTime expiresAt;
  final DateTime? offlineGraceUntil;

  Map<String, dynamic> toJson() => {
    'id': id,
    'plan_code': planCode,
    'source': source,
    'status': status,
    'starts_at': startsAt.toIso8601String(),
    'expires_at': expiresAt.toIso8601String(),
    'offline_grace_until': offlineGraceUntil?.toIso8601String(),
  };
}

class AuthBusinessAccess {
  const AuthBusinessAccess({
    required this.state,
    required this.canUseApp,
    required this.onlineVerificationRequired,
    this.reason,
    this.validUntil,
  });

  factory AuthBusinessAccess.fromJson(Map<String, dynamic> json) =>
      AuthBusinessAccess(
        state: json['state'] as String? ?? 'blocked',
        canUseApp: json['can_use_app'] as bool? ?? false,
        onlineVerificationRequired:
            json['online_verification_required'] as bool? ?? false,
        reason: json['reason'] as String?,
        validUntil: _optionalDate(json['valid_until']),
      );

  final String state;
  final bool canUseApp;
  final bool onlineVerificationRequired;
  final String? reason;
  final DateTime? validUntil;

  Map<String, dynamic> toJson() => {
    'state': state,
    'can_use_app': canUseApp,
    'online_verification_required': onlineVerificationRequired,
    'reason': reason,
    'valid_until': validUntil?.toIso8601String(),
  };
}

class AuthBusiness {
  const AuthBusiness({
    required this.id,
    required this.name,
    required this.role,
    required this.membershipStatus,
    required this.businessStatus,
    required this.countryCode,
    required this.currencyCode,
    required this.timezone,
    required this.preferredLocale,
    required this.access,
    this.subscription,
  });

  factory AuthBusiness.fromJson(Map<String, dynamic> json) => AuthBusiness(
    id: json['id'] as String,
    name: json['name'] as String,
    role: json['role'] as String,
    membershipStatus: json['membership_status'] as String,
    businessStatus:
        json['status'] as String? ??
        json['business_status'] as String? ??
        'active',
    countryCode: json['country_code'] as String? ?? 'PK',
    currencyCode: json['currency_code'] as String? ?? 'PKR',
    timezone: json['timezone'] as String? ?? 'Asia/Karachi',
    preferredLocale: json['preferred_locale'] as String? ?? 'en',
    subscription: json['subscription'] is Map
        ? AuthSubscription.fromJson(
            Map<String, dynamic>.from(json['subscription'] as Map),
          )
        : null,
    access: AuthBusinessAccess.fromJson(
      Map<String, dynamic>.from(json['access'] as Map? ?? const {}),
    ),
  );

  final String id;
  final String name;
  final String role;
  final String membershipStatus;
  final String businessStatus;
  final String countryCode;
  final String currencyCode;
  final String timezone;
  final String preferredLocale;
  final AuthSubscription? subscription;
  final AuthBusinessAccess access;

  bool canUseAppAt(DateTime now) {
    if (!access.canUseApp || access.state == 'blocked') return false;
    if (membershipStatus != 'active' || businessStatus != 'active') {
      return false;
    }

    final currentSubscription = subscription;
    if (currentSubscription == null ||
        !const {
          'trialing',
          'active',
          'grace',
        }.contains(currentSubscription.status)) {
      return false;
    }
    if (now.isBefore(currentSubscription.expiresAt)) return true;
    final graceUntil = currentSubscription.offlineGraceUntil;
    return graceUntil != null && now.isBefore(graceUntil);
  }

  bool requiresOnlineVerificationAt(DateTime now) {
    final currentSubscription = subscription;
    return canUseAppAt(now) &&
        currentSubscription != null &&
        !now.isBefore(currentSubscription.expiresAt);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'membership_status': membershipStatus,
    'status': businessStatus,
    'country_code': countryCode,
    'currency_code': currencyCode,
    'timezone': timezone,
    'preferred_locale': preferredLocale,
    'subscription': subscription?.toJson(),
    'access': access.toJson(),
  };
}

class AuthSessionSnapshot {
  const AuthSessionSnapshot({
    required this.user,
    required this.businesses,
    required this.syncedAt,
    this.selectedBusinessId,
  });

  factory AuthSessionSnapshot.fromJson(
    Map<String, dynamic> json, {
    String? preferredBusinessId,
  }) {
    final businesses = (json['businesses'] as List? ?? const [])
        .whereType<Map>()
        .map((item) => AuthBusiness.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
    final requestedId =
        preferredBusinessId ?? json['selected_business_id'] as String?;
    final selectedId = businesses.any((item) => item.id == requestedId)
        ? requestedId
        : businesses.firstOrNull?.id;

    return AuthSessionSnapshot(
      user: AuthUser.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
      businesses: businesses,
      selectedBusinessId: selectedId,
      syncedAt: _optionalDate(json['synced_at']) ?? DateTime.now(),
    );
  }

  final AuthUser user;
  final List<AuthBusiness> businesses;
  final String? selectedBusinessId;
  final DateTime syncedAt;

  AuthBusiness? get selectedBusiness {
    for (final business in businesses) {
      if (business.id == selectedBusinessId) return business;
    }
    return businesses.firstOrNull;
  }

  AuthSessionSnapshot selectBusiness(String businessId) {
    if (!businesses.any((business) => business.id == businessId)) return this;
    return AuthSessionSnapshot(
      user: user,
      businesses: businesses,
      selectedBusinessId: businessId,
      syncedAt: syncedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'businesses': businesses.map((item) => item.toJson()).toList(),
    'selected_business_id': selectedBusinessId,
    'synced_at': syncedAt.toIso8601String(),
  };
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
  const AuthResult({required this.session, required this.tokens});

  final AuthSessionSnapshot session;
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

DateTime? _optionalDate(Object? value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value);
}
