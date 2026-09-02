import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/core/network/api_client.dart';
import 'package:tailor_app/core/network/api_endpoints.dart';
import 'package:tailor_app/core/network/network_exception.dart';
import 'package:tailor_app/core/storage/secure_storage_service.dart';
import 'package:tailor_app/core/utils/uuid_provider.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/data/auth_session_store.dart';

class AuthRepository {
  AuthRepository({
    required this.client,
    required this.secureStorage,
    required this.sessionStore,
    required this.createUuid,
  });

  final Dio client;
  final SecureStorageService secureStorage;
  final AuthSessionStore sessionStore;
  final String Function() createUuid;

  Future<String> installationUuid() async {
    final existing = await secureStorage.readInstallationUuid();
    if (existing != null && existing.isNotEmpty) return existing;

    final created = createUuid();
    await secureStorage.writeInstallationUuid(created);
    return created;
  }

  Future<OtpChallengeResult> requestRegistrationOtp(String phoneE164) async {
    return _requestOtp(ApiEndpoints.requestRegistrationOtp, phoneE164);
  }

  Future<AuthResult> register({
    required RegistrationDraft draft,
    required String otp,
  }) async {
    try {
      final response = await client.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: {
          'otp_challenge_id': draft.challengeId,
          'otp': otp,
          'name': draft.name,
          'business_name': draft.businessName,
          'preferred_locale': draft.preferredLocale,
          'password': draft.password,
          'password_confirmation': draft.password,
          'installation_uuid': draft.installationUuid,
          ..._deviceData(),
        },
      );

      return await _storeAuthResult(response.data!);
    } on DioException catch (error) {
      throw NetworkException.fromDio(error);
    }
  }

  Future<AuthResult> login({
    required String phoneE164,
    required String password,
  }) async {
    try {
      final response = await client.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {
          'phone_e164': phoneE164,
          'password': password,
          'installation_uuid': await installationUuid(),
          ..._deviceData(),
        },
      );

      return await _storeAuthResult(response.data!);
    } on DioException catch (error) {
      throw NetworkException.fromDio(error);
    }
  }

  Future<AuthSessionSnapshot> currentSession() async {
    try {
      final response = await client.get<Map<String, dynamic>>(ApiEndpoints.me);
      final data = response.data!['data'] as Map<String, dynamic>;
      final session = await _parseSession(data);
      await sessionStore.write(session);
      return session;
    } on DioException catch (error) {
      throw NetworkException.fromDio(error);
    }
  }

  Future<AuthSessionSnapshot?> cachedSession() => sessionStore.read();

  Future<AuthSessionSnapshot> selectBusiness(
    AuthSessionSnapshot session,
    String businessId,
  ) async {
    final selected = session.selectBusiness(businessId);
    await sessionStore.write(selected);
    return selected;
  }

  Future<OtpChallengeResult> requestPasswordOtp(String phoneE164) async {
    return _requestOtp(ApiEndpoints.requestPasswordOtp, phoneE164);
  }

  Future<PasswordResetDraft> verifyPasswordOtp({
    required String challengeId,
    required String otp,
  }) async {
    try {
      final response = await client.post<Map<String, dynamic>>(
        ApiEndpoints.verifyPasswordOtp,
        data: {'otp_challenge_id': challengeId, 'otp': otp},
      );
      final data = response.data!['data'] as Map<String, dynamic>;

      return PasswordResetDraft(
        challengeId: data['otp_challenge_id'] as String,
        resetToken: data['reset_token'] as String,
      );
    } on DioException catch (error) {
      throw NetworkException.fromDio(error);
    }
  }

  Future<void> resetPassword({
    required PasswordResetDraft draft,
    required String password,
  }) async {
    try {
      await client.post<Map<String, dynamic>>(
        ApiEndpoints.resetPassword,
        data: {
          'otp_challenge_id': draft.challengeId,
          'reset_token': draft.resetToken,
          'password': password,
          'password_confirmation': password,
        },
      );
      await secureStorage.deleteAuthTokens();
      await sessionStore.clear();
    } on DioException catch (error) {
      throw NetworkException.fromDio(error);
    }
  }

  Future<void> logout() async {
    try {
      await client.post<void>(ApiEndpoints.logout);
    } on DioException {
      // Local sign-out must still work when the server is unavailable.
    } finally {
      await secureStorage.deleteAuthTokens();
      await sessionStore.clear();
    }
  }

  Future<OtpChallengeResult> _requestOtp(
    String endpoint,
    String phoneE164,
  ) async {
    try {
      final response = await client.post<Map<String, dynamic>>(
        endpoint,
        data: {
          'phone_e164': phoneE164,
          'installation_uuid': await installationUuid(),
          ..._deviceData(),
        },
      );
      final data = response.data!['data'] as Map<String, dynamic>;

      return OtpChallengeResult(
        challengeId: data['otp_challenge_id'] as String,
        expiresAt: DateTime.parse(data['expires_at'] as String),
        resendAt: DateTime.now().add(
          Duration(seconds: data['resend_after_seconds'] as int? ?? 60),
        ),
      );
    } on DioException catch (error) {
      throw NetworkException.fromDio(error);
    }
  }

  Future<AuthResult> _storeAuthResult(Map<String, dynamic> response) async {
    final data = response['data'] as Map<String, dynamic>;
    final tokens = AuthTokens.fromJson(data['tokens'] as Map<String, dynamic>);
    final session = await _parseSession(data);
    await secureStorage.writeTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
    await sessionStore.write(session);

    return AuthResult(session: session, tokens: tokens);
  }

  Future<AuthSessionSnapshot> _parseSession(Map<String, dynamic> data) async {
    final cached = await sessionStore.read();
    return AuthSessionSnapshot.fromJson(
      data,
      preferredBusinessId: cached?.selectedBusinessId,
    );
  }

  Map<String, String> _deviceData() => {
    'platform': 'android',
    'device_model': defaultTargetPlatform.name,
  };
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final uuid = ref.watch(uuidProvider);

  return AuthRepository(
    client: ref.watch(apiClientProvider).dio,
    secureStorage: ref.watch(secureStorageProvider),
    sessionStore: ref.watch(authSessionStoreProvider),
    createUuid: () => uuid.v4(),
  );
});
