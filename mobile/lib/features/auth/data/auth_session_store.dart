import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/core/database/app_database.dart';
import 'package:tailor_app/core/database/database_provider.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';

class AuthSessionStore {
  const AuthSessionStore(this._database);

  static const _snapshotKey = 'auth_session_snapshot';

  final AppDatabase _database;

  Future<AuthSessionSnapshot?> read() async {
    final value = await _database.readMetadata(_snapshotKey);
    if (value == null || value.isEmpty) return null;

    try {
      final json = jsonDecode(value);
      if (json is! Map) return null;
      return AuthSessionSnapshot.fromJson(Map<String, dynamic>.from(json));
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  Future<void> write(AuthSessionSnapshot snapshot) =>
      _database.writeMetadata(_snapshotKey, jsonEncode(snapshot.toJson()));

  Future<void> clear() => _database.deleteMetadata(_snapshotKey);
}

final authSessionStoreProvider = Provider<AuthSessionStore>(
  (ref) => AuthSessionStore(ref.watch(appDatabaseProvider)),
);
