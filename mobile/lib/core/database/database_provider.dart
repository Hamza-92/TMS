import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/core/database/app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw StateError('AppDatabase must be initialized before use.'),
);
