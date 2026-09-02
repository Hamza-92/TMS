import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  const SecureStorageService(this._storage);

  static const _accessTokenKey = 'api_access_token';
  static const _refreshTokenKey = 'api_refresh_token';
  static const _installationUuidKey = 'app_installation_uuid';

  final FlutterSecureStorage _storage;

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<void> writeAccessToken(String value) =>
      _storage.write(key: _accessTokenKey, value: value);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<void> writeRefreshToken(String value) =>
      _storage.write(key: _refreshTokenKey, value: value);

  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      writeAccessToken(accessToken),
      writeRefreshToken(refreshToken),
    ]);
  }

  Future<String?> readInstallationUuid() =>
      _storage.read(key: _installationUuidKey);

  Future<void> writeInstallationUuid(String value) =>
      _storage.write(key: _installationUuidKey, value: value);

  Future<void> deleteAccessToken() => _storage.delete(key: _accessTokenKey);

  Future<void> deleteAuthTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}

final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => const SecureStorageService(
    FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  ),
);
