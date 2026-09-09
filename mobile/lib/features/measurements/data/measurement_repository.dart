import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/core/database/app_database.dart';
import 'package:tailor_app/core/database/database_provider.dart';
import 'package:tailor_app/core/network/api_client.dart';
import 'package:tailor_app/core/network/api_endpoints.dart';
import 'package:tailor_app/core/network/network_exception.dart';
import 'package:tailor_app/core/utils/uuid_provider.dart';
import 'package:tailor_app/features/measurements/domain/measurement.dart';

class MeasurementSyncReport {
  const MeasurementSyncReport({
    required this.pushed,
    required this.pulled,
    required this.pending,
    required this.online,
  });

  final int pushed;
  final int pulled;
  final int pending;
  final bool online;
}

class MeasurementRepository {
  MeasurementRepository(this._database, this._client, this._createUuid);

  final AppDatabase _database;
  final Dio _client;
  final String Function() _createUuid;
  bool _syncing = false;

  Stream<List<MeasurementTemplateRecord>> watchTemplates(String businessId) {
    final query = _database.select(_database.localMeasurementTemplates)
      ..where(
        (row) =>
            row.businessScope.equals(businessId) & row.status.equals('active'),
      )
      ..orderBy([
        (row) => OrderingTerm.asc(row.category),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.watch().map(
      (rows) =>
          rows.map(MeasurementTemplateRecord.fromLocal).toList(growable: false),
    );
  }

  Stream<List<MeasurementProfileRecord>> watchProfiles(
    String businessId,
    String customerClientUuid,
  ) {
    final query = _database.select(_database.localMeasurementProfiles)
      ..where(
        (row) =>
            row.businessId.equals(businessId) &
            row.customerClientUuid.equals(customerClientUuid),
      )
      ..orderBy([
        (row) => OrderingTerm.asc(row.status),
        (row) => OrderingTerm.asc(row.name),
      ]);
    return query.watch().map(
      (rows) =>
          rows.map(MeasurementProfileRecord.fromLocal).toList(growable: false),
    );
  }

  Stream<MeasurementProfileRecord?> watchProfile(
    String businessId,
    String profileClientUuid,
  ) {
    final query = _database.select(_database.localMeasurementProfiles)
      ..where(
        (row) =>
            row.businessId.equals(businessId) &
            row.clientUuid.equals(profileClientUuid),
      );
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : MeasurementProfileRecord.fromLocal(row),
    );
  }

  Stream<List<MeasurementRevisionRecord>> watchRevisions(
    String businessId,
    String profileClientUuid,
  ) {
    final query = _database.select(_database.localMeasurementRevisions)
      ..where(
        (row) =>
            row.businessId.equals(businessId) &
            row.profileClientUuid.equals(profileClientUuid),
      )
      ..orderBy([(row) => OrderingTerm.desc(row.measuredAt)]);
    return query.watch().map(
      (rows) =>
          rows.map(MeasurementRevisionRecord.fromLocal).toList(growable: false),
    );
  }

  Future<MeasurementTemplateRecord?> template(
    String businessId,
    String clientUuid,
  ) async {
    final row =
        await (_database.select(_database.localMeasurementTemplates)..where(
              (row) =>
                  row.businessScope.equals(businessId) &
                  row.clientUuid.equals(clientUuid),
            ))
            .getSingleOrNull();
    return row == null ? null : MeasurementTemplateRecord.fromLocal(row);
  }

  Future<MeasurementProfileRecord> saveProfile({
    required String businessId,
    required String customerClientUuid,
    required MeasurementProfileDraft draft,
    MeasurementProfileRecord? existing,
  }) async {
    final now = DateTime.now();
    final clientUuid = existing?.clientUuid ?? _createUuid();

    await _database.transaction(() async {
      await (_database.delete(_database.measurementSyncOperations)..where(
            (row) =>
                row.businessId.equals(businessId) &
                row.profileClientUuid.equals(clientUuid) &
                row.action.equals('profile_upsert'),
          ))
          .go();
      await _database
          .into(_database.measurementSyncOperations)
          .insert(
            MeasurementSyncOperationsCompanion.insert(
              operationUuid: _createUuid(),
              businessId: businessId,
              customerClientUuid: customerClientUuid,
              profileClientUuid: clientUuid,
              action: 'profile_upsert',
              baseVersion: existing?.serverVersion ?? 0,
              payloadJson: jsonEncode(draft.toJson()),
              createdAt: now,
            ),
          );
      await _database
          .into(_database.localMeasurementProfiles)
          .insertOnConflictUpdate(
            LocalMeasurementProfilesCompanion.insert(
              businessId: businessId,
              customerClientUuid: customerClientUuid,
              clientUuid: clientUuid,
              serverId: Value(existing?.serverId),
              templateClientUuid: draft.templateClientUuid,
              templateDefinitionVersion: draft.templateDefinitionVersion,
              name: draft.name,
              preferredUnit: Value(draft.preferredUnit),
              notes: Value(draft.notes),
              status: Value(existing?.status ?? 'active'),
              serverVersion: Value(existing?.serverVersion ?? 0),
              latestRevisionNumber: Value(existing?.latestRevisionNumber ?? 0),
              syncState: const Value('pending'),
              syncError: const Value(null),
              createdAt: existing?.createdAt ?? now,
              updatedAt: now,
              serverUpdatedAt: Value(existing?.serverUpdatedAt),
              archivedAt: Value(existing?.archivedAt),
            ),
          );
    });

    return (await _localProfile(businessId, clientUuid))!;
  }

  Future<MeasurementRevisionRecord> addRevision({
    required MeasurementProfileRecord profile,
    required List<MeasurementValueDraft> values,
    required DateTime measuredAt,
    String? notes,
  }) async {
    final now = DateTime.now();
    final revisionUuid = _createUuid();
    final nextRevision = profile.latestRevisionNumber + 1;
    final payload = {
      'revision_client_uuid': revisionUuid,
      'measured_at': measuredAt.toUtc().toIso8601String(),
      'notes': notes,
      'values': values.map((value) => value.toJson()).toList(growable: false),
    };

    await _database.transaction(() async {
      await _database
          .into(_database.measurementSyncOperations)
          .insert(
            MeasurementSyncOperationsCompanion.insert(
              operationUuid: _createUuid(),
              businessId: profile.businessId,
              customerClientUuid: profile.customerClientUuid,
              profileClientUuid: profile.clientUuid,
              revisionClientUuid: Value(revisionUuid),
              action: 'revision_create',
              baseVersion: profile.serverVersion,
              payloadJson: jsonEncode(payload),
              createdAt: now,
            ),
          );
      await _database
          .into(_database.localMeasurementRevisions)
          .insert(
            LocalMeasurementRevisionsCompanion.insert(
              businessId: profile.businessId,
              profileClientUuid: profile.clientUuid,
              clientUuid: revisionUuid,
              revisionNumber: Value(nextRevision),
              templateDefinitionVersion: profile.templateDefinitionVersion,
              valuesJson: jsonEncode(payload['values']),
              notes: Value(notes),
              measuredAt: measuredAt,
              syncState: const Value('pending'),
              createdAt: now,
            ),
          );
      await (_database.update(_database.localMeasurementProfiles)..where(
            (row) =>
                row.businessId.equals(profile.businessId) &
                row.clientUuid.equals(profile.clientUuid),
          ))
          .write(
            LocalMeasurementProfilesCompanion(
              latestRevisionNumber: Value(nextRevision),
              syncState: const Value('pending'),
              syncError: const Value(null),
              updatedAt: Value(now),
            ),
          );
    });

    return (await _localRevision(profile.businessId, revisionUuid))!;
  }

  Future<MeasurementSyncReport> synchronizeCustomer(
    String businessId,
    String customerClientUuid,
  ) async {
    if (_syncing) {
      return MeasurementSyncReport(
        pushed: 0,
        pulled: 0,
        pending: await pendingCount(businessId, customerClientUuid),
        online: true,
      );
    }
    _syncing = true;
    var pushed = 0;
    var pulled = 0;
    var online = true;

    try {
      final templates = await _pullTemplates(businessId);
      pulled += templates.count;
      online = templates.online;
      if (!online) {
        return MeasurementSyncReport(
          pushed: 0,
          pulled: pulled,
          pending: await pendingCount(businessId, customerClientUuid),
          online: false,
        );
      }

      final firstProfiles = await _pullProfiles(businessId, customerClientUuid);
      pulled += firstProfiles.count;
      online = firstProfiles.online;
      if (!online) {
        return MeasurementSyncReport(
          pushed: 0,
          pulled: pulled,
          pending: await pendingCount(businessId, customerClientUuid),
          online: false,
        );
      }

      final operations =
          await (_database.select(_database.measurementSyncOperations)
                ..where(
                  (row) =>
                      row.businessId.equals(businessId) &
                      row.customerClientUuid.equals(customerClientUuid),
                )
                ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
              .get();

      for (final operation in operations) {
        final profile = await _localProfile(
          businessId,
          operation.profileClientUuid,
        );
        if (profile == null || profile.hasConflict) continue;
        try {
          await _pushOperation(operation);
          pushed++;
        } on DioException catch (error) {
          await _recordFailure(operation, error);
          online = error.response != null;
          break;
        }
      }

      if (online) {
        final finalProfiles = await _pullProfiles(
          businessId,
          customerClientUuid,
        );
        pulled += finalProfiles.count;
      }

      return MeasurementSyncReport(
        pushed: pushed,
        pulled: pulled,
        pending: await pendingCount(businessId, customerClientUuid),
        online: online,
      );
    } finally {
      _syncing = false;
    }
  }

  Future<bool> refreshHistory({
    required String businessId,
    required String customerClientUuid,
    required String profileClientUuid,
  }) async {
    try {
      var page = 1;
      while (true) {
        final response = await _client.get<Map<String, dynamic>>(
          ApiEndpoints.measurementRevisions(
            businessId,
            customerClientUuid,
            profileClientUuid,
          ),
          queryParameters: {'per_page': 100, 'page': page},
        );
        final body = response.data!;
        final records = (body['data'] as List)
            .map(
              (item) => MeasurementRevisionRecord.fromRemote(
                businessId,
                profileClientUuid,
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(growable: false);
        for (final record in records) {
          await _storeRemoteRevisionIfClean(record);
        }
        final meta = Map<String, dynamic>.from(body['meta'] as Map);
        if (page >= (meta['last_page'] as int? ?? page)) break;
        page++;
      }
      return true;
    } on DioException {
      return false;
    }
  }

  Future<int> pendingCount(String businessId, String customerClientUuid) async {
    final count = _database.measurementSyncOperations.operationUuid.count();
    final query = _database.selectOnly(_database.measurementSyncOperations)
      ..addColumns([count])
      ..where(
        _database.measurementSyncOperations.businessId.equals(businessId) &
            _database.measurementSyncOperations.customerClientUuid.equals(
              customerClientUuid,
            ),
      );
    return (await query.map((row) => row.read(count) ?? 0).getSingle());
  }

  Future<void> _pushOperation(MeasurementSyncOperation operation) async {
    final endpoint = ApiEndpoints.measurementProfile(
      operation.businessId,
      operation.customerClientUuid,
      operation.profileClientUuid,
    );
    final payload = Map<String, dynamic>.from(
      jsonDecode(operation.payloadJson) as Map,
    );

    if (operation.action == 'profile_upsert') {
      final response = await _client.put<Map<String, dynamic>>(
        endpoint,
        data: {
          ...payload,
          'operation_uuid': operation.operationUuid,
          'base_version': operation.baseVersion,
        },
      );
      final remote = MeasurementProfileRecord.fromRemote(
        Map<String, dynamic>.from(response.data!['data'] as Map),
      );
      await _applyProfileResult(operation, remote);
      return;
    }

    final response = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.measurementRevisions(
        operation.businessId,
        operation.customerClientUuid,
        operation.profileClientUuid,
      ),
      data: {
        ...payload,
        'operation_uuid': operation.operationUuid,
        'base_version': operation.baseVersion,
      },
    );
    final data = Map<String, dynamic>.from(response.data!['data'] as Map);
    final profile = MeasurementProfileRecord.fromRemote(
      Map<String, dynamic>.from(data['profile'] as Map),
    );
    final revision = MeasurementRevisionRecord.fromRemote(
      operation.businessId,
      operation.profileClientUuid,
      Map<String, dynamic>.from(data['revision'] as Map),
    );
    await _applyRevisionResult(operation, profile, revision);
  }

  Future<void> _applyProfileResult(
    MeasurementSyncOperation operation,
    MeasurementProfileRecord remote,
  ) async {
    await _database.transaction(() async {
      await _deleteOperation(operation.operationUuid);
      final remaining = await _remainingOperations(
        operation.businessId,
        operation.profileClientUuid,
      );
      if (remaining.isEmpty) {
        await _writeRemoteProfile(remote);
        return;
      }
      await _updateProfileServerState(remote, pending: true);
      await _rebaseOperations(
        operation.businessId,
        operation.profileClientUuid,
        remote.serverVersion,
      );
    });
  }

  Future<void> _applyRevisionResult(
    MeasurementSyncOperation operation,
    MeasurementProfileRecord remoteProfile,
    MeasurementRevisionRecord remoteRevision,
  ) async {
    await _database.transaction(() async {
      await _deleteOperation(operation.operationUuid);
      await _writeRemoteRevision(remoteRevision);
      final remaining = await _remainingOperations(
        operation.businessId,
        operation.profileClientUuid,
      );
      if (remaining.isEmpty) {
        await _writeRemoteProfile(remoteProfile);
      } else {
        await _updateProfileServerState(remoteProfile, pending: true);
        await _rebaseOperations(
          operation.businessId,
          operation.profileClientUuid,
          remoteProfile.serverVersion,
        );
      }
    });
  }

  Future<void> _recordFailure(
    MeasurementSyncOperation operation,
    DioException dioError,
  ) async {
    final error = NetworkException.fromDio(dioError);
    final conflict = dioError.response?.statusCode == 409;
    await _database.transaction(() async {
      await (_database.update(_database.measurementSyncOperations)
            ..where((row) => row.operationUuid.equals(operation.operationUuid)))
          .write(
            MeasurementSyncOperationsCompanion(
              attemptCount: Value(operation.attemptCount + 1),
              lastError: Value(error.message),
            ),
          );
      await (_database.update(_database.localMeasurementProfiles)..where(
            (row) =>
                row.businessId.equals(operation.businessId) &
                row.clientUuid.equals(operation.profileClientUuid),
          ))
          .write(
            LocalMeasurementProfilesCompanion(
              syncState: Value(conflict ? 'conflict' : 'pending'),
              syncError: Value(error.message),
            ),
          );
      if (operation.revisionClientUuid case final revisionUuid?) {
        await (_database.update(_database.localMeasurementRevisions)..where(
              (row) =>
                  row.businessId.equals(operation.businessId) &
                  row.clientUuid.equals(revisionUuid),
            ))
            .write(
              LocalMeasurementRevisionsCompanion(
                syncState: Value(conflict ? 'conflict' : 'pending'),
                syncError: Value(error.message),
              ),
            );
      }
    });
  }

  Future<({int count, bool online})> _pullTemplates(String businessId) async {
    try {
      var page = 1;
      var count = 0;
      while (true) {
        final response = await _client.get<Map<String, dynamic>>(
          ApiEndpoints.measurementTemplates(businessId),
          queryParameters: {'status': 'all', 'per_page': 100, 'page': page},
        );
        final body = response.data!;
        final records = (body['data'] as List)
            .map(
              (item) => MeasurementTemplateRecord.fromRemote(
                businessId,
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(growable: false);
        for (final record in records) {
          await _writeRemoteTemplate(record);
        }
        count += records.length;
        final meta = Map<String, dynamic>.from(body['meta'] as Map);
        if (page >= (meta['last_page'] as int? ?? page)) break;
        page++;
      }
      return (count: count, online: true);
    } on DioException {
      return (count: 0, online: false);
    }
  }

  Future<({int count, bool online})> _pullProfiles(
    String businessId,
    String customerClientUuid,
  ) async {
    try {
      var page = 1;
      var count = 0;
      while (true) {
        final response = await _client.get<Map<String, dynamic>>(
          ApiEndpoints.measurementProfiles(businessId, customerClientUuid),
          queryParameters: {'status': 'all', 'per_page': 100, 'page': page},
        );
        final body = response.data!;
        final rawRows = body['data'] as List;
        for (final raw in rawRows) {
          final json = Map<String, dynamic>.from(raw as Map);
          final remote = MeasurementProfileRecord.fromRemote(json);
          await _storeRemoteProfileIfClean(remote);
          final latest = json['latest_revision'];
          if (latest is Map) {
            await _storeRemoteRevisionIfClean(
              MeasurementRevisionRecord.fromRemote(
                businessId,
                remote.clientUuid,
                Map<String, dynamic>.from(latest),
              ),
            );
          }
        }
        count += rawRows.length;
        final meta = Map<String, dynamic>.from(body['meta'] as Map);
        if (page >= (meta['last_page'] as int? ?? page)) break;
        page++;
      }
      return (count: count, online: true);
    } on DioException {
      return (count: 0, online: false);
    }
  }

  Future<void> _storeRemoteProfileIfClean(
    MeasurementProfileRecord remote,
  ) async {
    final local = await _localProfile(remote.businessId, remote.clientUuid);
    if (local == null ||
        (local.syncState == MeasurementSyncState.synced &&
            remote.serverVersion >= local.serverVersion)) {
      await _writeRemoteProfile(remote);
    }
  }

  Future<void> _storeRemoteRevisionIfClean(
    MeasurementRevisionRecord remote,
  ) async {
    final local = await _localRevision(remote.businessId, remote.clientUuid);
    if (local == null || local.syncState == MeasurementSyncState.synced) {
      await _writeRemoteRevision(remote);
    }
  }

  Future<void> _writeRemoteTemplate(MeasurementTemplateRecord remote) =>
      _database
          .into(_database.localMeasurementTemplates)
          .insertOnConflictUpdate(
            LocalMeasurementTemplatesCompanion.insert(
              businessScope: remote.businessScope,
              clientUuid: remote.clientUuid,
              serverId: Value(remote.serverId),
              systemCode: Value(remote.systemCode),
              source: remote.source,
              sourceTemplateUuid: Value(remote.sourceTemplateUuid),
              name: remote.name,
              nameUr: Value(remote.nameUr),
              nameRomanUr: Value(remote.nameRomanUr),
              category: remote.category,
              defaultUnit: Value(remote.defaultUnit),
              description: Value(remote.description),
              status: Value(remote.status),
              serverVersion: Value(remote.serverVersion),
              definitionVersion: Value(remote.definitionVersion),
              fieldsJson: jsonEncode(
                remote.fields.map((field) => field.toJson()).toList(),
              ),
              createdAt: remote.createdAt,
              updatedAt: remote.updatedAt,
              archivedAt: Value(remote.archivedAt),
            ),
          );

  Future<void> _writeRemoteProfile(MeasurementProfileRecord remote) => _database
      .into(_database.localMeasurementProfiles)
      .insertOnConflictUpdate(
        LocalMeasurementProfilesCompanion.insert(
          businessId: remote.businessId,
          customerClientUuid: remote.customerClientUuid,
          clientUuid: remote.clientUuid,
          serverId: Value(remote.serverId),
          templateClientUuid: remote.templateClientUuid,
          templateDefinitionVersion: remote.templateDefinitionVersion,
          name: remote.name,
          preferredUnit: Value(remote.preferredUnit),
          notes: Value(remote.notes),
          status: Value(remote.status),
          serverVersion: Value(remote.serverVersion),
          latestRevisionNumber: Value(remote.latestRevisionNumber),
          syncState: const Value('synced'),
          syncError: const Value(null),
          createdAt: remote.createdAt,
          updatedAt: remote.updatedAt,
          serverUpdatedAt: Value(remote.serverUpdatedAt),
          archivedAt: Value(remote.archivedAt),
        ),
      );

  Future<void> _writeRemoteRevision(MeasurementRevisionRecord remote) =>
      _database
          .into(_database.localMeasurementRevisions)
          .insertOnConflictUpdate(
            LocalMeasurementRevisionsCompanion.insert(
              businessId: remote.businessId,
              profileClientUuid: remote.profileClientUuid,
              clientUuid: remote.clientUuid,
              serverId: Value(remote.serverId),
              revisionNumber: Value(remote.revisionNumber),
              templateDefinitionVersion: remote.templateDefinitionVersion,
              valuesJson: jsonEncode(remote.values),
              notes: Value(remote.notes),
              measuredAt: remote.measuredAt,
              syncState: const Value('synced'),
              syncError: const Value(null),
              createdAt: remote.createdAt,
            ),
          );

  Future<void> _updateProfileServerState(
    MeasurementProfileRecord remote, {
    required bool pending,
  }) =>
      (_database.update(_database.localMeasurementProfiles)..where(
            (row) =>
                row.businessId.equals(remote.businessId) &
                row.clientUuid.equals(remote.clientUuid),
          ))
          .write(
            LocalMeasurementProfilesCompanion(
              serverId: Value(remote.serverId),
              serverVersion: Value(remote.serverVersion),
              serverUpdatedAt: Value(remote.serverUpdatedAt),
              syncState: Value(pending ? 'pending' : 'synced'),
              syncError: const Value(null),
            ),
          );

  Future<MeasurementProfileRecord?> _localProfile(
    String businessId,
    String clientUuid,
  ) async {
    final row =
        await (_database.select(_database.localMeasurementProfiles)..where(
              (row) =>
                  row.businessId.equals(businessId) &
                  row.clientUuid.equals(clientUuid),
            ))
            .getSingleOrNull();
    return row == null ? null : MeasurementProfileRecord.fromLocal(row);
  }

  Future<MeasurementRevisionRecord?> _localRevision(
    String businessId,
    String clientUuid,
  ) async {
    final row =
        await (_database.select(_database.localMeasurementRevisions)..where(
              (row) =>
                  row.businessId.equals(businessId) &
                  row.clientUuid.equals(clientUuid),
            ))
            .getSingleOrNull();
    return row == null ? null : MeasurementRevisionRecord.fromLocal(row);
  }

  Future<List<MeasurementSyncOperation>> _remainingOperations(
    String businessId,
    String profileClientUuid,
  ) =>
      (_database.select(_database.measurementSyncOperations)..where(
            (row) =>
                row.businessId.equals(businessId) &
                row.profileClientUuid.equals(profileClientUuid),
          ))
          .get();

  Future<int> _deleteOperation(String operationUuid) => (_database.delete(
    _database.measurementSyncOperations,
  )..where((row) => row.operationUuid.equals(operationUuid))).go();

  Future<int> _rebaseOperations(
    String businessId,
    String profileClientUuid,
    int version,
  ) =>
      (_database.update(_database.measurementSyncOperations)..where(
            (row) =>
                row.businessId.equals(businessId) &
                row.profileClientUuid.equals(profileClientUuid),
          ))
          .write(
            MeasurementSyncOperationsCompanion(baseVersion: Value(version)),
          );
}

final measurementRepositoryProvider = Provider<MeasurementRepository>((ref) {
  final uuid = ref.watch(uuidProvider);
  return MeasurementRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(apiClientProvider).dio,
    uuid.v4,
  );
});
