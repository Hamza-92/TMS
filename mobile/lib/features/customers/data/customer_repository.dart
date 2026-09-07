import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/core/database/app_database.dart';
import 'package:tailor_app/core/database/database_provider.dart';
import 'package:tailor_app/core/network/api_client.dart';
import 'package:tailor_app/core/network/api_endpoints.dart';
import 'package:tailor_app/core/network/network_exception.dart';
import 'package:tailor_app/core/utils/uuid_provider.dart';
import 'package:tailor_app/features/customers/domain/customer.dart';

class CustomerSyncReport {
  const CustomerSyncReport({
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

class CustomerRepository {
  CustomerRepository(this._database, this._client, this._createUuid);

  final AppDatabase _database;
  final Dio _client;
  final String Function() _createUuid;
  bool _syncing = false;

  Stream<List<CustomerRecord>> watchAll(String businessId) {
    final query = _database.select(_database.localCustomers)
      ..where((customer) => customer.businessId.equals(businessId))
      ..orderBy([
        (customer) => OrderingTerm.asc(customer.status),
        (customer) => OrderingTerm.asc(customer.name),
      ]);

    return query.watch().map(
      (rows) => rows.map(CustomerRecord.fromLocal).toList(growable: false),
    );
  }

  Stream<CustomerRecord?> watchOne(String businessId, String clientUuid) {
    final query = _database.select(_database.localCustomers)
      ..where(
        (customer) =>
            customer.businessId.equals(businessId) &
            customer.clientUuid.equals(clientUuid),
      );

    return query.watchSingleOrNull().map(
      (row) => row == null ? null : CustomerRecord.fromLocal(row),
    );
  }

  Future<CustomerRecord> save({
    required String businessId,
    required CustomerDraft draft,
    CustomerRecord? existing,
  }) async {
    final now = DateTime.now();
    final clientUuid = existing?.clientUuid ?? _createUuid();
    final operationUuid = _createUuid();
    final payload = draft.toJson();
    if (draft.photoChanged) {
      payload['_photo_action'] = draft.photoLocalPath == null
          ? 'remove'
          : 'upload';
      payload['_photo_local_path'] = draft.photoLocalPath;
    }

    await _database.transaction(() async {
      await (_database.delete(_database.customerSyncOperations)..where(
            (operation) =>
                operation.businessId.equals(businessId) &
                operation.customerClientUuid.equals(clientUuid) &
                operation.action.equals('upsert'),
          ))
          .go();

      await _database
          .into(_database.customerSyncOperations)
          .insert(
            CustomerSyncOperationsCompanion.insert(
              operationUuid: operationUuid,
              businessId: businessId,
              customerClientUuid: clientUuid,
              action: 'upsert',
              baseVersion: existing?.serverVersion ?? 0,
              payloadJson: jsonEncode(payload),
              createdAt: now,
            ),
          );

      await _database
          .into(_database.localCustomers)
          .insertOnConflictUpdate(
            LocalCustomersCompanion.insert(
              businessId: businessId,
              clientUuid: clientUuid,
              serverId: Value(existing?.serverId),
              name: draft.name,
              phoneE164: Value(draft.phoneE164),
              alternatePhoneE164: Value(draft.alternatePhoneE164),
              address: Value(draft.address),
              notes: Value(draft.notes),
              photoLocalPath: Value(draft.photoLocalPath),
              photoUrl: Value(
                draft.photoChanged && draft.photoLocalPath == null
                    ? null
                    : existing?.photoUrl,
              ),
              status: Value(existing?.status ?? 'active'),
              serverVersion: Value(existing?.serverVersion ?? 0),
              syncState: const Value('pending'),
              syncError: const Value(null),
              createdAt: existing?.createdAt ?? now,
              updatedAt: now,
              serverUpdatedAt: Value(existing?.serverUpdatedAt),
              archivedAt: Value(existing?.archivedAt),
            ),
          );
    });

    return (await _localCustomer(businessId, clientUuid))!;
  }

  Future<void> archive(CustomerRecord customer) async {
    if (customer.serverVersion == 0) {
      await _database.transaction(() async {
        await _deleteOperations(customer.businessId, customer.clientUuid);
        await _deleteLocal(customer.businessId, customer.clientUuid);
      });
      return;
    }

    await _queueStateChange(customer, 'archive', 'archived');
  }

  Future<void> restore(CustomerRecord customer) =>
      _queueStateChange(customer, 'restore', 'active');

  Future<CustomerSyncReport> synchronize(String businessId) async {
    if (_syncing) {
      return CustomerSyncReport(
        pushed: 0,
        pulled: 0,
        pending: await pendingCount(businessId),
        online: true,
      );
    }

    _syncing = true;
    var pushed = 0;
    var pulled = 0;
    var online = true;

    try {
      final firstPull = await _pull(businessId);
      pulled += firstPull.count;
      online = firstPull.online;
      if (!online) {
        return CustomerSyncReport(
          pushed: 0,
          pulled: pulled,
          pending: await pendingCount(businessId),
          online: false,
        );
      }

      final operations =
          await (_database.select(_database.customerSyncOperations)
                ..where((operation) => operation.businessId.equals(businessId))
                ..orderBy([
                  (operation) => OrderingTerm.asc(operation.createdAt),
                ]))
              .get();

      for (final operation in operations) {
        final customer = await _localCustomer(
          businessId,
          operation.customerClientUuid,
        );
        if (customer == null || customer.hasConflict) continue;

        try {
          final remote = await _pushOperation(operation);
          await _applyPushResult(operation, remote);
          pushed++;
        } on DioException catch (error) {
          final networkError = NetworkException.fromDio(error);
          await _recordSyncFailure(operation, error, networkError);
          online = error.response != null;
          break;
        }
      }

      if (online) {
        final finalPull = await _pull(businessId);
        pulled += finalPull.count;
        online = finalPull.online;
      }

      return CustomerSyncReport(
        pushed: pushed,
        pulled: pulled,
        pending: await pendingCount(businessId),
        online: online,
      );
    } finally {
      _syncing = false;
    }
  }

  Future<int> pendingCount(String businessId) async {
    final count = _database.customerSyncOperations.operationUuid.count();
    final query = _database.selectOnly(_database.customerSyncOperations)
      ..addColumns([count])
      ..where(_database.customerSyncOperations.businessId.equals(businessId));
    return (await query.map((row) => row.read(count) ?? 0).getSingle());
  }

  Future<void> _queueStateChange(
    CustomerRecord customer,
    String action,
    String status,
  ) async {
    final now = DateTime.now();
    await _database.transaction(() async {
      await _database
          .into(_database.customerSyncOperations)
          .insert(
            CustomerSyncOperationsCompanion.insert(
              operationUuid: _createUuid(),
              businessId: customer.businessId,
              customerClientUuid: customer.clientUuid,
              action: action,
              baseVersion: customer.serverVersion,
              payloadJson: '{}',
              createdAt: now,
            ),
          );
      await (_database.update(_database.localCustomers)..where(
            (row) =>
                row.businessId.equals(customer.businessId) &
                row.clientUuid.equals(customer.clientUuid),
          ))
          .write(
            LocalCustomersCompanion(
              status: Value(status),
              syncState: const Value('pending'),
              syncError: const Value(null),
              archivedAt: Value(status == 'archived' ? now : null),
              updatedAt: Value(now),
            ),
          );
    });
  }

  Future<CustomerRecord> _pushOperation(CustomerSyncOperation operation) async {
    final endpoint = ApiEndpoints.customer(
      operation.businessId,
      operation.customerClientUuid,
    );
    late Response<Map<String, dynamic>> response;

    if (operation.action == 'upsert') {
      final payload = Map<String, dynamic>.from(
        jsonDecode(operation.payloadJson) as Map,
      );
      final photoAction = payload.remove('_photo_action') as String?;
      final photoLocalPath = payload.remove('_photo_local_path') as String?;
      response = await _client.put<Map<String, dynamic>>(
        endpoint,
        data: {
          ...payload,
          'operation_uuid': operation.operationUuid,
          'base_version': operation.baseVersion,
        },
      );

      if (photoAction == 'upload' &&
          photoLocalPath != null &&
          await File(photoLocalPath).exists()) {
        response = await _client.post<Map<String, dynamic>>(
          ApiEndpoints.customerPhoto(
            operation.businessId,
            operation.customerClientUuid,
          ),
          data: FormData.fromMap({
            'photo': await MultipartFile.fromFile(photoLocalPath),
          }),
        );
      } else if (photoAction == 'remove') {
        response = await _client.delete<Map<String, dynamic>>(
          ApiEndpoints.customerPhoto(
            operation.businessId,
            operation.customerClientUuid,
          ),
        );
      }
    } else {
      final data = {
        'operation_uuid': operation.operationUuid,
        'base_version': operation.baseVersion,
      };
      response = operation.action == 'archive'
          ? await _client.delete<Map<String, dynamic>>(endpoint, data: data)
          : await _client.post<Map<String, dynamic>>(
              ApiEndpoints.restoreCustomer(
                operation.businessId,
                operation.customerClientUuid,
              ),
              data: data,
            );
    }

    return CustomerRecord.fromRemote(
      Map<String, dynamic>.from(response.data!['data'] as Map),
    );
  }

  Future<void> _applyPushResult(
    CustomerSyncOperation operation,
    CustomerRecord remote,
  ) async {
    await _database.transaction(() async {
      await (_database.delete(_database.customerSyncOperations)
            ..where((row) => row.operationUuid.equals(operation.operationUuid)))
          .go();

      final remaining =
          await (_database.select(_database.customerSyncOperations)..where(
                (row) =>
                    row.businessId.equals(operation.businessId) &
                    row.customerClientUuid.equals(operation.customerClientUuid),
              ))
              .get();

      if (remaining.isEmpty) {
        await _writeRemote(remote);
        return;
      }

      await (_database.update(_database.localCustomers)..where(
            (row) =>
                row.businessId.equals(operation.businessId) &
                row.clientUuid.equals(operation.customerClientUuid),
          ))
          .write(
            LocalCustomersCompanion(
              serverId: Value(remote.serverId),
              serverVersion: Value(remote.serverVersion),
              serverUpdatedAt: Value(remote.serverUpdatedAt),
              syncState: const Value('pending'),
              syncError: const Value(null),
            ),
          );

      await (_database.update(_database.customerSyncOperations)..where(
            (row) =>
                row.businessId.equals(operation.businessId) &
                row.customerClientUuid.equals(operation.customerClientUuid),
          ))
          .write(
            CustomerSyncOperationsCompanion(
              baseVersion: Value(remote.serverVersion),
            ),
          );
    });
  }

  Future<void> _recordSyncFailure(
    CustomerSyncOperation operation,
    DioException dioError,
    NetworkException error,
  ) async {
    final requiresReview = dioError.response != null;
    final body = error.statusCode == 409
        ? (error.code == 'customer_version_conflict'
              ? 'This customer changed on another device. Review and save it again.'
              : error.message)
        : error.message;
    final responseBody = dioError.response?.data;
    final responseJson = responseBody is Map
        ? Map<String, dynamic>.from(responseBody)
        : null;
    final responseData = responseJson?['data'];
    final dataJson = responseData is Map
        ? Map<String, dynamic>.from(responseData)
        : null;
    final remoteJson = dataJson?['customer'];
    final remote = remoteJson is Map
        ? CustomerRecord.fromRemote(Map<String, dynamic>.from(remoteJson))
        : null;

    await _database.transaction(() async {
      await (_database.update(_database.customerSyncOperations)
            ..where((row) => row.operationUuid.equals(operation.operationUuid)))
          .write(
            CustomerSyncOperationsCompanion(
              attemptCount: Value(operation.attemptCount + 1),
              lastError: Value(body),
            ),
          );
      await (_database.update(_database.localCustomers)..where(
            (row) =>
                row.businessId.equals(operation.businessId) &
                row.clientUuid.equals(operation.customerClientUuid),
          ))
          .write(
            LocalCustomersCompanion(
              serverId: remote == null
                  ? const Value.absent()
                  : Value(remote.serverId),
              serverVersion: remote == null
                  ? const Value.absent()
                  : Value(remote.serverVersion),
              serverUpdatedAt: remote == null
                  ? const Value.absent()
                  : Value(remote.serverUpdatedAt),
              syncState: Value(requiresReview ? 'conflict' : 'pending'),
              syncError: Value(body),
            ),
          );
    });
  }

  Future<({int count, bool online})> _pull(String businessId) async {
    final syncKey = 'customers_last_sync_$businessId';
    final updatedSince = await _database.readMetadata(syncKey);
    var page = 1;
    var pulled = 0;
    String? syncedAt;

    try {
      while (true) {
        final response = await _client.get<Map<String, dynamic>>(
          ApiEndpoints.customers(businessId),
          queryParameters: {
            'status': 'all',
            'per_page': 100,
            'page': page,
            'updated_since': updatedSince,
          },
        );
        final body = response.data!;
        final rows = (body['data'] as List)
            .map(
              (item) => CustomerRecord.fromRemote(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(growable: false);
        final meta = Map<String, dynamic>.from(body['meta'] as Map);

        for (final remote in rows) {
          await _storeRemoteIfClean(remote);
        }

        pulled += rows.length;
        syncedAt = meta['synced_at'] as String? ?? syncedAt;
        final lastPage = meta['last_page'] as int? ?? page;
        if (page >= lastPage) break;
        page++;
      }

      if (syncedAt != null) {
        await _database.writeMetadata(syncKey, syncedAt);
      }
      return (count: pulled, online: true);
    } on DioException {
      return (count: pulled, online: false);
    }
  }

  Future<void> _storeRemoteIfClean(CustomerRecord remote) async {
    final local = await _localCustomer(remote.businessId, remote.clientUuid);
    if (local == null ||
        (local.syncState == CustomerSyncState.synced &&
            remote.serverVersion >= local.serverVersion)) {
      await _writeRemote(remote);
    }
  }

  Future<void> _writeRemote(CustomerRecord remote) => _database
      .into(_database.localCustomers)
      .insertOnConflictUpdate(
        LocalCustomersCompanion.insert(
          businessId: remote.businessId,
          clientUuid: remote.clientUuid,
          serverId: Value(remote.serverId),
          name: remote.name,
          phoneE164: Value(remote.phoneE164),
          alternatePhoneE164: Value(remote.alternatePhoneE164),
          address: Value(remote.address),
          notes: Value(remote.notes),
          photoUrl: Value(remote.photoUrl),
          status: Value(remote.status),
          serverVersion: Value(remote.serverVersion),
          syncState: const Value('synced'),
          syncError: const Value(null),
          createdAt: remote.createdAt,
          updatedAt: remote.updatedAt,
          serverUpdatedAt: Value(remote.serverUpdatedAt),
          archivedAt: Value(remote.archivedAt),
        ),
      );

  Future<CustomerRecord?> _localCustomer(
    String businessId,
    String clientUuid,
  ) async {
    final row =
        await (_database.select(_database.localCustomers)..where(
              (customer) =>
                  customer.businessId.equals(businessId) &
                  customer.clientUuid.equals(clientUuid),
            ))
            .getSingleOrNull();
    return row == null ? null : CustomerRecord.fromLocal(row);
  }

  Future<int> _deleteOperations(String businessId, String clientUuid) =>
      (_database.delete(_database.customerSyncOperations)..where(
            (operation) =>
                operation.businessId.equals(businessId) &
                operation.customerClientUuid.equals(clientUuid),
          ))
          .go();

  Future<int> _deleteLocal(String businessId, String clientUuid) =>
      (_database.delete(_database.localCustomers)..where(
            (customer) =>
                customer.businessId.equals(businessId) &
                customer.clientUuid.equals(clientUuid),
          ))
          .go();
}

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final uuid = ref.watch(uuidProvider);
  return CustomerRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(apiClientProvider).dio,
    uuid.v4,
  );
});
