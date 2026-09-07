import 'package:tailor_app/core/database/app_database.dart';

enum CustomerSyncState {
  synced,
  pending,
  conflict;

  static CustomerSyncState fromStorage(String value) => values.firstWhere(
    (item) => item.name == value,
    orElse: () => CustomerSyncState.pending,
  );
}

class CustomerDraft {
  const CustomerDraft({
    required this.name,
    this.phoneE164,
    this.alternatePhoneE164,
    this.address,
    this.notes,
    this.photoLocalPath,
    this.photoChanged = false,
  });

  final String name;
  final String? phoneE164;
  final String? alternatePhoneE164;
  final String? address;
  final String? notes;
  final String? photoLocalPath;
  final bool photoChanged;

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone_e164': phoneE164,
    'alternate_phone_e164': alternatePhoneE164,
    'address': address,
    'notes': notes,
  };
}

class CustomerRecord {
  const CustomerRecord({
    required this.businessId,
    required this.clientUuid,
    required this.name,
    required this.status,
    required this.serverVersion,
    required this.syncState,
    required this.createdAt,
    required this.updatedAt,
    this.serverId,
    this.phoneE164,
    this.alternatePhoneE164,
    this.address,
    this.notes,
    this.photoLocalPath,
    this.photoUrl,
    this.syncError,
    this.serverUpdatedAt,
    this.archivedAt,
  });

  factory CustomerRecord.fromLocal(LocalCustomer row) => CustomerRecord(
    businessId: row.businessId,
    clientUuid: row.clientUuid,
    serverId: row.serverId,
    name: row.name,
    phoneE164: row.phoneE164,
    alternatePhoneE164: row.alternatePhoneE164,
    address: row.address,
    notes: row.notes,
    photoLocalPath: row.photoLocalPath,
    photoUrl: row.photoUrl,
    status: row.status,
    serverVersion: row.serverVersion,
    syncState: CustomerSyncState.fromStorage(row.syncState),
    syncError: row.syncError,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    serverUpdatedAt: row.serverUpdatedAt,
    archivedAt: row.archivedAt,
  );

  factory CustomerRecord.fromRemote(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['created_at'] as String);
    final updatedAt = DateTime.parse(json['updated_at'] as String);

    return CustomerRecord(
      businessId: json['business_id'] as String,
      clientUuid: json['client_uuid'] as String,
      serverId: json['id'] as String,
      name: json['name'] as String,
      phoneE164: json['phone_e164'] as String?,
      alternatePhoneE164: json['alternate_phone_e164'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      photoUrl: json['photo_url'] as String?,
      status: json['status'] as String,
      serverVersion: json['version'] as int,
      syncState: CustomerSyncState.synced,
      createdAt: createdAt,
      updatedAt: updatedAt,
      serverUpdatedAt: updatedAt,
      archivedAt: _optionalDate(json['archived_at']),
    );
  }

  final String businessId;
  final String clientUuid;
  final String? serverId;
  final String name;
  final String? phoneE164;
  final String? alternatePhoneE164;
  final String? address;
  final String? notes;
  final String? photoLocalPath;
  final String? photoUrl;
  final String status;
  final int serverVersion;
  final CustomerSyncState syncState;
  final String? syncError;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? serverUpdatedAt;
  final DateTime? archivedAt;

  bool get isArchived => status == 'archived';
  bool get hasPendingChanges => syncState == CustomerSyncState.pending;
  bool get hasConflict => syncState == CustomerSyncState.conflict;
}

DateTime? _optionalDate(Object? value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value);
}
