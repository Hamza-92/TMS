import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  const SecureStorageService(this._storage);

  static const _accessTokenKey = 'api_access_token';

  final FlutterSecureStorage _storage;

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<void> writeAccessToken(String value) =>
      _storage.write(key: _accessTokenKey, value: value);

  Future<void> deleteAccessToken() => _storage.delete(key: _accessTokenKey);
}

final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => const SecureStorageService(FlutterSecureStorage()),
);
