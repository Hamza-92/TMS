import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class AppMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}

class LocalCustomers extends Table {
  TextColumn get businessId => text()();
  TextColumn get clientUuid => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get name => text().withLength(min: 2, max: 140)();
  TextColumn get phoneE164 => text().nullable()();
  TextColumn get alternatePhoneE164 => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get photoLocalPath => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  IntColumn get serverVersion => integer().withDefault(const Constant(0))();
  TextColumn get syncState => text().withDefault(const Constant('pending'))();
  TextColumn get syncError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {businessId, clientUuid};
}

class CustomerSyncOperations extends Table {
  TextColumn get operationUuid => text()();
  TextColumn get businessId => text()();
  TextColumn get customerClientUuid => text()();
  TextColumn get action => text()();
  IntColumn get baseVersion => integer()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {operationUuid};
}

@DriftDatabase(tables: [AppMetadata, LocalCustomers, CustomerSyncOperations])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'tailor_app'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(localCustomers);
        await migrator.createTable(customerSyncOperations);
      }
      if (from >= 2 && from < 3) {
        await migrator.addColumn(localCustomers, localCustomers.photoLocalPath);
        await migrator.addColumn(localCustomers, localCustomers.photoUrl);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> initialize() async {
    await customSelect('SELECT 1').getSingle();
  }

  Future<String?> readMetadata(String metadataKey) async {
    final row = await (select(
      appMetadata,
    )..where((entry) => entry.key.equals(metadataKey))).getSingleOrNull();
    return row?.value;
  }

  Future<void> writeMetadata(String metadataKey, String metadataValue) =>
      into(appMetadata).insertOnConflictUpdate(
        AppMetadataCompanion.insert(key: metadataKey, value: metadataValue),
      );

  Future<int> deleteMetadata(String metadataKey) => (delete(
    appMetadata,
  )..where((entry) => entry.key.equals(metadataKey))).go();
}
