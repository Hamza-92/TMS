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

class LocalMeasurementTemplates extends Table {
  TextColumn get businessScope => text()();
  TextColumn get clientUuid => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get systemCode => text().nullable()();
  TextColumn get source => text()();
  TextColumn get sourceTemplateUuid => text().nullable()();
  TextColumn get name => text()();
  TextColumn get nameUr => text().nullable()();
  TextColumn get nameRomanUr => text().nullable()();
  TextColumn get category => text()();
  TextColumn get defaultUnit => text().withDefault(const Constant('inch'))();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();
  IntColumn get serverVersion => integer().withDefault(const Constant(0))();
  IntColumn get definitionVersion => integer().withDefault(const Constant(1))();
  TextColumn get fieldsJson => text()();
  TextColumn get syncState => text().withDefault(const Constant('synced'))();
  TextColumn get syncError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {businessScope, clientUuid};
}

class LocalMeasurementProfiles extends Table {
  TextColumn get businessId => text()();
  TextColumn get customerClientUuid => text()();
  TextColumn get clientUuid => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get templateClientUuid => text()();
  IntColumn get templateDefinitionVersion => integer()();
  TextColumn get name => text()();
  TextColumn get preferredUnit => text().withDefault(const Constant('inch'))();
  TextColumn get notes => text().nullable()();
  TextColumn get customFieldsJson => text().withDefault(const Constant('[]'))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  IntColumn get serverVersion => integer().withDefault(const Constant(0))();
  IntColumn get latestRevisionNumber =>
      integer().withDefault(const Constant(0))();
  TextColumn get syncState => text().withDefault(const Constant('pending'))();
  TextColumn get syncError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {businessId, clientUuid};
}

class LocalMeasurementRevisions extends Table {
  TextColumn get businessId => text()();
  TextColumn get profileClientUuid => text()();
  TextColumn get clientUuid => text()();
  TextColumn get serverId => text().nullable()();
  IntColumn get revisionNumber => integer().withDefault(const Constant(0))();
  IntColumn get templateDefinitionVersion => integer()();
  TextColumn get valuesJson => text()();
  TextColumn get customFieldsJson => text().withDefault(const Constant('[]'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get measuredAt => dateTime()();
  TextColumn get syncState => text().withDefault(const Constant('pending'))();
  TextColumn get syncError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {businessId, clientUuid};
}

class MeasurementSyncOperations extends Table {
  TextColumn get operationUuid => text()();
  TextColumn get businessId => text()();
  TextColumn get customerClientUuid => text()();
  TextColumn get profileClientUuid => text()();
  TextColumn get revisionClientUuid => text().nullable()();
  TextColumn get action => text()();
  IntColumn get baseVersion => integer()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {operationUuid};
}

class MeasurementTemplateSyncOperations extends Table {
  TextColumn get operationUuid => text()();
  TextColumn get businessId => text()();
  TextColumn get templateClientUuid => text()();
  IntColumn get baseVersion => integer()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column> get primaryKey => {operationUuid};
}

@DriftDatabase(
  tables: [
    AppMetadata,
    LocalCustomers,
    CustomerSyncOperations,
    LocalMeasurementTemplates,
    LocalMeasurementProfiles,
    LocalMeasurementRevisions,
    MeasurementSyncOperations,
    MeasurementTemplateSyncOperations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'tailor_app'));

  @override
  int get schemaVersion => 5;

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
      if (from < 4) {
        await migrator.createTable(localMeasurementTemplates);
        await migrator.createTable(localMeasurementProfiles);
        await migrator.createTable(localMeasurementRevisions);
        await migrator.createTable(measurementSyncOperations);
        await migrator.createTable(measurementTemplateSyncOperations);
      } else if (from < 5) {
        await migrator.addColumn(
          localMeasurementTemplates,
          localMeasurementTemplates.syncState,
        );
        await migrator.addColumn(
          localMeasurementTemplates,
          localMeasurementTemplates.syncError,
        );
        await migrator.addColumn(
          localMeasurementProfiles,
          localMeasurementProfiles.customFieldsJson,
        );
        await migrator.addColumn(
          localMeasurementRevisions,
          localMeasurementRevisions.customFieldsJson,
        );
        await migrator.createTable(measurementTemplateSyncOperations);
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
