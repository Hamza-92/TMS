import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/core/localization/app_locale.dart';
import 'package:tailor_app/core/storage/secure_storage_service.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/data/auth_repository.dart';

sealed class AuthState {
  const AuthState();
}

class SignedOut extends AuthState {
  const SignedOut();
}

class SignedIn extends AuthState {
  const SignedIn({this.session});

  final AuthSessionSnapshot? session;

  AuthUser? get user => session?.user;
  AuthBusiness? get business => session?.selectedBusiness;
}

class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final secureStorage = ref.read(secureStorageProvider);
    final token = await secureStorage.readAccessToken();
    if (token?.isNotEmpty != true) return const SignedOut();

    try {
      final session = await ref.read(authRepositoryProvider).currentSession();
      await _adoptAccountLocale(session);
      return SignedIn(session: session);
    } catch (_) {
      // Keep a valid local session usable while offline. A failed token refresh
      // clears both tokens, in which case the user must sign in again.
      final retainedToken = await secureStorage.readAccessToken();
      if (retainedToken?.isNotEmpty != true) return const SignedOut();

      final cached = await ref.read(authRepositoryProvider).cachedSession();
      if (cached != null) await _adoptAccountLocale(cached);
      return SignedIn(session: cached);
    }
  }

  Future<void> login({
    required String phoneE164,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final result = await ref
          .read(authRepositoryProvider)
          .login(phoneE164: phoneE164, password: password);
      await _adoptAccountLocale(result.session);
      state = AsyncData(SignedIn(session: result.session));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> register({
    required RegistrationDraft draft,
    required String otp,
  }) async {
    state = const AsyncLoading();

    try {
      final result = await ref
          .read(authRepositoryProvider)
          .register(draft: draft, otp: otp);
      await _adoptAccountLocale(result.session);
      state = AsyncData(SignedIn(session: result.session));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(SignedOut());
  }

  Future<void> selectBusiness(String businessId) async {
    final current = state.valueOrNull;
    if (current is! SignedIn || current.session == null) return;

    final updated = await ref
        .read(authRepositoryProvider)
        .selectBusiness(current.session!, businessId);
    state = AsyncData(SignedIn(session: updated));
  }

  Future<void> refreshSession() async {
    final previous = state.valueOrNull;
    state = const AsyncLoading();

    try {
      final session = await ref.read(authRepositoryProvider).currentSession();
      await _adoptAccountLocale(session);
      state = AsyncData(SignedIn(session: session));
    } catch (error, stackTrace) {
      state = previous == null
          ? AsyncError(error, stackTrace)
          : AsyncData(previous);
      rethrow;
    }
  }

  Future<void> _adoptAccountLocale(AuthSessionSnapshot session) async {
    final locale = AppLocale.fromApiCode(session.user.preferredLocale);
    if (locale != null) await ref.read(localeProvider.notifier).select(locale);
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
