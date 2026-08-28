import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  const SignedIn({this.user});

  final AuthUser? user;
}

class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final secureStorage = ref.read(secureStorageProvider);
    final token = await secureStorage.readAccessToken();
    if (token?.isNotEmpty != true) return const SignedOut();

    try {
      final user = await ref.read(authRepositoryProvider).currentUser();
      return SignedIn(user: user);
    } catch (_) {
      // Keep a valid local session usable while offline. A failed token refresh
      // clears both tokens, in which case the user must sign in again.
      final retainedToken = await secureStorage.readAccessToken();
      return retainedToken?.isNotEmpty == true
          ? const SignedIn()
          : const SignedOut();
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
      state = AsyncData(SignedIn(user: result.user));
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
      state = AsyncData(SignedIn(user: result.user));
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(SignedOut());
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
