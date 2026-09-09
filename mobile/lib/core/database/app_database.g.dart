// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppMetadataTable extends AppMetadata
    with TableInfo<$AppMetadataTable, AppMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppMetadataTable createAlias(String alias) {
    return $AppMetadataTable(attachedDatabase, alias);
  }
}

class AppMetadataData extends DataClass implements Insertable<AppMetadataData> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppMetadataData({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppMetadataCompanion toCompanion(bool nullToAbsent) {
    return AppMetadataCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppMetadataData copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppMetadataData(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppMetadataData copyWithCompanion(AppMetadataCompanion data) {
    return AppMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppMetadataData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppMetadataCompanion extends UpdateCompanion<AppMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppMetadataCompanion.insert({
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCustomersTable extends LocalCustomers
    with TableInfo<$LocalCustomersTable, LocalCustomer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _businessIdMeta = const VerificationMeta(
    'businessId',
  );
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
    'business_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientUuidMeta = const VerificationMeta(
    'clientUuid',
  );
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
    'client_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 140,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneE164Meta = const VerificationMeta(
    'phoneE164',
  );
  @override
  late final GeneratedColumn<String> phoneE164 = GeneratedColumn<String>(
    'phone_e164',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alternatePhoneE164Meta =
      const VerificationMeta('alternatePhoneE164');
  @override
  late final GeneratedColumn<String> alternatePhoneE164 =
      GeneratedColumn<String>(
        'alternate_phone_e164',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoLocalPathMeta = const VerificationMeta(
    'photoLocalPath',
  );
  @override
  late final GeneratedColumn<String> photoLocalPath = GeneratedColumn<String>(
    'photo_local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _serverVersionMeta = const VerificationMeta(
    'serverVersion',
  );
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
    'server_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    businessId,
    clientUuid,
    serverId,
    name,
    phoneE164,
    alternatePhoneE164,
    address,
    notes,
    photoLocalPath,
    photoUrl,
    status,
    serverVersion,
    syncState,
    syncError,
    createdAt,
    updatedAt,
    serverUpdatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalCustomer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('business_id')) {
      context.handle(
        _businessIdMeta,
        businessId.isAcceptableOrUnknown(data['business_id']!, _businessIdMeta),
      );
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('client_uuid')) {
      context.handle(
        _clientUuidMeta,
        clientUuid.isAcceptableOrUnknown(data['client_uuid']!, _clientUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone_e164')) {
      context.handle(
        _phoneE164Meta,
        phoneE164.isAcceptableOrUnknown(data['phone_e164']!, _phoneE164Meta),
      );
    }
    if (data.containsKey('alternate_phone_e164')) {
      context.handle(
        _alternatePhoneE164Meta,
        alternatePhoneE164.isAcceptableOrUnknown(
          data['alternate_phone_e164']!,
          _alternatePhoneE164Meta,
        ),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('photo_local_path')) {
      context.handle(
        _photoLocalPathMeta,
        photoLocalPath.isAcceptableOrUnknown(
          data['photo_local_path']!,
          _photoLocalPathMeta,
        ),
      );
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('server_version')) {
      context.handle(
        _serverVersionMeta,
        serverVersion.isAcceptableOrUnknown(
          data['server_version']!,
          _serverVersionMeta,
        ),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {businessId, clientUuid};
  @override
  LocalCustomer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCustomer(
      businessId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_id'],
      )!,
      clientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_uuid'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phoneE164: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_e164'],
      ),
      alternatePhoneE164: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alternate_phone_e164'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      photoLocalPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_local_path'],
      ),
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      serverVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_version'],
      )!,
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $LocalCustomersTable createAlias(String alias) {
    return $LocalCustomersTable(attachedDatabase, alias);
  }
}

class LocalCustomer extends DataClass implements Insertable<LocalCustomer> {
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
  final String syncState;
  final String? syncError;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? serverUpdatedAt;
  final DateTime? archivedAt;
  const LocalCustomer({
    required this.businessId,
    required this.clientUuid,
    this.serverId,
    required this.name,
    this.phoneE164,
    this.alternatePhoneE164,
    this.address,
    this.notes,
    this.photoLocalPath,
    this.photoUrl,
    required this.status,
    required this.serverVersion,
    required this.syncState,
    this.syncError,
    required this.createdAt,
    required this.updatedAt,
    this.serverUpdatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['business_id'] = Variable<String>(businessId);
    map['client_uuid'] = Variable<String>(clientUuid);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phoneE164 != null) {
      map['phone_e164'] = Variable<String>(phoneE164);
    }
    if (!nullToAbsent || alternatePhoneE164 != null) {
      map['alternate_phone_e164'] = Variable<String>(alternatePhoneE164);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || photoLocalPath != null) {
      map['photo_local_path'] = Variable<String>(photoLocalPath);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['status'] = Variable<String>(status);
    map['server_version'] = Variable<int>(serverVersion);
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  LocalCustomersCompanion toCompanion(bool nullToAbsent) {
    return LocalCustomersCompanion(
      businessId: Value(businessId),
      clientUuid: Value(clientUuid),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      name: Value(name),
      phoneE164: phoneE164 == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneE164),
      alternatePhoneE164: alternatePhoneE164 == null && nullToAbsent
          ? const Value.absent()
          : Value(alternatePhoneE164),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      photoLocalPath: photoLocalPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoLocalPath),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      status: Value(status),
      serverVersion: Value(serverVersion),
      syncState: Value(syncState),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory LocalCustomer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCustomer(
      businessId: serializer.fromJson<String>(json['businessId']),
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      name: serializer.fromJson<String>(json['name']),
      phoneE164: serializer.fromJson<String?>(json['phoneE164']),
      alternatePhoneE164: serializer.fromJson<String?>(
        json['alternatePhoneE164'],
      ),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      photoLocalPath: serializer.fromJson<String?>(json['photoLocalPath']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      status: serializer.fromJson<String>(json['status']),
      serverVersion: serializer.fromJson<int>(json['serverVersion']),
      syncState: serializer.fromJson<String>(json['syncState']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'businessId': serializer.toJson<String>(businessId),
      'clientUuid': serializer.toJson<String>(clientUuid),
      'serverId': serializer.toJson<String?>(serverId),
      'name': serializer.toJson<String>(name),
      'phoneE164': serializer.toJson<String?>(phoneE164),
      'alternatePhoneE164': serializer.toJson<String?>(alternatePhoneE164),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'photoLocalPath': serializer.toJson<String?>(photoLocalPath),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'status': serializer.toJson<String>(status),
      'serverVersion': serializer.toJson<int>(serverVersion),
      'syncState': serializer.toJson<String>(syncState),
      'syncError': serializer.toJson<String?>(syncError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  LocalCustomer copyWith({
    String? businessId,
    String? clientUuid,
    Value<String?> serverId = const Value.absent(),
    String? name,
    Value<String?> phoneE164 = const Value.absent(),
    Value<String?> alternatePhoneE164 = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> photoLocalPath = const Value.absent(),
    Value<String?> photoUrl = const Value.absent(),
    String? status,
    int? serverVersion,
    String? syncState,
    Value<String?> syncError = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => LocalCustomer(
    businessId: businessId ?? this.businessId,
    clientUuid: clientUuid ?? this.clientUuid,
    serverId: serverId.present ? serverId.value : this.serverId,
    name: name ?? this.name,
    phoneE164: phoneE164.present ? phoneE164.value : this.phoneE164,
    alternatePhoneE164: alternatePhoneE164.present
        ? alternatePhoneE164.value
        : this.alternatePhoneE164,
    address: address.present ? address.value : this.address,
    notes: notes.present ? notes.value : this.notes,
    photoLocalPath: photoLocalPath.present
        ? photoLocalPath.value
        : this.photoLocalPath,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    status: status ?? this.status,
    serverVersion: serverVersion ?? this.serverVersion,
    syncState: syncState ?? this.syncState,
    syncError: syncError.present ? syncError.value : this.syncError,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  LocalCustomer copyWithCompanion(LocalCustomersCompanion data) {
    return LocalCustomer(
      businessId: data.businessId.present
          ? data.businessId.value
          : this.businessId,
      clientUuid: data.clientUuid.present
          ? data.clientUuid.value
          : this.clientUuid,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      name: data.name.present ? data.name.value : this.name,
      phoneE164: data.phoneE164.present ? data.phoneE164.value : this.phoneE164,
      alternatePhoneE164: data.alternatePhoneE164.present
          ? data.alternatePhoneE164.value
          : this.alternatePhoneE164,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      photoLocalPath: data.photoLocalPath.present
          ? data.photoLocalPath.value
          : this.photoLocalPath,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      status: data.status.present ? data.status.value : this.status,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCustomer(')
          ..write('businessId: $businessId, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('phoneE164: $phoneE164, ')
          ..write('alternatePhoneE164: $alternatePhoneE164, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('photoLocalPath: $photoLocalPath, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('status: $status, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('syncState: $syncState, ')
          ..write('syncError: $syncError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    businessId,
    clientUuid,
    serverId,
    name,
    phoneE164,
    alternatePhoneE164,
    address,
    notes,
    photoLocalPath,
    photoUrl,
    status,
    serverVersion,
    syncState,
    syncError,
    createdAt,
    updatedAt,
    serverUpdatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCustomer &&
          other.businessId == this.businessId &&
          other.clientUuid == this.clientUuid &&
          other.serverId == this.serverId &&
          other.name == this.name &&
          other.phoneE164 == this.phoneE164 &&
          other.alternatePhoneE164 == this.alternatePhoneE164 &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.photoLocalPath == this.photoLocalPath &&
          other.photoUrl == this.photoUrl &&
          other.status == this.status &&
          other.serverVersion == this.serverVersion &&
          other.syncState == this.syncState &&
          other.syncError == this.syncError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.archivedAt == this.archivedAt);
}

class LocalCustomersCompanion extends UpdateCompanion<LocalCustomer> {
  final Value<String> businessId;
  final Value<String> clientUuid;
  final Value<String?> serverId;
  final Value<String> name;
  final Value<String?> phoneE164;
  final Value<String?> alternatePhoneE164;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<String?> photoLocalPath;
  final Value<String?> photoUrl;
  final Value<String> status;
  final Value<int> serverVersion;
  final Value<String> syncState;
  final Value<String?> syncError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const LocalCustomersCompanion({
    this.businessId = const Value.absent(),
    this.clientUuid = const Value.absent(),
    this.serverId = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneE164 = const Value.absent(),
    this.alternatePhoneE164 = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoLocalPath = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.syncState = const Value.absent(),
    this.syncError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCustomersCompanion.insert({
    required String businessId,
    required String clientUuid,
    this.serverId = const Value.absent(),
    required String name,
    this.phoneE164 = const Value.absent(),
    this.alternatePhoneE164 = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.photoLocalPath = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.syncState = const Value.absent(),
    this.syncError = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverUpdatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : businessId = Value(businessId),
       clientUuid = Value(clientUuid),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalCustomer> custom({
    Expression<String>? businessId,
    Expression<String>? clientUuid,
    Expression<String>? serverId,
    Expression<String>? name,
    Expression<String>? phoneE164,
    Expression<String>? alternatePhoneE164,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<String>? photoLocalPath,
    Expression<String>? photoUrl,
    Expression<String>? status,
    Expression<int>? serverVersion,
    Expression<String>? syncState,
    Expression<String>? syncError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (businessId != null) 'business_id': businessId,
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (serverId != null) 'server_id': serverId,
      if (name != null) 'name': name,
      if (phoneE164 != null) 'phone_e164': phoneE164,
      if (alternatePhoneE164 != null)
        'alternate_phone_e164': alternatePhoneE164,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (photoLocalPath != null) 'photo_local_path': photoLocalPath,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (status != null) 'status': status,
      if (serverVersion != null) 'server_version': serverVersion,
      if (syncState != null) 'sync_state': syncState,
      if (syncError != null) 'sync_error': syncError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCustomersCompanion copyWith({
    Value<String>? businessId,
    Value<String>? clientUuid,
    Value<String?>? serverId,
    Value<String>? name,
    Value<String?>? phoneE164,
    Value<String?>? alternatePhoneE164,
    Value<String?>? address,
    Value<String?>? notes,
    Value<String?>? photoLocalPath,
    Value<String?>? photoUrl,
    Value<String>? status,
    Value<int>? serverVersion,
    Value<String>? syncState,
    Value<String?>? syncError,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? serverUpdatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return LocalCustomersCompanion(
      businessId: businessId ?? this.businessId,
      clientUuid: clientUuid ?? this.clientUuid,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      phoneE164: phoneE164 ?? this.phoneE164,
      alternatePhoneE164: alternatePhoneE164 ?? this.alternatePhoneE164,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      photoLocalPath: photoLocalPath ?? this.photoLocalPath,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      serverVersion: serverVersion ?? this.serverVersion,
      syncState: syncState ?? this.syncState,
      syncError: syncError ?? this.syncError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phoneE164.present) {
      map['phone_e164'] = Variable<String>(phoneE164.value);
    }
    if (alternatePhoneE164.present) {
      map['alternate_phone_e164'] = Variable<String>(alternatePhoneE164.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (photoLocalPath.present) {
      map['photo_local_path'] = Variable<String>(photoLocalPath.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCustomersCompanion(')
          ..write('businessId: $businessId, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('phoneE164: $phoneE164, ')
          ..write('alternatePhoneE164: $alternatePhoneE164, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('photoLocalPath: $photoLocalPath, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('status: $status, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('syncState: $syncState, ')
          ..write('syncError: $syncError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomerSyncOperationsTable extends CustomerSyncOperations
    with TableInfo<$CustomerSyncOperationsTable, CustomerSyncOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomerSyncOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationUuidMeta = const VerificationMeta(
    'operationUuid',
  );
  @override
  late final GeneratedColumn<String> operationUuid = GeneratedColumn<String>(
    'operation_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessIdMeta = const VerificationMeta(
    'businessId',
  );
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
    'business_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerClientUuidMeta =
      const VerificationMeta('customerClientUuid');
  @override
  late final GeneratedColumn<String> customerClientUuid =
      GeneratedColumn<String>(
        'customer_client_uuid',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseVersionMeta = const VerificationMeta(
    'baseVersion',
  );
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
    'base_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationUuid,
    businessId,
    customerClientUuid,
    action,
    baseVersion,
    payloadJson,
    createdAt,
    attemptCount,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customer_sync_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerSyncOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_uuid')) {
      context.handle(
        _operationUuidMeta,
        operationUuid.isAcceptableOrUnknown(
          data['operation_uuid']!,
          _operationUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationUuidMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
        _businessIdMeta,
        businessId.isAcceptableOrUnknown(data['business_id']!, _businessIdMeta),
      );
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('customer_client_uuid')) {
      context.handle(
        _customerClientUuidMeta,
        customerClientUuid.isAcceptableOrUnknown(
          data['customer_client_uuid']!,
          _customerClientUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerClientUuidMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('base_version')) {
      context.handle(
        _baseVersionMeta,
        baseVersion.isAcceptableOrUnknown(
          data['base_version']!,
          _baseVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baseVersionMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationUuid};
  @override
  CustomerSyncOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerSyncOperation(
      operationUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_uuid'],
      )!,
      businessId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_id'],
      )!,
      customerClientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_client_uuid'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      baseVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_version'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $CustomerSyncOperationsTable createAlias(String alias) {
    return $CustomerSyncOperationsTable(attachedDatabase, alias);
  }
}

class CustomerSyncOperation extends DataClass
    implements Insertable<CustomerSyncOperation> {
  final String operationUuid;
  final String businessId;
  final String customerClientUuid;
  final String action;
  final int baseVersion;
  final String payloadJson;
  final DateTime createdAt;
  final int attemptCount;
  final String? lastError;
  const CustomerSyncOperation({
    required this.operationUuid,
    required this.businessId,
    required this.customerClientUuid,
    required this.action,
    required this.baseVersion,
    required this.payloadJson,
    required this.createdAt,
    required this.attemptCount,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_uuid'] = Variable<String>(operationUuid);
    map['business_id'] = Variable<String>(businessId);
    map['customer_client_uuid'] = Variable<String>(customerClientUuid);
    map['action'] = Variable<String>(action);
    map['base_version'] = Variable<int>(baseVersion);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  CustomerSyncOperationsCompanion toCompanion(bool nullToAbsent) {
    return CustomerSyncOperationsCompanion(
      operationUuid: Value(operationUuid),
      businessId: Value(businessId),
      customerClientUuid: Value(customerClientUuid),
      action: Value(action),
      baseVersion: Value(baseVersion),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      attemptCount: Value(attemptCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory CustomerSyncOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerSyncOperation(
      operationUuid: serializer.fromJson<String>(json['operationUuid']),
      businessId: serializer.fromJson<String>(json['businessId']),
      customerClientUuid: serializer.fromJson<String>(
        json['customerClientUuid'],
      ),
      action: serializer.fromJson<String>(json['action']),
      baseVersion: serializer.fromJson<int>(json['baseVersion']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationUuid': serializer.toJson<String>(operationUuid),
      'businessId': serializer.toJson<String>(businessId),
      'customerClientUuid': serializer.toJson<String>(customerClientUuid),
      'action': serializer.toJson<String>(action),
      'baseVersion': serializer.toJson<int>(baseVersion),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  CustomerSyncOperation copyWith({
    String? operationUuid,
    String? businessId,
    String? customerClientUuid,
    String? action,
    int? baseVersion,
    String? payloadJson,
    DateTime? createdAt,
    int? attemptCount,
    Value<String?> lastError = const Value.absent(),
  }) => CustomerSyncOperation(
    operationUuid: operationUuid ?? this.operationUuid,
    businessId: businessId ?? this.businessId,
    customerClientUuid: customerClientUuid ?? this.customerClientUuid,
    action: action ?? this.action,
    baseVersion: baseVersion ?? this.baseVersion,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    attemptCount: attemptCount ?? this.attemptCount,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  CustomerSyncOperation copyWithCompanion(
    CustomerSyncOperationsCompanion data,
  ) {
    return CustomerSyncOperation(
      operationUuid: data.operationUuid.present
          ? data.operationUuid.value
          : this.operationUuid,
      businessId: data.businessId.present
          ? data.businessId.value
          : this.businessId,
      customerClientUuid: data.customerClientUuid.present
          ? data.customerClientUuid.value
          : this.customerClientUuid,
      action: data.action.present ? data.action.value : this.action,
      baseVersion: data.baseVersion.present
          ? data.baseVersion.value
          : this.baseVersion,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerSyncOperation(')
          ..write('operationUuid: $operationUuid, ')
          ..write('businessId: $businessId, ')
          ..write('customerClientUuid: $customerClientUuid, ')
          ..write('action: $action, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    operationUuid,
    businessId,
    customerClientUuid,
    action,
    baseVersion,
    payloadJson,
    createdAt,
    attemptCount,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerSyncOperation &&
          other.operationUuid == this.operationUuid &&
          other.businessId == this.businessId &&
          other.customerClientUuid == this.customerClientUuid &&
          other.action == this.action &&
          other.baseVersion == this.baseVersion &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.attemptCount == this.attemptCount &&
          other.lastError == this.lastError);
}

class CustomerSyncOperationsCompanion
    extends UpdateCompanion<CustomerSyncOperation> {
  final Value<String> operationUuid;
  final Value<String> businessId;
  final Value<String> customerClientUuid;
  final Value<String> action;
  final Value<int> baseVersion;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<int> attemptCount;
  final Value<String?> lastError;
  final Value<int> rowid;
  const CustomerSyncOperationsCompanion({
    this.operationUuid = const Value.absent(),
    this.businessId = const Value.absent(),
    this.customerClientUuid = const Value.absent(),
    this.action = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomerSyncOperationsCompanion.insert({
    required String operationUuid,
    required String businessId,
    required String customerClientUuid,
    required String action,
    required int baseVersion,
    required String payloadJson,
    required DateTime createdAt,
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : operationUuid = Value(operationUuid),
       businessId = Value(businessId),
       customerClientUuid = Value(customerClientUuid),
       action = Value(action),
       baseVersion = Value(baseVersion),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<CustomerSyncOperation> custom({
    Expression<String>? operationUuid,
    Expression<String>? businessId,
    Expression<String>? customerClientUuid,
    Expression<String>? action,
    Expression<int>? baseVersion,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<int>? attemptCount,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationUuid != null) 'operation_uuid': operationUuid,
      if (businessId != null) 'business_id': businessId,
      if (customerClientUuid != null)
        'customer_client_uuid': customerClientUuid,
      if (action != null) 'action': action,
      if (baseVersion != null) 'base_version': baseVersion,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomerSyncOperationsCompanion copyWith({
    Value<String>? operationUuid,
    Value<String>? businessId,
    Value<String>? customerClientUuid,
    Value<String>? action,
    Value<int>? baseVersion,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<int>? attemptCount,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return CustomerSyncOperationsCompanion(
      operationUuid: operationUuid ?? this.operationUuid,
      businessId: businessId ?? this.businessId,
      customerClientUuid: customerClientUuid ?? this.customerClientUuid,
      action: action ?? this.action,
      baseVersion: baseVersion ?? this.baseVersion,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationUuid.present) {
      map['operation_uuid'] = Variable<String>(operationUuid.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (customerClientUuid.present) {
      map['customer_client_uuid'] = Variable<String>(customerClientUuid.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerSyncOperationsCompanion(')
          ..write('operationUuid: $operationUuid, ')
          ..write('businessId: $businessId, ')
          ..write('customerClientUuid: $customerClientUuid, ')
          ..write('action: $action, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalMeasurementTemplatesTable extends LocalMeasurementTemplates
    with TableInfo<$LocalMeasurementTemplatesTable, LocalMeasurementTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMeasurementTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _businessScopeMeta = const VerificationMeta(
    'businessScope',
  );
  @override
  late final GeneratedColumn<String> businessScope = GeneratedColumn<String>(
    'business_scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientUuidMeta = const VerificationMeta(
    'clientUuid',
  );
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
    'client_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _systemCodeMeta = const VerificationMeta(
    'systemCode',
  );
  @override
  late final GeneratedColumn<String> systemCode = GeneratedColumn<String>(
    'system_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTemplateUuidMeta =
      const VerificationMeta('sourceTemplateUuid');
  @override
  late final GeneratedColumn<String> sourceTemplateUuid =
      GeneratedColumn<String>(
        'source_template_uuid',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameUrMeta = const VerificationMeta('nameUr');
  @override
  late final GeneratedColumn<String> nameUr = GeneratedColumn<String>(
    'name_ur',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameRomanUrMeta = const VerificationMeta(
    'nameRomanUr',
  );
  @override
  late final GeneratedColumn<String> nameRomanUr = GeneratedColumn<String>(
    'name_roman_ur',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defaultUnitMeta = const VerificationMeta(
    'defaultUnit',
  );
  @override
  late final GeneratedColumn<String> defaultUnit = GeneratedColumn<String>(
    'default_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('inch'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _serverVersionMeta = const VerificationMeta(
    'serverVersion',
  );
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
    'server_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _definitionVersionMeta = const VerificationMeta(
    'definitionVersion',
  );
  @override
  late final GeneratedColumn<int> definitionVersion = GeneratedColumn<int>(
    'definition_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _fieldsJsonMeta = const VerificationMeta(
    'fieldsJson',
  );
  @override
  late final GeneratedColumn<String> fieldsJson = GeneratedColumn<String>(
    'fields_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    businessScope,
    clientUuid,
    serverId,
    systemCode,
    source,
    sourceTemplateUuid,
    name,
    nameUr,
    nameRomanUr,
    category,
    defaultUnit,
    description,
    status,
    serverVersion,
    definitionVersion,
    fieldsJson,
    createdAt,
    updatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_measurement_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalMeasurementTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('business_scope')) {
      context.handle(
        _businessScopeMeta,
        businessScope.isAcceptableOrUnknown(
          data['business_scope']!,
          _businessScopeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessScopeMeta);
    }
    if (data.containsKey('client_uuid')) {
      context.handle(
        _clientUuidMeta,
        clientUuid.isAcceptableOrUnknown(data['client_uuid']!, _clientUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('system_code')) {
      context.handle(
        _systemCodeMeta,
        systemCode.isAcceptableOrUnknown(data['system_code']!, _systemCodeMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('source_template_uuid')) {
      context.handle(
        _sourceTemplateUuidMeta,
        sourceTemplateUuid.isAcceptableOrUnknown(
          data['source_template_uuid']!,
          _sourceTemplateUuidMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_ur')) {
      context.handle(
        _nameUrMeta,
        nameUr.isAcceptableOrUnknown(data['name_ur']!, _nameUrMeta),
      );
    }
    if (data.containsKey('name_roman_ur')) {
      context.handle(
        _nameRomanUrMeta,
        nameRomanUr.isAcceptableOrUnknown(
          data['name_roman_ur']!,
          _nameRomanUrMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('default_unit')) {
      context.handle(
        _defaultUnitMeta,
        defaultUnit.isAcceptableOrUnknown(
          data['default_unit']!,
          _defaultUnitMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('server_version')) {
      context.handle(
        _serverVersionMeta,
        serverVersion.isAcceptableOrUnknown(
          data['server_version']!,
          _serverVersionMeta,
        ),
      );
    }
    if (data.containsKey('definition_version')) {
      context.handle(
        _definitionVersionMeta,
        definitionVersion.isAcceptableOrUnknown(
          data['definition_version']!,
          _definitionVersionMeta,
        ),
      );
    }
    if (data.containsKey('fields_json')) {
      context.handle(
        _fieldsJsonMeta,
        fieldsJson.isAcceptableOrUnknown(data['fields_json']!, _fieldsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {businessScope, clientUuid};
  @override
  LocalMeasurementTemplate map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMeasurementTemplate(
      businessScope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_scope'],
      )!,
      clientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_uuid'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      systemCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_code'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceTemplateUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_template_uuid'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameUr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ur'],
      ),
      nameRomanUr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_roman_ur'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      defaultUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_unit'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      serverVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_version'],
      )!,
      definitionVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}definition_version'],
      )!,
      fieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fields_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $LocalMeasurementTemplatesTable createAlias(String alias) {
    return $LocalMeasurementTemplatesTable(attachedDatabase, alias);
  }
}

class LocalMeasurementTemplate extends DataClass
    implements Insertable<LocalMeasurementTemplate> {
  final String businessScope;
  final String clientUuid;
  final String? serverId;
  final String? systemCode;
  final String source;
  final String? sourceTemplateUuid;
  final String name;
  final String? nameUr;
  final String? nameRomanUr;
  final String category;
  final String defaultUnit;
  final String? description;
  final String status;
  final int serverVersion;
  final int definitionVersion;
  final String fieldsJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  const LocalMeasurementTemplate({
    required this.businessScope,
    required this.clientUuid,
    this.serverId,
    this.systemCode,
    required this.source,
    this.sourceTemplateUuid,
    required this.name,
    this.nameUr,
    this.nameRomanUr,
    required this.category,
    required this.defaultUnit,
    this.description,
    required this.status,
    required this.serverVersion,
    required this.definitionVersion,
    required this.fieldsJson,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['business_scope'] = Variable<String>(businessScope);
    map['client_uuid'] = Variable<String>(clientUuid);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    if (!nullToAbsent || systemCode != null) {
      map['system_code'] = Variable<String>(systemCode);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || sourceTemplateUuid != null) {
      map['source_template_uuid'] = Variable<String>(sourceTemplateUuid);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameUr != null) {
      map['name_ur'] = Variable<String>(nameUr);
    }
    if (!nullToAbsent || nameRomanUr != null) {
      map['name_roman_ur'] = Variable<String>(nameRomanUr);
    }
    map['category'] = Variable<String>(category);
    map['default_unit'] = Variable<String>(defaultUnit);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<String>(status);
    map['server_version'] = Variable<int>(serverVersion);
    map['definition_version'] = Variable<int>(definitionVersion);
    map['fields_json'] = Variable<String>(fieldsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  LocalMeasurementTemplatesCompanion toCompanion(bool nullToAbsent) {
    return LocalMeasurementTemplatesCompanion(
      businessScope: Value(businessScope),
      clientUuid: Value(clientUuid),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      systemCode: systemCode == null && nullToAbsent
          ? const Value.absent()
          : Value(systemCode),
      source: Value(source),
      sourceTemplateUuid: sourceTemplateUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceTemplateUuid),
      name: Value(name),
      nameUr: nameUr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameUr),
      nameRomanUr: nameRomanUr == null && nullToAbsent
          ? const Value.absent()
          : Value(nameRomanUr),
      category: Value(category),
      defaultUnit: Value(defaultUnit),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      serverVersion: Value(serverVersion),
      definitionVersion: Value(definitionVersion),
      fieldsJson: Value(fieldsJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory LocalMeasurementTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMeasurementTemplate(
      businessScope: serializer.fromJson<String>(json['businessScope']),
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      systemCode: serializer.fromJson<String?>(json['systemCode']),
      source: serializer.fromJson<String>(json['source']),
      sourceTemplateUuid: serializer.fromJson<String?>(
        json['sourceTemplateUuid'],
      ),
      name: serializer.fromJson<String>(json['name']),
      nameUr: serializer.fromJson<String?>(json['nameUr']),
      nameRomanUr: serializer.fromJson<String?>(json['nameRomanUr']),
      category: serializer.fromJson<String>(json['category']),
      defaultUnit: serializer.fromJson<String>(json['defaultUnit']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      serverVersion: serializer.fromJson<int>(json['serverVersion']),
      definitionVersion: serializer.fromJson<int>(json['definitionVersion']),
      fieldsJson: serializer.fromJson<String>(json['fieldsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'businessScope': serializer.toJson<String>(businessScope),
      'clientUuid': serializer.toJson<String>(clientUuid),
      'serverId': serializer.toJson<String?>(serverId),
      'systemCode': serializer.toJson<String?>(systemCode),
      'source': serializer.toJson<String>(source),
      'sourceTemplateUuid': serializer.toJson<String?>(sourceTemplateUuid),
      'name': serializer.toJson<String>(name),
      'nameUr': serializer.toJson<String?>(nameUr),
      'nameRomanUr': serializer.toJson<String?>(nameRomanUr),
      'category': serializer.toJson<String>(category),
      'defaultUnit': serializer.toJson<String>(defaultUnit),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(status),
      'serverVersion': serializer.toJson<int>(serverVersion),
      'definitionVersion': serializer.toJson<int>(definitionVersion),
      'fieldsJson': serializer.toJson<String>(fieldsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  LocalMeasurementTemplate copyWith({
    String? businessScope,
    String? clientUuid,
    Value<String?> serverId = const Value.absent(),
    Value<String?> systemCode = const Value.absent(),
    String? source,
    Value<String?> sourceTemplateUuid = const Value.absent(),
    String? name,
    Value<String?> nameUr = const Value.absent(),
    Value<String?> nameRomanUr = const Value.absent(),
    String? category,
    String? defaultUnit,
    Value<String?> description = const Value.absent(),
    String? status,
    int? serverVersion,
    int? definitionVersion,
    String? fieldsJson,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => LocalMeasurementTemplate(
    businessScope: businessScope ?? this.businessScope,
    clientUuid: clientUuid ?? this.clientUuid,
    serverId: serverId.present ? serverId.value : this.serverId,
    systemCode: systemCode.present ? systemCode.value : this.systemCode,
    source: source ?? this.source,
    sourceTemplateUuid: sourceTemplateUuid.present
        ? sourceTemplateUuid.value
        : this.sourceTemplateUuid,
    name: name ?? this.name,
    nameUr: nameUr.present ? nameUr.value : this.nameUr,
    nameRomanUr: nameRomanUr.present ? nameRomanUr.value : this.nameRomanUr,
    category: category ?? this.category,
    defaultUnit: defaultUnit ?? this.defaultUnit,
    description: description.present ? description.value : this.description,
    status: status ?? this.status,
    serverVersion: serverVersion ?? this.serverVersion,
    definitionVersion: definitionVersion ?? this.definitionVersion,
    fieldsJson: fieldsJson ?? this.fieldsJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  LocalMeasurementTemplate copyWithCompanion(
    LocalMeasurementTemplatesCompanion data,
  ) {
    return LocalMeasurementTemplate(
      businessScope: data.businessScope.present
          ? data.businessScope.value
          : this.businessScope,
      clientUuid: data.clientUuid.present
          ? data.clientUuid.value
          : this.clientUuid,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      systemCode: data.systemCode.present
          ? data.systemCode.value
          : this.systemCode,
      source: data.source.present ? data.source.value : this.source,
      sourceTemplateUuid: data.sourceTemplateUuid.present
          ? data.sourceTemplateUuid.value
          : this.sourceTemplateUuid,
      name: data.name.present ? data.name.value : this.name,
      nameUr: data.nameUr.present ? data.nameUr.value : this.nameUr,
      nameRomanUr: data.nameRomanUr.present
          ? data.nameRomanUr.value
          : this.nameRomanUr,
      category: data.category.present ? data.category.value : this.category,
      defaultUnit: data.defaultUnit.present
          ? data.defaultUnit.value
          : this.defaultUnit,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      definitionVersion: data.definitionVersion.present
          ? data.definitionVersion.value
          : this.definitionVersion,
      fieldsJson: data.fieldsJson.present
          ? data.fieldsJson.value
          : this.fieldsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMeasurementTemplate(')
          ..write('businessScope: $businessScope, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('serverId: $serverId, ')
          ..write('systemCode: $systemCode, ')
          ..write('source: $source, ')
          ..write('sourceTemplateUuid: $sourceTemplateUuid, ')
          ..write('name: $name, ')
          ..write('nameUr: $nameUr, ')
          ..write('nameRomanUr: $nameRomanUr, ')
          ..write('category: $category, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('definitionVersion: $definitionVersion, ')
          ..write('fieldsJson: $fieldsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    businessScope,
    clientUuid,
    serverId,
    systemCode,
    source,
    sourceTemplateUuid,
    name,
    nameUr,
    nameRomanUr,
    category,
    defaultUnit,
    description,
    status,
    serverVersion,
    definitionVersion,
    fieldsJson,
    createdAt,
    updatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMeasurementTemplate &&
          other.businessScope == this.businessScope &&
          other.clientUuid == this.clientUuid &&
          other.serverId == this.serverId &&
          other.systemCode == this.systemCode &&
          other.source == this.source &&
          other.sourceTemplateUuid == this.sourceTemplateUuid &&
          other.name == this.name &&
          other.nameUr == this.nameUr &&
          other.nameRomanUr == this.nameRomanUr &&
          other.category == this.category &&
          other.defaultUnit == this.defaultUnit &&
          other.description == this.description &&
          other.status == this.status &&
          other.serverVersion == this.serverVersion &&
          other.definitionVersion == this.definitionVersion &&
          other.fieldsJson == this.fieldsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt);
}

class LocalMeasurementTemplatesCompanion
    extends UpdateCompanion<LocalMeasurementTemplate> {
  final Value<String> businessScope;
  final Value<String> clientUuid;
  final Value<String?> serverId;
  final Value<String?> systemCode;
  final Value<String> source;
  final Value<String?> sourceTemplateUuid;
  final Value<String> name;
  final Value<String?> nameUr;
  final Value<String?> nameRomanUr;
  final Value<String> category;
  final Value<String> defaultUnit;
  final Value<String?> description;
  final Value<String> status;
  final Value<int> serverVersion;
  final Value<int> definitionVersion;
  final Value<String> fieldsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const LocalMeasurementTemplatesCompanion({
    this.businessScope = const Value.absent(),
    this.clientUuid = const Value.absent(),
    this.serverId = const Value.absent(),
    this.systemCode = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceTemplateUuid = const Value.absent(),
    this.name = const Value.absent(),
    this.nameUr = const Value.absent(),
    this.nameRomanUr = const Value.absent(),
    this.category = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.definitionVersion = const Value.absent(),
    this.fieldsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMeasurementTemplatesCompanion.insert({
    required String businessScope,
    required String clientUuid,
    this.serverId = const Value.absent(),
    this.systemCode = const Value.absent(),
    required String source,
    this.sourceTemplateUuid = const Value.absent(),
    required String name,
    this.nameUr = const Value.absent(),
    this.nameRomanUr = const Value.absent(),
    required String category,
    this.defaultUnit = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.definitionVersion = const Value.absent(),
    required String fieldsJson,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : businessScope = Value(businessScope),
       clientUuid = Value(clientUuid),
       source = Value(source),
       name = Value(name),
       category = Value(category),
       fieldsJson = Value(fieldsJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalMeasurementTemplate> custom({
    Expression<String>? businessScope,
    Expression<String>? clientUuid,
    Expression<String>? serverId,
    Expression<String>? systemCode,
    Expression<String>? source,
    Expression<String>? sourceTemplateUuid,
    Expression<String>? name,
    Expression<String>? nameUr,
    Expression<String>? nameRomanUr,
    Expression<String>? category,
    Expression<String>? defaultUnit,
    Expression<String>? description,
    Expression<String>? status,
    Expression<int>? serverVersion,
    Expression<int>? definitionVersion,
    Expression<String>? fieldsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (businessScope != null) 'business_scope': businessScope,
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (serverId != null) 'server_id': serverId,
      if (systemCode != null) 'system_code': systemCode,
      if (source != null) 'source': source,
      if (sourceTemplateUuid != null)
        'source_template_uuid': sourceTemplateUuid,
      if (name != null) 'name': name,
      if (nameUr != null) 'name_ur': nameUr,
      if (nameRomanUr != null) 'name_roman_ur': nameRomanUr,
      if (category != null) 'category': category,
      if (defaultUnit != null) 'default_unit': defaultUnit,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (serverVersion != null) 'server_version': serverVersion,
      if (definitionVersion != null) 'definition_version': definitionVersion,
      if (fieldsJson != null) 'fields_json': fieldsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMeasurementTemplatesCompanion copyWith({
    Value<String>? businessScope,
    Value<String>? clientUuid,
    Value<String?>? serverId,
    Value<String?>? systemCode,
    Value<String>? source,
    Value<String?>? sourceTemplateUuid,
    Value<String>? name,
    Value<String?>? nameUr,
    Value<String?>? nameRomanUr,
    Value<String>? category,
    Value<String>? defaultUnit,
    Value<String?>? description,
    Value<String>? status,
    Value<int>? serverVersion,
    Value<int>? definitionVersion,
    Value<String>? fieldsJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return LocalMeasurementTemplatesCompanion(
      businessScope: businessScope ?? this.businessScope,
      clientUuid: clientUuid ?? this.clientUuid,
      serverId: serverId ?? this.serverId,
      systemCode: systemCode ?? this.systemCode,
      source: source ?? this.source,
      sourceTemplateUuid: sourceTemplateUuid ?? this.sourceTemplateUuid,
      name: name ?? this.name,
      nameUr: nameUr ?? this.nameUr,
      nameRomanUr: nameRomanUr ?? this.nameRomanUr,
      category: category ?? this.category,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      description: description ?? this.description,
      status: status ?? this.status,
      serverVersion: serverVersion ?? this.serverVersion,
      definitionVersion: definitionVersion ?? this.definitionVersion,
      fieldsJson: fieldsJson ?? this.fieldsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (businessScope.present) {
      map['business_scope'] = Variable<String>(businessScope.value);
    }
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (systemCode.present) {
      map['system_code'] = Variable<String>(systemCode.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceTemplateUuid.present) {
      map['source_template_uuid'] = Variable<String>(sourceTemplateUuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameUr.present) {
      map['name_ur'] = Variable<String>(nameUr.value);
    }
    if (nameRomanUr.present) {
      map['name_roman_ur'] = Variable<String>(nameRomanUr.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (defaultUnit.present) {
      map['default_unit'] = Variable<String>(defaultUnit.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (definitionVersion.present) {
      map['definition_version'] = Variable<int>(definitionVersion.value);
    }
    if (fieldsJson.present) {
      map['fields_json'] = Variable<String>(fieldsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMeasurementTemplatesCompanion(')
          ..write('businessScope: $businessScope, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('serverId: $serverId, ')
          ..write('systemCode: $systemCode, ')
          ..write('source: $source, ')
          ..write('sourceTemplateUuid: $sourceTemplateUuid, ')
          ..write('name: $name, ')
          ..write('nameUr: $nameUr, ')
          ..write('nameRomanUr: $nameRomanUr, ')
          ..write('category: $category, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('definitionVersion: $definitionVersion, ')
          ..write('fieldsJson: $fieldsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalMeasurementProfilesTable extends LocalMeasurementProfiles
    with TableInfo<$LocalMeasurementProfilesTable, LocalMeasurementProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMeasurementProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _businessIdMeta = const VerificationMeta(
    'businessId',
  );
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
    'business_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerClientUuidMeta =
      const VerificationMeta('customerClientUuid');
  @override
  late final GeneratedColumn<String> customerClientUuid =
      GeneratedColumn<String>(
        'customer_client_uuid',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _clientUuidMeta = const VerificationMeta(
    'clientUuid',
  );
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
    'client_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _templateClientUuidMeta =
      const VerificationMeta('templateClientUuid');
  @override
  late final GeneratedColumn<String> templateClientUuid =
      GeneratedColumn<String>(
        'template_client_uuid',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _templateDefinitionVersionMeta =
      const VerificationMeta('templateDefinitionVersion');
  @override
  late final GeneratedColumn<int> templateDefinitionVersion =
      GeneratedColumn<int>(
        'template_definition_version',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferredUnitMeta = const VerificationMeta(
    'preferredUnit',
  );
  @override
  late final GeneratedColumn<String> preferredUnit = GeneratedColumn<String>(
    'preferred_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('inch'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _serverVersionMeta = const VerificationMeta(
    'serverVersion',
  );
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
    'server_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _latestRevisionNumberMeta =
      const VerificationMeta('latestRevisionNumber');
  @override
  late final GeneratedColumn<int> latestRevisionNumber = GeneratedColumn<int>(
    'latest_revision_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverUpdatedAtMeta = const VerificationMeta(
    'serverUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>(
        'server_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    businessId,
    customerClientUuid,
    clientUuid,
    serverId,
    templateClientUuid,
    templateDefinitionVersion,
    name,
    preferredUnit,
    notes,
    status,
    serverVersion,
    latestRevisionNumber,
    syncState,
    syncError,
    createdAt,
    updatedAt,
    serverUpdatedAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_measurement_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalMeasurementProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('business_id')) {
      context.handle(
        _businessIdMeta,
        businessId.isAcceptableOrUnknown(data['business_id']!, _businessIdMeta),
      );
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('customer_client_uuid')) {
      context.handle(
        _customerClientUuidMeta,
        customerClientUuid.isAcceptableOrUnknown(
          data['customer_client_uuid']!,
          _customerClientUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerClientUuidMeta);
    }
    if (data.containsKey('client_uuid')) {
      context.handle(
        _clientUuidMeta,
        clientUuid.isAcceptableOrUnknown(data['client_uuid']!, _clientUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('template_client_uuid')) {
      context.handle(
        _templateClientUuidMeta,
        templateClientUuid.isAcceptableOrUnknown(
          data['template_client_uuid']!,
          _templateClientUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateClientUuidMeta);
    }
    if (data.containsKey('template_definition_version')) {
      context.handle(
        _templateDefinitionVersionMeta,
        templateDefinitionVersion.isAcceptableOrUnknown(
          data['template_definition_version']!,
          _templateDefinitionVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateDefinitionVersionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('preferred_unit')) {
      context.handle(
        _preferredUnitMeta,
        preferredUnit.isAcceptableOrUnknown(
          data['preferred_unit']!,
          _preferredUnitMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('server_version')) {
      context.handle(
        _serverVersionMeta,
        serverVersion.isAcceptableOrUnknown(
          data['server_version']!,
          _serverVersionMeta,
        ),
      );
    }
    if (data.containsKey('latest_revision_number')) {
      context.handle(
        _latestRevisionNumberMeta,
        latestRevisionNumber.isAcceptableOrUnknown(
          data['latest_revision_number']!,
          _latestRevisionNumberMeta,
        ),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
        _serverUpdatedAtMeta,
        serverUpdatedAt.isAcceptableOrUnknown(
          data['server_updated_at']!,
          _serverUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {businessId, clientUuid};
  @override
  LocalMeasurementProfile map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMeasurementProfile(
      businessId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_id'],
      )!,
      customerClientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_client_uuid'],
      )!,
      clientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_uuid'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      templateClientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_client_uuid'],
      )!,
      templateDefinitionVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_definition_version'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      preferredUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_unit'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      serverVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_version'],
      )!,
      latestRevisionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}latest_revision_number'],
      )!,
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_updated_at'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $LocalMeasurementProfilesTable createAlias(String alias) {
    return $LocalMeasurementProfilesTable(attachedDatabase, alias);
  }
}

class LocalMeasurementProfile extends DataClass
    implements Insertable<LocalMeasurementProfile> {
  final String businessId;
  final String customerClientUuid;
  final String clientUuid;
  final String? serverId;
  final String templateClientUuid;
  final int templateDefinitionVersion;
  final String name;
  final String preferredUnit;
  final String? notes;
  final String status;
  final int serverVersion;
  final int latestRevisionNumber;
  final String syncState;
  final String? syncError;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? serverUpdatedAt;
  final DateTime? archivedAt;
  const LocalMeasurementProfile({
    required this.businessId,
    required this.customerClientUuid,
    required this.clientUuid,
    this.serverId,
    required this.templateClientUuid,
    required this.templateDefinitionVersion,
    required this.name,
    required this.preferredUnit,
    this.notes,
    required this.status,
    required this.serverVersion,
    required this.latestRevisionNumber,
    required this.syncState,
    this.syncError,
    required this.createdAt,
    required this.updatedAt,
    this.serverUpdatedAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['business_id'] = Variable<String>(businessId);
    map['customer_client_uuid'] = Variable<String>(customerClientUuid);
    map['client_uuid'] = Variable<String>(clientUuid);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['template_client_uuid'] = Variable<String>(templateClientUuid);
    map['template_definition_version'] = Variable<int>(
      templateDefinitionVersion,
    );
    map['name'] = Variable<String>(name);
    map['preferred_unit'] = Variable<String>(preferredUnit);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    map['server_version'] = Variable<int>(serverVersion);
    map['latest_revision_number'] = Variable<int>(latestRevisionNumber);
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  LocalMeasurementProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalMeasurementProfilesCompanion(
      businessId: Value(businessId),
      customerClientUuid: Value(customerClientUuid),
      clientUuid: Value(clientUuid),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      templateClientUuid: Value(templateClientUuid),
      templateDefinitionVersion: Value(templateDefinitionVersion),
      name: Value(name),
      preferredUnit: Value(preferredUnit),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
      serverVersion: Value(serverVersion),
      latestRevisionNumber: Value(latestRevisionNumber),
      syncState: Value(syncState),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory LocalMeasurementProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMeasurementProfile(
      businessId: serializer.fromJson<String>(json['businessId']),
      customerClientUuid: serializer.fromJson<String>(
        json['customerClientUuid'],
      ),
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      templateClientUuid: serializer.fromJson<String>(
        json['templateClientUuid'],
      ),
      templateDefinitionVersion: serializer.fromJson<int>(
        json['templateDefinitionVersion'],
      ),
      name: serializer.fromJson<String>(json['name']),
      preferredUnit: serializer.fromJson<String>(json['preferredUnit']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      serverVersion: serializer.fromJson<int>(json['serverVersion']),
      latestRevisionNumber: serializer.fromJson<int>(
        json['latestRevisionNumber'],
      ),
      syncState: serializer.fromJson<String>(json['syncState']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'businessId': serializer.toJson<String>(businessId),
      'customerClientUuid': serializer.toJson<String>(customerClientUuid),
      'clientUuid': serializer.toJson<String>(clientUuid),
      'serverId': serializer.toJson<String?>(serverId),
      'templateClientUuid': serializer.toJson<String>(templateClientUuid),
      'templateDefinitionVersion': serializer.toJson<int>(
        templateDefinitionVersion,
      ),
      'name': serializer.toJson<String>(name),
      'preferredUnit': serializer.toJson<String>(preferredUnit),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'serverVersion': serializer.toJson<int>(serverVersion),
      'latestRevisionNumber': serializer.toJson<int>(latestRevisionNumber),
      'syncState': serializer.toJson<String>(syncState),
      'syncError': serializer.toJson<String?>(syncError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  LocalMeasurementProfile copyWith({
    String? businessId,
    String? customerClientUuid,
    String? clientUuid,
    Value<String?> serverId = const Value.absent(),
    String? templateClientUuid,
    int? templateDefinitionVersion,
    String? name,
    String? preferredUnit,
    Value<String?> notes = const Value.absent(),
    String? status,
    int? serverVersion,
    int? latestRevisionNumber,
    String? syncState,
    Value<String?> syncError = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> serverUpdatedAt = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => LocalMeasurementProfile(
    businessId: businessId ?? this.businessId,
    customerClientUuid: customerClientUuid ?? this.customerClientUuid,
    clientUuid: clientUuid ?? this.clientUuid,
    serverId: serverId.present ? serverId.value : this.serverId,
    templateClientUuid: templateClientUuid ?? this.templateClientUuid,
    templateDefinitionVersion:
        templateDefinitionVersion ?? this.templateDefinitionVersion,
    name: name ?? this.name,
    preferredUnit: preferredUnit ?? this.preferredUnit,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
    serverVersion: serverVersion ?? this.serverVersion,
    latestRevisionNumber: latestRevisionNumber ?? this.latestRevisionNumber,
    syncState: syncState ?? this.syncState,
    syncError: syncError.present ? syncError.value : this.syncError,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    serverUpdatedAt: serverUpdatedAt.present
        ? serverUpdatedAt.value
        : this.serverUpdatedAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  LocalMeasurementProfile copyWithCompanion(
    LocalMeasurementProfilesCompanion data,
  ) {
    return LocalMeasurementProfile(
      businessId: data.businessId.present
          ? data.businessId.value
          : this.businessId,
      customerClientUuid: data.customerClientUuid.present
          ? data.customerClientUuid.value
          : this.customerClientUuid,
      clientUuid: data.clientUuid.present
          ? data.clientUuid.value
          : this.clientUuid,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      templateClientUuid: data.templateClientUuid.present
          ? data.templateClientUuid.value
          : this.templateClientUuid,
      templateDefinitionVersion: data.templateDefinitionVersion.present
          ? data.templateDefinitionVersion.value
          : this.templateDefinitionVersion,
      name: data.name.present ? data.name.value : this.name,
      preferredUnit: data.preferredUnit.present
          ? data.preferredUnit.value
          : this.preferredUnit,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      latestRevisionNumber: data.latestRevisionNumber.present
          ? data.latestRevisionNumber.value
          : this.latestRevisionNumber,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMeasurementProfile(')
          ..write('businessId: $businessId, ')
          ..write('customerClientUuid: $customerClientUuid, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('serverId: $serverId, ')
          ..write('templateClientUuid: $templateClientUuid, ')
          ..write('templateDefinitionVersion: $templateDefinitionVersion, ')
          ..write('name: $name, ')
          ..write('preferredUnit: $preferredUnit, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('latestRevisionNumber: $latestRevisionNumber, ')
          ..write('syncState: $syncState, ')
          ..write('syncError: $syncError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    businessId,
    customerClientUuid,
    clientUuid,
    serverId,
    templateClientUuid,
    templateDefinitionVersion,
    name,
    preferredUnit,
    notes,
    status,
    serverVersion,
    latestRevisionNumber,
    syncState,
    syncError,
    createdAt,
    updatedAt,
    serverUpdatedAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMeasurementProfile &&
          other.businessId == this.businessId &&
          other.customerClientUuid == this.customerClientUuid &&
          other.clientUuid == this.clientUuid &&
          other.serverId == this.serverId &&
          other.templateClientUuid == this.templateClientUuid &&
          other.templateDefinitionVersion == this.templateDefinitionVersion &&
          other.name == this.name &&
          other.preferredUnit == this.preferredUnit &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.serverVersion == this.serverVersion &&
          other.latestRevisionNumber == this.latestRevisionNumber &&
          other.syncState == this.syncState &&
          other.syncError == this.syncError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.archivedAt == this.archivedAt);
}

class LocalMeasurementProfilesCompanion
    extends UpdateCompanion<LocalMeasurementProfile> {
  final Value<String> businessId;
  final Value<String> customerClientUuid;
  final Value<String> clientUuid;
  final Value<String?> serverId;
  final Value<String> templateClientUuid;
  final Value<int> templateDefinitionVersion;
  final Value<String> name;
  final Value<String> preferredUnit;
  final Value<String?> notes;
  final Value<String> status;
  final Value<int> serverVersion;
  final Value<int> latestRevisionNumber;
  final Value<String> syncState;
  final Value<String?> syncError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const LocalMeasurementProfilesCompanion({
    this.businessId = const Value.absent(),
    this.customerClientUuid = const Value.absent(),
    this.clientUuid = const Value.absent(),
    this.serverId = const Value.absent(),
    this.templateClientUuid = const Value.absent(),
    this.templateDefinitionVersion = const Value.absent(),
    this.name = const Value.absent(),
    this.preferredUnit = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.latestRevisionNumber = const Value.absent(),
    this.syncState = const Value.absent(),
    this.syncError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMeasurementProfilesCompanion.insert({
    required String businessId,
    required String customerClientUuid,
    required String clientUuid,
    this.serverId = const Value.absent(),
    required String templateClientUuid,
    required int templateDefinitionVersion,
    required String name,
    this.preferredUnit = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.latestRevisionNumber = const Value.absent(),
    this.syncState = const Value.absent(),
    this.syncError = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.serverUpdatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : businessId = Value(businessId),
       customerClientUuid = Value(customerClientUuid),
       clientUuid = Value(clientUuid),
       templateClientUuid = Value(templateClientUuid),
       templateDefinitionVersion = Value(templateDefinitionVersion),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalMeasurementProfile> custom({
    Expression<String>? businessId,
    Expression<String>? customerClientUuid,
    Expression<String>? clientUuid,
    Expression<String>? serverId,
    Expression<String>? templateClientUuid,
    Expression<int>? templateDefinitionVersion,
    Expression<String>? name,
    Expression<String>? preferredUnit,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<int>? serverVersion,
    Expression<int>? latestRevisionNumber,
    Expression<String>? syncState,
    Expression<String>? syncError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (businessId != null) 'business_id': businessId,
      if (customerClientUuid != null)
        'customer_client_uuid': customerClientUuid,
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (serverId != null) 'server_id': serverId,
      if (templateClientUuid != null)
        'template_client_uuid': templateClientUuid,
      if (templateDefinitionVersion != null)
        'template_definition_version': templateDefinitionVersion,
      if (name != null) 'name': name,
      if (preferredUnit != null) 'preferred_unit': preferredUnit,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (serverVersion != null) 'server_version': serverVersion,
      if (latestRevisionNumber != null)
        'latest_revision_number': latestRevisionNumber,
      if (syncState != null) 'sync_state': syncState,
      if (syncError != null) 'sync_error': syncError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMeasurementProfilesCompanion copyWith({
    Value<String>? businessId,
    Value<String>? customerClientUuid,
    Value<String>? clientUuid,
    Value<String?>? serverId,
    Value<String>? templateClientUuid,
    Value<int>? templateDefinitionVersion,
    Value<String>? name,
    Value<String>? preferredUnit,
    Value<String?>? notes,
    Value<String>? status,
    Value<int>? serverVersion,
    Value<int>? latestRevisionNumber,
    Value<String>? syncState,
    Value<String?>? syncError,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? serverUpdatedAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return LocalMeasurementProfilesCompanion(
      businessId: businessId ?? this.businessId,
      customerClientUuid: customerClientUuid ?? this.customerClientUuid,
      clientUuid: clientUuid ?? this.clientUuid,
      serverId: serverId ?? this.serverId,
      templateClientUuid: templateClientUuid ?? this.templateClientUuid,
      templateDefinitionVersion:
          templateDefinitionVersion ?? this.templateDefinitionVersion,
      name: name ?? this.name,
      preferredUnit: preferredUnit ?? this.preferredUnit,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      serverVersion: serverVersion ?? this.serverVersion,
      latestRevisionNumber: latestRevisionNumber ?? this.latestRevisionNumber,
      syncState: syncState ?? this.syncState,
      syncError: syncError ?? this.syncError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (customerClientUuid.present) {
      map['customer_client_uuid'] = Variable<String>(customerClientUuid.value);
    }
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (templateClientUuid.present) {
      map['template_client_uuid'] = Variable<String>(templateClientUuid.value);
    }
    if (templateDefinitionVersion.present) {
      map['template_definition_version'] = Variable<int>(
        templateDefinitionVersion.value,
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (preferredUnit.present) {
      map['preferred_unit'] = Variable<String>(preferredUnit.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (latestRevisionNumber.present) {
      map['latest_revision_number'] = Variable<int>(latestRevisionNumber.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMeasurementProfilesCompanion(')
          ..write('businessId: $businessId, ')
          ..write('customerClientUuid: $customerClientUuid, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('serverId: $serverId, ')
          ..write('templateClientUuid: $templateClientUuid, ')
          ..write('templateDefinitionVersion: $templateDefinitionVersion, ')
          ..write('name: $name, ')
          ..write('preferredUnit: $preferredUnit, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('latestRevisionNumber: $latestRevisionNumber, ')
          ..write('syncState: $syncState, ')
          ..write('syncError: $syncError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalMeasurementRevisionsTable extends LocalMeasurementRevisions
    with TableInfo<$LocalMeasurementRevisionsTable, LocalMeasurementRevision> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMeasurementRevisionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _businessIdMeta = const VerificationMeta(
    'businessId',
  );
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
    'business_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileClientUuidMeta = const VerificationMeta(
    'profileClientUuid',
  );
  @override
  late final GeneratedColumn<String> profileClientUuid =
      GeneratedColumn<String>(
        'profile_client_uuid',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _clientUuidMeta = const VerificationMeta(
    'clientUuid',
  );
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
    'client_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revisionNumberMeta = const VerificationMeta(
    'revisionNumber',
  );
  @override
  late final GeneratedColumn<int> revisionNumber = GeneratedColumn<int>(
    'revision_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _templateDefinitionVersionMeta =
      const VerificationMeta('templateDefinitionVersion');
  @override
  late final GeneratedColumn<int> templateDefinitionVersion =
      GeneratedColumn<int>(
        'template_definition_version',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _valuesJsonMeta = const VerificationMeta(
    'valuesJson',
  );
  @override
  late final GeneratedColumn<String> valuesJson = GeneratedColumn<String>(
    'values_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measuredAtMeta = const VerificationMeta(
    'measuredAt',
  );
  @override
  late final GeneratedColumn<DateTime> measuredAt = GeneratedColumn<DateTime>(
    'measured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _syncErrorMeta = const VerificationMeta(
    'syncError',
  );
  @override
  late final GeneratedColumn<String> syncError = GeneratedColumn<String>(
    'sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    businessId,
    profileClientUuid,
    clientUuid,
    serverId,
    revisionNumber,
    templateDefinitionVersion,
    valuesJson,
    notes,
    measuredAt,
    syncState,
    syncError,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_measurement_revisions';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalMeasurementRevision> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('business_id')) {
      context.handle(
        _businessIdMeta,
        businessId.isAcceptableOrUnknown(data['business_id']!, _businessIdMeta),
      );
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('profile_client_uuid')) {
      context.handle(
        _profileClientUuidMeta,
        profileClientUuid.isAcceptableOrUnknown(
          data['profile_client_uuid']!,
          _profileClientUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileClientUuidMeta);
    }
    if (data.containsKey('client_uuid')) {
      context.handle(
        _clientUuidMeta,
        clientUuid.isAcceptableOrUnknown(data['client_uuid']!, _clientUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('revision_number')) {
      context.handle(
        _revisionNumberMeta,
        revisionNumber.isAcceptableOrUnknown(
          data['revision_number']!,
          _revisionNumberMeta,
        ),
      );
    }
    if (data.containsKey('template_definition_version')) {
      context.handle(
        _templateDefinitionVersionMeta,
        templateDefinitionVersion.isAcceptableOrUnknown(
          data['template_definition_version']!,
          _templateDefinitionVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_templateDefinitionVersionMeta);
    }
    if (data.containsKey('values_json')) {
      context.handle(
        _valuesJsonMeta,
        valuesJson.isAcceptableOrUnknown(data['values_json']!, _valuesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valuesJsonMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('measured_at')) {
      context.handle(
        _measuredAtMeta,
        measuredAt.isAcceptableOrUnknown(data['measured_at']!, _measuredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    }
    if (data.containsKey('sync_error')) {
      context.handle(
        _syncErrorMeta,
        syncError.isAcceptableOrUnknown(data['sync_error']!, _syncErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {businessId, clientUuid};
  @override
  LocalMeasurementRevision map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMeasurementRevision(
      businessId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_id'],
      )!,
      profileClientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_client_uuid'],
      )!,
      clientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_uuid'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      revisionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}revision_number'],
      )!,
      templateDefinitionVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_definition_version'],
      )!,
      valuesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}values_json'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      measuredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}measured_at'],
      )!,
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      syncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LocalMeasurementRevisionsTable createAlias(String alias) {
    return $LocalMeasurementRevisionsTable(attachedDatabase, alias);
  }
}

class LocalMeasurementRevision extends DataClass
    implements Insertable<LocalMeasurementRevision> {
  final String businessId;
  final String profileClientUuid;
  final String clientUuid;
  final String? serverId;
  final int revisionNumber;
  final int templateDefinitionVersion;
  final String valuesJson;
  final String? notes;
  final DateTime measuredAt;
  final String syncState;
  final String? syncError;
  final DateTime createdAt;
  const LocalMeasurementRevision({
    required this.businessId,
    required this.profileClientUuid,
    required this.clientUuid,
    this.serverId,
    required this.revisionNumber,
    required this.templateDefinitionVersion,
    required this.valuesJson,
    this.notes,
    required this.measuredAt,
    required this.syncState,
    this.syncError,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['business_id'] = Variable<String>(businessId);
    map['profile_client_uuid'] = Variable<String>(profileClientUuid);
    map['client_uuid'] = Variable<String>(clientUuid);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['revision_number'] = Variable<int>(revisionNumber);
    map['template_definition_version'] = Variable<int>(
      templateDefinitionVersion,
    );
    map['values_json'] = Variable<String>(valuesJson);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['measured_at'] = Variable<DateTime>(measuredAt);
    map['sync_state'] = Variable<String>(syncState);
    if (!nullToAbsent || syncError != null) {
      map['sync_error'] = Variable<String>(syncError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalMeasurementRevisionsCompanion toCompanion(bool nullToAbsent) {
    return LocalMeasurementRevisionsCompanion(
      businessId: Value(businessId),
      profileClientUuid: Value(profileClientUuid),
      clientUuid: Value(clientUuid),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      revisionNumber: Value(revisionNumber),
      templateDefinitionVersion: Value(templateDefinitionVersion),
      valuesJson: Value(valuesJson),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      measuredAt: Value(measuredAt),
      syncState: Value(syncState),
      syncError: syncError == null && nullToAbsent
          ? const Value.absent()
          : Value(syncError),
      createdAt: Value(createdAt),
    );
  }

  factory LocalMeasurementRevision.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMeasurementRevision(
      businessId: serializer.fromJson<String>(json['businessId']),
      profileClientUuid: serializer.fromJson<String>(json['profileClientUuid']),
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      revisionNumber: serializer.fromJson<int>(json['revisionNumber']),
      templateDefinitionVersion: serializer.fromJson<int>(
        json['templateDefinitionVersion'],
      ),
      valuesJson: serializer.fromJson<String>(json['valuesJson']),
      notes: serializer.fromJson<String?>(json['notes']),
      measuredAt: serializer.fromJson<DateTime>(json['measuredAt']),
      syncState: serializer.fromJson<String>(json['syncState']),
      syncError: serializer.fromJson<String?>(json['syncError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'businessId': serializer.toJson<String>(businessId),
      'profileClientUuid': serializer.toJson<String>(profileClientUuid),
      'clientUuid': serializer.toJson<String>(clientUuid),
      'serverId': serializer.toJson<String?>(serverId),
      'revisionNumber': serializer.toJson<int>(revisionNumber),
      'templateDefinitionVersion': serializer.toJson<int>(
        templateDefinitionVersion,
      ),
      'valuesJson': serializer.toJson<String>(valuesJson),
      'notes': serializer.toJson<String?>(notes),
      'measuredAt': serializer.toJson<DateTime>(measuredAt),
      'syncState': serializer.toJson<String>(syncState),
      'syncError': serializer.toJson<String?>(syncError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalMeasurementRevision copyWith({
    String? businessId,
    String? profileClientUuid,
    String? clientUuid,
    Value<String?> serverId = const Value.absent(),
    int? revisionNumber,
    int? templateDefinitionVersion,
    String? valuesJson,
    Value<String?> notes = const Value.absent(),
    DateTime? measuredAt,
    String? syncState,
    Value<String?> syncError = const Value.absent(),
    DateTime? createdAt,
  }) => LocalMeasurementRevision(
    businessId: businessId ?? this.businessId,
    profileClientUuid: profileClientUuid ?? this.profileClientUuid,
    clientUuid: clientUuid ?? this.clientUuid,
    serverId: serverId.present ? serverId.value : this.serverId,
    revisionNumber: revisionNumber ?? this.revisionNumber,
    templateDefinitionVersion:
        templateDefinitionVersion ?? this.templateDefinitionVersion,
    valuesJson: valuesJson ?? this.valuesJson,
    notes: notes.present ? notes.value : this.notes,
    measuredAt: measuredAt ?? this.measuredAt,
    syncState: syncState ?? this.syncState,
    syncError: syncError.present ? syncError.value : this.syncError,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalMeasurementRevision copyWithCompanion(
    LocalMeasurementRevisionsCompanion data,
  ) {
    return LocalMeasurementRevision(
      businessId: data.businessId.present
          ? data.businessId.value
          : this.businessId,
      profileClientUuid: data.profileClientUuid.present
          ? data.profileClientUuid.value
          : this.profileClientUuid,
      clientUuid: data.clientUuid.present
          ? data.clientUuid.value
          : this.clientUuid,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      revisionNumber: data.revisionNumber.present
          ? data.revisionNumber.value
          : this.revisionNumber,
      templateDefinitionVersion: data.templateDefinitionVersion.present
          ? data.templateDefinitionVersion.value
          : this.templateDefinitionVersion,
      valuesJson: data.valuesJson.present
          ? data.valuesJson.value
          : this.valuesJson,
      notes: data.notes.present ? data.notes.value : this.notes,
      measuredAt: data.measuredAt.present
          ? data.measuredAt.value
          : this.measuredAt,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      syncError: data.syncError.present ? data.syncError.value : this.syncError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMeasurementRevision(')
          ..write('businessId: $businessId, ')
          ..write('profileClientUuid: $profileClientUuid, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('serverId: $serverId, ')
          ..write('revisionNumber: $revisionNumber, ')
          ..write('templateDefinitionVersion: $templateDefinitionVersion, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('notes: $notes, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('syncState: $syncState, ')
          ..write('syncError: $syncError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    businessId,
    profileClientUuid,
    clientUuid,
    serverId,
    revisionNumber,
    templateDefinitionVersion,
    valuesJson,
    notes,
    measuredAt,
    syncState,
    syncError,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMeasurementRevision &&
          other.businessId == this.businessId &&
          other.profileClientUuid == this.profileClientUuid &&
          other.clientUuid == this.clientUuid &&
          other.serverId == this.serverId &&
          other.revisionNumber == this.revisionNumber &&
          other.templateDefinitionVersion == this.templateDefinitionVersion &&
          other.valuesJson == this.valuesJson &&
          other.notes == this.notes &&
          other.measuredAt == this.measuredAt &&
          other.syncState == this.syncState &&
          other.syncError == this.syncError &&
          other.createdAt == this.createdAt);
}

class LocalMeasurementRevisionsCompanion
    extends UpdateCompanion<LocalMeasurementRevision> {
  final Value<String> businessId;
  final Value<String> profileClientUuid;
  final Value<String> clientUuid;
  final Value<String?> serverId;
  final Value<int> revisionNumber;
  final Value<int> templateDefinitionVersion;
  final Value<String> valuesJson;
  final Value<String?> notes;
  final Value<DateTime> measuredAt;
  final Value<String> syncState;
  final Value<String?> syncError;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LocalMeasurementRevisionsCompanion({
    this.businessId = const Value.absent(),
    this.profileClientUuid = const Value.absent(),
    this.clientUuid = const Value.absent(),
    this.serverId = const Value.absent(),
    this.revisionNumber = const Value.absent(),
    this.templateDefinitionVersion = const Value.absent(),
    this.valuesJson = const Value.absent(),
    this.notes = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.syncState = const Value.absent(),
    this.syncError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMeasurementRevisionsCompanion.insert({
    required String businessId,
    required String profileClientUuid,
    required String clientUuid,
    this.serverId = const Value.absent(),
    this.revisionNumber = const Value.absent(),
    required int templateDefinitionVersion,
    required String valuesJson,
    this.notes = const Value.absent(),
    required DateTime measuredAt,
    this.syncState = const Value.absent(),
    this.syncError = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : businessId = Value(businessId),
       profileClientUuid = Value(profileClientUuid),
       clientUuid = Value(clientUuid),
       templateDefinitionVersion = Value(templateDefinitionVersion),
       valuesJson = Value(valuesJson),
       measuredAt = Value(measuredAt),
       createdAt = Value(createdAt);
  static Insertable<LocalMeasurementRevision> custom({
    Expression<String>? businessId,
    Expression<String>? profileClientUuid,
    Expression<String>? clientUuid,
    Expression<String>? serverId,
    Expression<int>? revisionNumber,
    Expression<int>? templateDefinitionVersion,
    Expression<String>? valuesJson,
    Expression<String>? notes,
    Expression<DateTime>? measuredAt,
    Expression<String>? syncState,
    Expression<String>? syncError,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (businessId != null) 'business_id': businessId,
      if (profileClientUuid != null) 'profile_client_uuid': profileClientUuid,
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (serverId != null) 'server_id': serverId,
      if (revisionNumber != null) 'revision_number': revisionNumber,
      if (templateDefinitionVersion != null)
        'template_definition_version': templateDefinitionVersion,
      if (valuesJson != null) 'values_json': valuesJson,
      if (notes != null) 'notes': notes,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (syncState != null) 'sync_state': syncState,
      if (syncError != null) 'sync_error': syncError,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMeasurementRevisionsCompanion copyWith({
    Value<String>? businessId,
    Value<String>? profileClientUuid,
    Value<String>? clientUuid,
    Value<String?>? serverId,
    Value<int>? revisionNumber,
    Value<int>? templateDefinitionVersion,
    Value<String>? valuesJson,
    Value<String?>? notes,
    Value<DateTime>? measuredAt,
    Value<String>? syncState,
    Value<String?>? syncError,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LocalMeasurementRevisionsCompanion(
      businessId: businessId ?? this.businessId,
      profileClientUuid: profileClientUuid ?? this.profileClientUuid,
      clientUuid: clientUuid ?? this.clientUuid,
      serverId: serverId ?? this.serverId,
      revisionNumber: revisionNumber ?? this.revisionNumber,
      templateDefinitionVersion:
          templateDefinitionVersion ?? this.templateDefinitionVersion,
      valuesJson: valuesJson ?? this.valuesJson,
      notes: notes ?? this.notes,
      measuredAt: measuredAt ?? this.measuredAt,
      syncState: syncState ?? this.syncState,
      syncError: syncError ?? this.syncError,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (profileClientUuid.present) {
      map['profile_client_uuid'] = Variable<String>(profileClientUuid.value);
    }
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (revisionNumber.present) {
      map['revision_number'] = Variable<int>(revisionNumber.value);
    }
    if (templateDefinitionVersion.present) {
      map['template_definition_version'] = Variable<int>(
        templateDefinitionVersion.value,
      );
    }
    if (valuesJson.present) {
      map['values_json'] = Variable<String>(valuesJson.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<DateTime>(measuredAt.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (syncError.present) {
      map['sync_error'] = Variable<String>(syncError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMeasurementRevisionsCompanion(')
          ..write('businessId: $businessId, ')
          ..write('profileClientUuid: $profileClientUuid, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('serverId: $serverId, ')
          ..write('revisionNumber: $revisionNumber, ')
          ..write('templateDefinitionVersion: $templateDefinitionVersion, ')
          ..write('valuesJson: $valuesJson, ')
          ..write('notes: $notes, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('syncState: $syncState, ')
          ..write('syncError: $syncError, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MeasurementSyncOperationsTable extends MeasurementSyncOperations
    with TableInfo<$MeasurementSyncOperationsTable, MeasurementSyncOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeasurementSyncOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operationUuidMeta = const VerificationMeta(
    'operationUuid',
  );
  @override
  late final GeneratedColumn<String> operationUuid = GeneratedColumn<String>(
    'operation_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessIdMeta = const VerificationMeta(
    'businessId',
  );
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
    'business_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerClientUuidMeta =
      const VerificationMeta('customerClientUuid');
  @override
  late final GeneratedColumn<String> customerClientUuid =
      GeneratedColumn<String>(
        'customer_client_uuid',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _profileClientUuidMeta = const VerificationMeta(
    'profileClientUuid',
  );
  @override
  late final GeneratedColumn<String> profileClientUuid =
      GeneratedColumn<String>(
        'profile_client_uuid',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _revisionClientUuidMeta =
      const VerificationMeta('revisionClientUuid');
  @override
  late final GeneratedColumn<String> revisionClientUuid =
      GeneratedColumn<String>(
        'revision_client_uuid',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseVersionMeta = const VerificationMeta(
    'baseVersion',
  );
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
    'base_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    operationUuid,
    businessId,
    customerClientUuid,
    profileClientUuid,
    revisionClientUuid,
    action,
    baseVersion,
    payloadJson,
    createdAt,
    attemptCount,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'measurement_sync_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<MeasurementSyncOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operation_uuid')) {
      context.handle(
        _operationUuidMeta,
        operationUuid.isAcceptableOrUnknown(
          data['operation_uuid']!,
          _operationUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationUuidMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
        _businessIdMeta,
        businessId.isAcceptableOrUnknown(data['business_id']!, _businessIdMeta),
      );
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('customer_client_uuid')) {
      context.handle(
        _customerClientUuidMeta,
        customerClientUuid.isAcceptableOrUnknown(
          data['customer_client_uuid']!,
          _customerClientUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerClientUuidMeta);
    }
    if (data.containsKey('profile_client_uuid')) {
      context.handle(
        _profileClientUuidMeta,
        profileClientUuid.isAcceptableOrUnknown(
          data['profile_client_uuid']!,
          _profileClientUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_profileClientUuidMeta);
    }
    if (data.containsKey('revision_client_uuid')) {
      context.handle(
        _revisionClientUuidMeta,
        revisionClientUuid.isAcceptableOrUnknown(
          data['revision_client_uuid']!,
          _revisionClientUuidMeta,
        ),
      );
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('base_version')) {
      context.handle(
        _baseVersionMeta,
        baseVersion.isAcceptableOrUnknown(
          data['base_version']!,
          _baseVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baseVersionMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operationUuid};
  @override
  MeasurementSyncOperation map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeasurementSyncOperation(
      operationUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_uuid'],
      )!,
      businessId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_id'],
      )!,
      customerClientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_client_uuid'],
      )!,
      profileClientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_client_uuid'],
      )!,
      revisionClientUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revision_client_uuid'],
      ),
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      baseVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_version'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $MeasurementSyncOperationsTable createAlias(String alias) {
    return $MeasurementSyncOperationsTable(attachedDatabase, alias);
  }
}

class MeasurementSyncOperation extends DataClass
    implements Insertable<MeasurementSyncOperation> {
  final String operationUuid;
  final String businessId;
  final String customerClientUuid;
  final String profileClientUuid;
  final String? revisionClientUuid;
  final String action;
  final int baseVersion;
  final String payloadJson;
  final DateTime createdAt;
  final int attemptCount;
  final String? lastError;
  const MeasurementSyncOperation({
    required this.operationUuid,
    required this.businessId,
    required this.customerClientUuid,
    required this.profileClientUuid,
    this.revisionClientUuid,
    required this.action,
    required this.baseVersion,
    required this.payloadJson,
    required this.createdAt,
    required this.attemptCount,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operation_uuid'] = Variable<String>(operationUuid);
    map['business_id'] = Variable<String>(businessId);
    map['customer_client_uuid'] = Variable<String>(customerClientUuid);
    map['profile_client_uuid'] = Variable<String>(profileClientUuid);
    if (!nullToAbsent || revisionClientUuid != null) {
      map['revision_client_uuid'] = Variable<String>(revisionClientUuid);
    }
    map['action'] = Variable<String>(action);
    map['base_version'] = Variable<int>(baseVersion);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  MeasurementSyncOperationsCompanion toCompanion(bool nullToAbsent) {
    return MeasurementSyncOperationsCompanion(
      operationUuid: Value(operationUuid),
      businessId: Value(businessId),
      customerClientUuid: Value(customerClientUuid),
      profileClientUuid: Value(profileClientUuid),
      revisionClientUuid: revisionClientUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(revisionClientUuid),
      action: Value(action),
      baseVersion: Value(baseVersion),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      attemptCount: Value(attemptCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory MeasurementSyncOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeasurementSyncOperation(
      operationUuid: serializer.fromJson<String>(json['operationUuid']),
      businessId: serializer.fromJson<String>(json['businessId']),
      customerClientUuid: serializer.fromJson<String>(
        json['customerClientUuid'],
      ),
      profileClientUuid: serializer.fromJson<String>(json['profileClientUuid']),
      revisionClientUuid: serializer.fromJson<String?>(
        json['revisionClientUuid'],
      ),
      action: serializer.fromJson<String>(json['action']),
      baseVersion: serializer.fromJson<int>(json['baseVersion']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operationUuid': serializer.toJson<String>(operationUuid),
      'businessId': serializer.toJson<String>(businessId),
      'customerClientUuid': serializer.toJson<String>(customerClientUuid),
      'profileClientUuid': serializer.toJson<String>(profileClientUuid),
      'revisionClientUuid': serializer.toJson<String?>(revisionClientUuid),
      'action': serializer.toJson<String>(action),
      'baseVersion': serializer.toJson<int>(baseVersion),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  MeasurementSyncOperation copyWith({
    String? operationUuid,
    String? businessId,
    String? customerClientUuid,
    String? profileClientUuid,
    Value<String?> revisionClientUuid = const Value.absent(),
    String? action,
    int? baseVersion,
    String? payloadJson,
    DateTime? createdAt,
    int? attemptCount,
    Value<String?> lastError = const Value.absent(),
  }) => MeasurementSyncOperation(
    operationUuid: operationUuid ?? this.operationUuid,
    businessId: businessId ?? this.businessId,
    customerClientUuid: customerClientUuid ?? this.customerClientUuid,
    profileClientUuid: profileClientUuid ?? this.profileClientUuid,
    revisionClientUuid: revisionClientUuid.present
        ? revisionClientUuid.value
        : this.revisionClientUuid,
    action: action ?? this.action,
    baseVersion: baseVersion ?? this.baseVersion,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    attemptCount: attemptCount ?? this.attemptCount,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  MeasurementSyncOperation copyWithCompanion(
    MeasurementSyncOperationsCompanion data,
  ) {
    return MeasurementSyncOperation(
      operationUuid: data.operationUuid.present
          ? data.operationUuid.value
          : this.operationUuid,
      businessId: data.businessId.present
          ? data.businessId.value
          : this.businessId,
      customerClientUuid: data.customerClientUuid.present
          ? data.customerClientUuid.value
          : this.customerClientUuid,
      profileClientUuid: data.profileClientUuid.present
          ? data.profileClientUuid.value
          : this.profileClientUuid,
      revisionClientUuid: data.revisionClientUuid.present
          ? data.revisionClientUuid.value
          : this.revisionClientUuid,
      action: data.action.present ? data.action.value : this.action,
      baseVersion: data.baseVersion.present
          ? data.baseVersion.value
          : this.baseVersion,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementSyncOperation(')
          ..write('operationUuid: $operationUuid, ')
          ..write('businessId: $businessId, ')
          ..write('customerClientUuid: $customerClientUuid, ')
          ..write('profileClientUuid: $profileClientUuid, ')
          ..write('revisionClientUuid: $revisionClientUuid, ')
          ..write('action: $action, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    operationUuid,
    businessId,
    customerClientUuid,
    profileClientUuid,
    revisionClientUuid,
    action,
    baseVersion,
    payloadJson,
    createdAt,
    attemptCount,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeasurementSyncOperation &&
          other.operationUuid == this.operationUuid &&
          other.businessId == this.businessId &&
          other.customerClientUuid == this.customerClientUuid &&
          other.profileClientUuid == this.profileClientUuid &&
          other.revisionClientUuid == this.revisionClientUuid &&
          other.action == this.action &&
          other.baseVersion == this.baseVersion &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.attemptCount == this.attemptCount &&
          other.lastError == this.lastError);
}

class MeasurementSyncOperationsCompanion
    extends UpdateCompanion<MeasurementSyncOperation> {
  final Value<String> operationUuid;
  final Value<String> businessId;
  final Value<String> customerClientUuid;
  final Value<String> profileClientUuid;
  final Value<String?> revisionClientUuid;
  final Value<String> action;
  final Value<int> baseVersion;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<int> attemptCount;
  final Value<String?> lastError;
  final Value<int> rowid;
  const MeasurementSyncOperationsCompanion({
    this.operationUuid = const Value.absent(),
    this.businessId = const Value.absent(),
    this.customerClientUuid = const Value.absent(),
    this.profileClientUuid = const Value.absent(),
    this.revisionClientUuid = const Value.absent(),
    this.action = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeasurementSyncOperationsCompanion.insert({
    required String operationUuid,
    required String businessId,
    required String customerClientUuid,
    required String profileClientUuid,
    this.revisionClientUuid = const Value.absent(),
    required String action,
    required int baseVersion,
    required String payloadJson,
    required DateTime createdAt,
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : operationUuid = Value(operationUuid),
       businessId = Value(businessId),
       customerClientUuid = Value(customerClientUuid),
       profileClientUuid = Value(profileClientUuid),
       action = Value(action),
       baseVersion = Value(baseVersion),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<MeasurementSyncOperation> custom({
    Expression<String>? operationUuid,
    Expression<String>? businessId,
    Expression<String>? customerClientUuid,
    Expression<String>? profileClientUuid,
    Expression<String>? revisionClientUuid,
    Expression<String>? action,
    Expression<int>? baseVersion,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<int>? attemptCount,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operationUuid != null) 'operation_uuid': operationUuid,
      if (businessId != null) 'business_id': businessId,
      if (customerClientUuid != null)
        'customer_client_uuid': customerClientUuid,
      if (profileClientUuid != null) 'profile_client_uuid': profileClientUuid,
      if (revisionClientUuid != null)
        'revision_client_uuid': revisionClientUuid,
      if (action != null) 'action': action,
      if (baseVersion != null) 'base_version': baseVersion,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeasurementSyncOperationsCompanion copyWith({
    Value<String>? operationUuid,
    Value<String>? businessId,
    Value<String>? customerClientUuid,
    Value<String>? profileClientUuid,
    Value<String?>? revisionClientUuid,
    Value<String>? action,
    Value<int>? baseVersion,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<int>? attemptCount,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return MeasurementSyncOperationsCompanion(
      operationUuid: operationUuid ?? this.operationUuid,
      businessId: businessId ?? this.businessId,
      customerClientUuid: customerClientUuid ?? this.customerClientUuid,
      profileClientUuid: profileClientUuid ?? this.profileClientUuid,
      revisionClientUuid: revisionClientUuid ?? this.revisionClientUuid,
      action: action ?? this.action,
      baseVersion: baseVersion ?? this.baseVersion,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operationUuid.present) {
      map['operation_uuid'] = Variable<String>(operationUuid.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (customerClientUuid.present) {
      map['customer_client_uuid'] = Variable<String>(customerClientUuid.value);
    }
    if (profileClientUuid.present) {
      map['profile_client_uuid'] = Variable<String>(profileClientUuid.value);
    }
    if (revisionClientUuid.present) {
      map['revision_client_uuid'] = Variable<String>(revisionClientUuid.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeasurementSyncOperationsCompanion(')
          ..write('operationUuid: $operationUuid, ')
          ..write('businessId: $businessId, ')
          ..write('customerClientUuid: $customerClientUuid, ')
          ..write('profileClientUuid: $profileClientUuid, ')
          ..write('revisionClientUuid: $revisionClientUuid, ')
          ..write('action: $action, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppMetadataTable appMetadata = $AppMetadataTable(this);
  late final $LocalCustomersTable localCustomers = $LocalCustomersTable(this);
  late final $CustomerSyncOperationsTable customerSyncOperations =
      $CustomerSyncOperationsTable(this);
  late final $LocalMeasurementTemplatesTable localMeasurementTemplates =
      $LocalMeasurementTemplatesTable(this);
  late final $LocalMeasurementProfilesTable localMeasurementProfiles =
      $LocalMeasurementProfilesTable(this);
  late final $LocalMeasurementRevisionsTable localMeasurementRevisions =
      $LocalMeasurementRevisionsTable(this);
  late final $MeasurementSyncOperationsTable measurementSyncOperations =
      $MeasurementSyncOperationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appMetadata,
    localCustomers,
    customerSyncOperations,
    localMeasurementTemplates,
    localMeasurementProfiles,
    localMeasurementRevisions,
    measurementSyncOperations,
  ];
}

typedef $$AppMetadataTableCreateCompanionBuilder =
    AppMetadataCompanion Function({
      required String key,
      required String value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AppMetadataTableUpdateCompanionBuilder =
    AppMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppMetadataTable> {
  $$AppMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppMetadataTable,
          AppMetadataData,
          $$AppMetadataTableFilterComposer,
          $$AppMetadataTableOrderingComposer,
          $$AppMetadataTableAnnotationComposer,
          $$AppMetadataTableCreateCompanionBuilder,
          $$AppMetadataTableUpdateCompanionBuilder,
          (
            AppMetadataData,
            BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataData>,
          ),
          AppMetadataData,
          PrefetchHooks Function()
        > {
  $$AppMetadataTableTableManager(_$AppDatabase db, $AppMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppMetadataCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppMetadataTable,
      AppMetadataData,
      $$AppMetadataTableFilterComposer,
      $$AppMetadataTableOrderingComposer,
      $$AppMetadataTableAnnotationComposer,
      $$AppMetadataTableCreateCompanionBuilder,
      $$AppMetadataTableUpdateCompanionBuilder,
      (
        AppMetadataData,
        BaseReferences<_$AppDatabase, $AppMetadataTable, AppMetadataData>,
      ),
      AppMetadataData,
      PrefetchHooks Function()
    >;
typedef $$LocalCustomersTableCreateCompanionBuilder =
    LocalCustomersCompanion Function({
      required String businessId,
      required String clientUuid,
      Value<String?> serverId,
      required String name,
      Value<String?> phoneE164,
      Value<String?> alternatePhoneE164,
      Value<String?> address,
      Value<String?> notes,
      Value<String?> photoLocalPath,
      Value<String?> photoUrl,
      Value<String> status,
      Value<int> serverVersion,
      Value<String> syncState,
      Value<String?> syncError,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> serverUpdatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$LocalCustomersTableUpdateCompanionBuilder =
    LocalCustomersCompanion Function({
      Value<String> businessId,
      Value<String> clientUuid,
      Value<String?> serverId,
      Value<String> name,
      Value<String?> phoneE164,
      Value<String?> alternatePhoneE164,
      Value<String?> address,
      Value<String?> notes,
      Value<String?> photoLocalPath,
      Value<String?> photoUrl,
      Value<String> status,
      Value<int> serverVersion,
      Value<String> syncState,
      Value<String?> syncError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> serverUpdatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

class $$LocalCustomersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCustomersTable> {
  $$LocalCustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneE164 => $composableBuilder(
    column: $table.phoneE164,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alternatePhoneE164 => $composableBuilder(
    column: $table.alternatePhoneE164,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoLocalPath => $composableBuilder(
    column: $table.photoLocalPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalCustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCustomersTable> {
  $$LocalCustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneE164 => $composableBuilder(
    column: $table.phoneE164,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alternatePhoneE164 => $composableBuilder(
    column: $table.alternatePhoneE164,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoLocalPath => $composableBuilder(
    column: $table.photoLocalPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalCustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCustomersTable> {
  $$LocalCustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phoneE164 =>
      $composableBuilder(column: $table.phoneE164, builder: (column) => column);

  GeneratedColumn<String> get alternatePhoneE164 => $composableBuilder(
    column: $table.alternatePhoneE164,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get photoLocalPath => $composableBuilder(
    column: $table.photoLocalPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );
}

class $$LocalCustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalCustomersTable,
          LocalCustomer,
          $$LocalCustomersTableFilterComposer,
          $$LocalCustomersTableOrderingComposer,
          $$LocalCustomersTableAnnotationComposer,
          $$LocalCustomersTableCreateCompanionBuilder,
          $$LocalCustomersTableUpdateCompanionBuilder,
          (
            LocalCustomer,
            BaseReferences<_$AppDatabase, $LocalCustomersTable, LocalCustomer>,
          ),
          LocalCustomer,
          PrefetchHooks Function()
        > {
  $$LocalCustomersTableTableManager(
    _$AppDatabase db,
    $LocalCustomersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> businessId = const Value.absent(),
                Value<String> clientUuid = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phoneE164 = const Value.absent(),
                Value<String?> alternatePhoneE164 = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoLocalPath = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> serverVersion = const Value.absent(),
                Value<String> syncState = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCustomersCompanion(
                businessId: businessId,
                clientUuid: clientUuid,
                serverId: serverId,
                name: name,
                phoneE164: phoneE164,
                alternatePhoneE164: alternatePhoneE164,
                address: address,
                notes: notes,
                photoLocalPath: photoLocalPath,
                photoUrl: photoUrl,
                status: status,
                serverVersion: serverVersion,
                syncState: syncState,
                syncError: syncError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String businessId,
                required String clientUuid,
                Value<String?> serverId = const Value.absent(),
                required String name,
                Value<String?> phoneE164 = const Value.absent(),
                Value<String?> alternatePhoneE164 = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> photoLocalPath = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> serverVersion = const Value.absent(),
                Value<String> syncState = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalCustomersCompanion.insert(
                businessId: businessId,
                clientUuid: clientUuid,
                serverId: serverId,
                name: name,
                phoneE164: phoneE164,
                alternatePhoneE164: alternatePhoneE164,
                address: address,
                notes: notes,
                photoLocalPath: photoLocalPath,
                photoUrl: photoUrl,
                status: status,
                serverVersion: serverVersion,
                syncState: syncState,
                syncError: syncError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalCustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalCustomersTable,
      LocalCustomer,
      $$LocalCustomersTableFilterComposer,
      $$LocalCustomersTableOrderingComposer,
      $$LocalCustomersTableAnnotationComposer,
      $$LocalCustomersTableCreateCompanionBuilder,
      $$LocalCustomersTableUpdateCompanionBuilder,
      (
        LocalCustomer,
        BaseReferences<_$AppDatabase, $LocalCustomersTable, LocalCustomer>,
      ),
      LocalCustomer,
      PrefetchHooks Function()
    >;
typedef $$CustomerSyncOperationsTableCreateCompanionBuilder =
    CustomerSyncOperationsCompanion Function({
      required String operationUuid,
      required String businessId,
      required String customerClientUuid,
      required String action,
      required int baseVersion,
      required String payloadJson,
      required DateTime createdAt,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$CustomerSyncOperationsTableUpdateCompanionBuilder =
    CustomerSyncOperationsCompanion Function({
      Value<String> operationUuid,
      Value<String> businessId,
      Value<String> customerClientUuid,
      Value<String> action,
      Value<int> baseVersion,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$CustomerSyncOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomerSyncOperationsTable> {
  $$CustomerSyncOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationUuid => $composableBuilder(
    column: $table.operationUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerClientUuid => $composableBuilder(
    column: $table.customerClientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomerSyncOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomerSyncOperationsTable> {
  $$CustomerSyncOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationUuid => $composableBuilder(
    column: $table.operationUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerClientUuid => $composableBuilder(
    column: $table.customerClientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomerSyncOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomerSyncOperationsTable> {
  $$CustomerSyncOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationUuid => $composableBuilder(
    column: $table.operationUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerClientUuid => $composableBuilder(
    column: $table.customerClientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$CustomerSyncOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomerSyncOperationsTable,
          CustomerSyncOperation,
          $$CustomerSyncOperationsTableFilterComposer,
          $$CustomerSyncOperationsTableOrderingComposer,
          $$CustomerSyncOperationsTableAnnotationComposer,
          $$CustomerSyncOperationsTableCreateCompanionBuilder,
          $$CustomerSyncOperationsTableUpdateCompanionBuilder,
          (
            CustomerSyncOperation,
            BaseReferences<
              _$AppDatabase,
              $CustomerSyncOperationsTable,
              CustomerSyncOperation
            >,
          ),
          CustomerSyncOperation,
          PrefetchHooks Function()
        > {
  $$CustomerSyncOperationsTableTableManager(
    _$AppDatabase db,
    $CustomerSyncOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomerSyncOperationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CustomerSyncOperationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CustomerSyncOperationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> operationUuid = const Value.absent(),
                Value<String> businessId = const Value.absent(),
                Value<String> customerClientUuid = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<int> baseVersion = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomerSyncOperationsCompanion(
                operationUuid: operationUuid,
                businessId: businessId,
                customerClientUuid: customerClientUuid,
                action: action,
                baseVersion: baseVersion,
                payloadJson: payloadJson,
                createdAt: createdAt,
                attemptCount: attemptCount,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationUuid,
                required String businessId,
                required String customerClientUuid,
                required String action,
                required int baseVersion,
                required String payloadJson,
                required DateTime createdAt,
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomerSyncOperationsCompanion.insert(
                operationUuid: operationUuid,
                businessId: businessId,
                customerClientUuid: customerClientUuid,
                action: action,
                baseVersion: baseVersion,
                payloadJson: payloadJson,
                createdAt: createdAt,
                attemptCount: attemptCount,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomerSyncOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomerSyncOperationsTable,
      CustomerSyncOperation,
      $$CustomerSyncOperationsTableFilterComposer,
      $$CustomerSyncOperationsTableOrderingComposer,
      $$CustomerSyncOperationsTableAnnotationComposer,
      $$CustomerSyncOperationsTableCreateCompanionBuilder,
      $$CustomerSyncOperationsTableUpdateCompanionBuilder,
      (
        CustomerSyncOperation,
        BaseReferences<
          _$AppDatabase,
          $CustomerSyncOperationsTable,
          CustomerSyncOperation
        >,
      ),
      CustomerSyncOperation,
      PrefetchHooks Function()
    >;
typedef $$LocalMeasurementTemplatesTableCreateCompanionBuilder =
    LocalMeasurementTemplatesCompanion Function({
      required String businessScope,
      required String clientUuid,
      Value<String?> serverId,
      Value<String?> systemCode,
      required String source,
      Value<String?> sourceTemplateUuid,
      required String name,
      Value<String?> nameUr,
      Value<String?> nameRomanUr,
      required String category,
      Value<String> defaultUnit,
      Value<String?> description,
      Value<String> status,
      Value<int> serverVersion,
      Value<int> definitionVersion,
      required String fieldsJson,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$LocalMeasurementTemplatesTableUpdateCompanionBuilder =
    LocalMeasurementTemplatesCompanion Function({
      Value<String> businessScope,
      Value<String> clientUuid,
      Value<String?> serverId,
      Value<String?> systemCode,
      Value<String> source,
      Value<String?> sourceTemplateUuid,
      Value<String> name,
      Value<String?> nameUr,
      Value<String?> nameRomanUr,
      Value<String> category,
      Value<String> defaultUnit,
      Value<String?> description,
      Value<String> status,
      Value<int> serverVersion,
      Value<int> definitionVersion,
      Value<String> fieldsJson,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

class $$LocalMeasurementTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMeasurementTemplatesTable> {
  $$LocalMeasurementTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get businessScope => $composableBuilder(
    column: $table.businessScope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get systemCode => $composableBuilder(
    column: $table.systemCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceTemplateUuid => $composableBuilder(
    column: $table.sourceTemplateUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameUr => $composableBuilder(
    column: $table.nameUr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameRomanUr => $composableBuilder(
    column: $table.nameRomanUr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultUnit => $composableBuilder(
    column: $table.defaultUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get definitionVersion => $composableBuilder(
    column: $table.definitionVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalMeasurementTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMeasurementTemplatesTable> {
  $$LocalMeasurementTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get businessScope => $composableBuilder(
    column: $table.businessScope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get systemCode => $composableBuilder(
    column: $table.systemCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceTemplateUuid => $composableBuilder(
    column: $table.sourceTemplateUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameUr => $composableBuilder(
    column: $table.nameUr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameRomanUr => $composableBuilder(
    column: $table.nameRomanUr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultUnit => $composableBuilder(
    column: $table.defaultUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get definitionVersion => $composableBuilder(
    column: $table.definitionVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalMeasurementTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMeasurementTemplatesTable> {
  $$LocalMeasurementTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get businessScope => $composableBuilder(
    column: $table.businessScope,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get systemCode => $composableBuilder(
    column: $table.systemCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get sourceTemplateUuid => $composableBuilder(
    column: $table.sourceTemplateUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameUr =>
      $composableBuilder(column: $table.nameUr, builder: (column) => column);

  GeneratedColumn<String> get nameRomanUr => $composableBuilder(
    column: $table.nameRomanUr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get defaultUnit => $composableBuilder(
    column: $table.defaultUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get definitionVersion => $composableBuilder(
    column: $table.definitionVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldsJson => $composableBuilder(
    column: $table.fieldsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );
}

class $$LocalMeasurementTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalMeasurementTemplatesTable,
          LocalMeasurementTemplate,
          $$LocalMeasurementTemplatesTableFilterComposer,
          $$LocalMeasurementTemplatesTableOrderingComposer,
          $$LocalMeasurementTemplatesTableAnnotationComposer,
          $$LocalMeasurementTemplatesTableCreateCompanionBuilder,
          $$LocalMeasurementTemplatesTableUpdateCompanionBuilder,
          (
            LocalMeasurementTemplate,
            BaseReferences<
              _$AppDatabase,
              $LocalMeasurementTemplatesTable,
              LocalMeasurementTemplate
            >,
          ),
          LocalMeasurementTemplate,
          PrefetchHooks Function()
        > {
  $$LocalMeasurementTemplatesTableTableManager(
    _$AppDatabase db,
    $LocalMeasurementTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMeasurementTemplatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalMeasurementTemplatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalMeasurementTemplatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> businessScope = const Value.absent(),
                Value<String> clientUuid = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String?> systemCode = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> sourceTemplateUuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameUr = const Value.absent(),
                Value<String?> nameRomanUr = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> defaultUnit = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> serverVersion = const Value.absent(),
                Value<int> definitionVersion = const Value.absent(),
                Value<String> fieldsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMeasurementTemplatesCompanion(
                businessScope: businessScope,
                clientUuid: clientUuid,
                serverId: serverId,
                systemCode: systemCode,
                source: source,
                sourceTemplateUuid: sourceTemplateUuid,
                name: name,
                nameUr: nameUr,
                nameRomanUr: nameRomanUr,
                category: category,
                defaultUnit: defaultUnit,
                description: description,
                status: status,
                serverVersion: serverVersion,
                definitionVersion: definitionVersion,
                fieldsJson: fieldsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String businessScope,
                required String clientUuid,
                Value<String?> serverId = const Value.absent(),
                Value<String?> systemCode = const Value.absent(),
                required String source,
                Value<String?> sourceTemplateUuid = const Value.absent(),
                required String name,
                Value<String?> nameUr = const Value.absent(),
                Value<String?> nameRomanUr = const Value.absent(),
                required String category,
                Value<String> defaultUnit = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> serverVersion = const Value.absent(),
                Value<int> definitionVersion = const Value.absent(),
                required String fieldsJson,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMeasurementTemplatesCompanion.insert(
                businessScope: businessScope,
                clientUuid: clientUuid,
                serverId: serverId,
                systemCode: systemCode,
                source: source,
                sourceTemplateUuid: sourceTemplateUuid,
                name: name,
                nameUr: nameUr,
                nameRomanUr: nameRomanUr,
                category: category,
                defaultUnit: defaultUnit,
                description: description,
                status: status,
                serverVersion: serverVersion,
                definitionVersion: definitionVersion,
                fieldsJson: fieldsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalMeasurementTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalMeasurementTemplatesTable,
      LocalMeasurementTemplate,
      $$LocalMeasurementTemplatesTableFilterComposer,
      $$LocalMeasurementTemplatesTableOrderingComposer,
      $$LocalMeasurementTemplatesTableAnnotationComposer,
      $$LocalMeasurementTemplatesTableCreateCompanionBuilder,
      $$LocalMeasurementTemplatesTableUpdateCompanionBuilder,
      (
        LocalMeasurementTemplate,
        BaseReferences<
          _$AppDatabase,
          $LocalMeasurementTemplatesTable,
          LocalMeasurementTemplate
        >,
      ),
      LocalMeasurementTemplate,
      PrefetchHooks Function()
    >;
typedef $$LocalMeasurementProfilesTableCreateCompanionBuilder =
    LocalMeasurementProfilesCompanion Function({
      required String businessId,
      required String customerClientUuid,
      required String clientUuid,
      Value<String?> serverId,
      required String templateClientUuid,
      required int templateDefinitionVersion,
      required String name,
      Value<String> preferredUnit,
      Value<String?> notes,
      Value<String> status,
      Value<int> serverVersion,
      Value<int> latestRevisionNumber,
      Value<String> syncState,
      Value<String?> syncError,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> serverUpdatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$LocalMeasurementProfilesTableUpdateCompanionBuilder =
    LocalMeasurementProfilesCompanion Function({
      Value<String> businessId,
      Value<String> customerClientUuid,
      Value<String> clientUuid,
      Value<String?> serverId,
      Value<String> templateClientUuid,
      Value<int> templateDefinitionVersion,
      Value<String> name,
      Value<String> preferredUnit,
      Value<String?> notes,
      Value<String> status,
      Value<int> serverVersion,
      Value<int> latestRevisionNumber,
      Value<String> syncState,
      Value<String?> syncError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> serverUpdatedAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

class $$LocalMeasurementProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMeasurementProfilesTable> {
  $$LocalMeasurementProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerClientUuid => $composableBuilder(
    column: $table.customerClientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateClientUuid => $composableBuilder(
    column: $table.templateClientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get templateDefinitionVersion => $composableBuilder(
    column: $table.templateDefinitionVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredUnit => $composableBuilder(
    column: $table.preferredUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get latestRevisionNumber => $composableBuilder(
    column: $table.latestRevisionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalMeasurementProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMeasurementProfilesTable> {
  $$LocalMeasurementProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerClientUuid => $composableBuilder(
    column: $table.customerClientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateClientUuid => $composableBuilder(
    column: $table.templateClientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get templateDefinitionVersion => $composableBuilder(
    column: $table.templateDefinitionVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredUnit => $composableBuilder(
    column: $table.preferredUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get latestRevisionNumber => $composableBuilder(
    column: $table.latestRevisionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalMeasurementProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMeasurementProfilesTable> {
  $$LocalMeasurementProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerClientUuid => $composableBuilder(
    column: $table.customerClientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get templateClientUuid => $composableBuilder(
    column: $table.templateClientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get templateDefinitionVersion => $composableBuilder(
    column: $table.templateDefinitionVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get preferredUnit => $composableBuilder(
    column: $table.preferredUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get serverVersion => $composableBuilder(
    column: $table.serverVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get latestRevisionNumber => $composableBuilder(
    column: $table.latestRevisionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
    column: $table.serverUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );
}

class $$LocalMeasurementProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalMeasurementProfilesTable,
          LocalMeasurementProfile,
          $$LocalMeasurementProfilesTableFilterComposer,
          $$LocalMeasurementProfilesTableOrderingComposer,
          $$LocalMeasurementProfilesTableAnnotationComposer,
          $$LocalMeasurementProfilesTableCreateCompanionBuilder,
          $$LocalMeasurementProfilesTableUpdateCompanionBuilder,
          (
            LocalMeasurementProfile,
            BaseReferences<
              _$AppDatabase,
              $LocalMeasurementProfilesTable,
              LocalMeasurementProfile
            >,
          ),
          LocalMeasurementProfile,
          PrefetchHooks Function()
        > {
  $$LocalMeasurementProfilesTableTableManager(
    _$AppDatabase db,
    $LocalMeasurementProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMeasurementProfilesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalMeasurementProfilesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalMeasurementProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> businessId = const Value.absent(),
                Value<String> customerClientUuid = const Value.absent(),
                Value<String> clientUuid = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<String> templateClientUuid = const Value.absent(),
                Value<int> templateDefinitionVersion = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> preferredUnit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> serverVersion = const Value.absent(),
                Value<int> latestRevisionNumber = const Value.absent(),
                Value<String> syncState = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMeasurementProfilesCompanion(
                businessId: businessId,
                customerClientUuid: customerClientUuid,
                clientUuid: clientUuid,
                serverId: serverId,
                templateClientUuid: templateClientUuid,
                templateDefinitionVersion: templateDefinitionVersion,
                name: name,
                preferredUnit: preferredUnit,
                notes: notes,
                status: status,
                serverVersion: serverVersion,
                latestRevisionNumber: latestRevisionNumber,
                syncState: syncState,
                syncError: syncError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String businessId,
                required String customerClientUuid,
                required String clientUuid,
                Value<String?> serverId = const Value.absent(),
                required String templateClientUuid,
                required int templateDefinitionVersion,
                required String name,
                Value<String> preferredUnit = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> serverVersion = const Value.absent(),
                Value<int> latestRevisionNumber = const Value.absent(),
                Value<String> syncState = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> serverUpdatedAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMeasurementProfilesCompanion.insert(
                businessId: businessId,
                customerClientUuid: customerClientUuid,
                clientUuid: clientUuid,
                serverId: serverId,
                templateClientUuid: templateClientUuid,
                templateDefinitionVersion: templateDefinitionVersion,
                name: name,
                preferredUnit: preferredUnit,
                notes: notes,
                status: status,
                serverVersion: serverVersion,
                latestRevisionNumber: latestRevisionNumber,
                syncState: syncState,
                syncError: syncError,
                createdAt: createdAt,
                updatedAt: updatedAt,
                serverUpdatedAt: serverUpdatedAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalMeasurementProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalMeasurementProfilesTable,
      LocalMeasurementProfile,
      $$LocalMeasurementProfilesTableFilterComposer,
      $$LocalMeasurementProfilesTableOrderingComposer,
      $$LocalMeasurementProfilesTableAnnotationComposer,
      $$LocalMeasurementProfilesTableCreateCompanionBuilder,
      $$LocalMeasurementProfilesTableUpdateCompanionBuilder,
      (
        LocalMeasurementProfile,
        BaseReferences<
          _$AppDatabase,
          $LocalMeasurementProfilesTable,
          LocalMeasurementProfile
        >,
      ),
      LocalMeasurementProfile,
      PrefetchHooks Function()
    >;
typedef $$LocalMeasurementRevisionsTableCreateCompanionBuilder =
    LocalMeasurementRevisionsCompanion Function({
      required String businessId,
      required String profileClientUuid,
      required String clientUuid,
      Value<String?> serverId,
      Value<int> revisionNumber,
      required int templateDefinitionVersion,
      required String valuesJson,
      Value<String?> notes,
      required DateTime measuredAt,
      Value<String> syncState,
      Value<String?> syncError,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$LocalMeasurementRevisionsTableUpdateCompanionBuilder =
    LocalMeasurementRevisionsCompanion Function({
      Value<String> businessId,
      Value<String> profileClientUuid,
      Value<String> clientUuid,
      Value<String?> serverId,
      Value<int> revisionNumber,
      Value<int> templateDefinitionVersion,
      Value<String> valuesJson,
      Value<String?> notes,
      Value<DateTime> measuredAt,
      Value<String> syncState,
      Value<String?> syncError,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LocalMeasurementRevisionsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMeasurementRevisionsTable> {
  $$LocalMeasurementRevisionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileClientUuid => $composableBuilder(
    column: $table.profileClientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get revisionNumber => $composableBuilder(
    column: $table.revisionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get templateDefinitionVersion => $composableBuilder(
    column: $table.templateDefinitionVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalMeasurementRevisionsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMeasurementRevisionsTable> {
  $$LocalMeasurementRevisionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileClientUuid => $composableBuilder(
    column: $table.profileClientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get revisionNumber => $composableBuilder(
    column: $table.revisionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get templateDefinitionVersion => $composableBuilder(
    column: $table.templateDefinitionVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncError => $composableBuilder(
    column: $table.syncError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalMeasurementRevisionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMeasurementRevisionsTable> {
  $$LocalMeasurementRevisionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileClientUuid => $composableBuilder(
    column: $table.profileClientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientUuid => $composableBuilder(
    column: $table.clientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get revisionNumber => $composableBuilder(
    column: $table.revisionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get templateDefinitionVersion => $composableBuilder(
    column: $table.templateDefinitionVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get valuesJson => $composableBuilder(
    column: $table.valuesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<String> get syncError =>
      $composableBuilder(column: $table.syncError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalMeasurementRevisionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalMeasurementRevisionsTable,
          LocalMeasurementRevision,
          $$LocalMeasurementRevisionsTableFilterComposer,
          $$LocalMeasurementRevisionsTableOrderingComposer,
          $$LocalMeasurementRevisionsTableAnnotationComposer,
          $$LocalMeasurementRevisionsTableCreateCompanionBuilder,
          $$LocalMeasurementRevisionsTableUpdateCompanionBuilder,
          (
            LocalMeasurementRevision,
            BaseReferences<
              _$AppDatabase,
              $LocalMeasurementRevisionsTable,
              LocalMeasurementRevision
            >,
          ),
          LocalMeasurementRevision,
          PrefetchHooks Function()
        > {
  $$LocalMeasurementRevisionsTableTableManager(
    _$AppDatabase db,
    $LocalMeasurementRevisionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMeasurementRevisionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LocalMeasurementRevisionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalMeasurementRevisionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> businessId = const Value.absent(),
                Value<String> profileClientUuid = const Value.absent(),
                Value<String> clientUuid = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<int> revisionNumber = const Value.absent(),
                Value<int> templateDefinitionVersion = const Value.absent(),
                Value<String> valuesJson = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> measuredAt = const Value.absent(),
                Value<String> syncState = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalMeasurementRevisionsCompanion(
                businessId: businessId,
                profileClientUuid: profileClientUuid,
                clientUuid: clientUuid,
                serverId: serverId,
                revisionNumber: revisionNumber,
                templateDefinitionVersion: templateDefinitionVersion,
                valuesJson: valuesJson,
                notes: notes,
                measuredAt: measuredAt,
                syncState: syncState,
                syncError: syncError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String businessId,
                required String profileClientUuid,
                required String clientUuid,
                Value<String?> serverId = const Value.absent(),
                Value<int> revisionNumber = const Value.absent(),
                required int templateDefinitionVersion,
                required String valuesJson,
                Value<String?> notes = const Value.absent(),
                required DateTime measuredAt,
                Value<String> syncState = const Value.absent(),
                Value<String?> syncError = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalMeasurementRevisionsCompanion.insert(
                businessId: businessId,
                profileClientUuid: profileClientUuid,
                clientUuid: clientUuid,
                serverId: serverId,
                revisionNumber: revisionNumber,
                templateDefinitionVersion: templateDefinitionVersion,
                valuesJson: valuesJson,
                notes: notes,
                measuredAt: measuredAt,
                syncState: syncState,
                syncError: syncError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalMeasurementRevisionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalMeasurementRevisionsTable,
      LocalMeasurementRevision,
      $$LocalMeasurementRevisionsTableFilterComposer,
      $$LocalMeasurementRevisionsTableOrderingComposer,
      $$LocalMeasurementRevisionsTableAnnotationComposer,
      $$LocalMeasurementRevisionsTableCreateCompanionBuilder,
      $$LocalMeasurementRevisionsTableUpdateCompanionBuilder,
      (
        LocalMeasurementRevision,
        BaseReferences<
          _$AppDatabase,
          $LocalMeasurementRevisionsTable,
          LocalMeasurementRevision
        >,
      ),
      LocalMeasurementRevision,
      PrefetchHooks Function()
    >;
typedef $$MeasurementSyncOperationsTableCreateCompanionBuilder =
    MeasurementSyncOperationsCompanion Function({
      required String operationUuid,
      required String businessId,
      required String customerClientUuid,
      required String profileClientUuid,
      Value<String?> revisionClientUuid,
      required String action,
      required int baseVersion,
      required String payloadJson,
      required DateTime createdAt,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$MeasurementSyncOperationsTableUpdateCompanionBuilder =
    MeasurementSyncOperationsCompanion Function({
      Value<String> operationUuid,
      Value<String> businessId,
      Value<String> customerClientUuid,
      Value<String> profileClientUuid,
      Value<String?> revisionClientUuid,
      Value<String> action,
      Value<int> baseVersion,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$MeasurementSyncOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $MeasurementSyncOperationsTable> {
  $$MeasurementSyncOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operationUuid => $composableBuilder(
    column: $table.operationUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerClientUuid => $composableBuilder(
    column: $table.customerClientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileClientUuid => $composableBuilder(
    column: $table.profileClientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revisionClientUuid => $composableBuilder(
    column: $table.revisionClientUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MeasurementSyncOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MeasurementSyncOperationsTable> {
  $$MeasurementSyncOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operationUuid => $composableBuilder(
    column: $table.operationUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerClientUuid => $composableBuilder(
    column: $table.customerClientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileClientUuid => $composableBuilder(
    column: $table.profileClientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revisionClientUuid => $composableBuilder(
    column: $table.revisionClientUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MeasurementSyncOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MeasurementSyncOperationsTable> {
  $$MeasurementSyncOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operationUuid => $composableBuilder(
    column: $table.operationUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerClientUuid => $composableBuilder(
    column: $table.customerClientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get profileClientUuid => $composableBuilder(
    column: $table.profileClientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get revisionClientUuid => $composableBuilder(
    column: $table.revisionClientUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$MeasurementSyncOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MeasurementSyncOperationsTable,
          MeasurementSyncOperation,
          $$MeasurementSyncOperationsTableFilterComposer,
          $$MeasurementSyncOperationsTableOrderingComposer,
          $$MeasurementSyncOperationsTableAnnotationComposer,
          $$MeasurementSyncOperationsTableCreateCompanionBuilder,
          $$MeasurementSyncOperationsTableUpdateCompanionBuilder,
          (
            MeasurementSyncOperation,
            BaseReferences<
              _$AppDatabase,
              $MeasurementSyncOperationsTable,
              MeasurementSyncOperation
            >,
          ),
          MeasurementSyncOperation,
          PrefetchHooks Function()
        > {
  $$MeasurementSyncOperationsTableTableManager(
    _$AppDatabase db,
    $MeasurementSyncOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeasurementSyncOperationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MeasurementSyncOperationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MeasurementSyncOperationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> operationUuid = const Value.absent(),
                Value<String> businessId = const Value.absent(),
                Value<String> customerClientUuid = const Value.absent(),
                Value<String> profileClientUuid = const Value.absent(),
                Value<String?> revisionClientUuid = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<int> baseVersion = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeasurementSyncOperationsCompanion(
                operationUuid: operationUuid,
                businessId: businessId,
                customerClientUuid: customerClientUuid,
                profileClientUuid: profileClientUuid,
                revisionClientUuid: revisionClientUuid,
                action: action,
                baseVersion: baseVersion,
                payloadJson: payloadJson,
                createdAt: createdAt,
                attemptCount: attemptCount,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String operationUuid,
                required String businessId,
                required String customerClientUuid,
                required String profileClientUuid,
                Value<String?> revisionClientUuid = const Value.absent(),
                required String action,
                required int baseVersion,
                required String payloadJson,
                required DateTime createdAt,
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MeasurementSyncOperationsCompanion.insert(
                operationUuid: operationUuid,
                businessId: businessId,
                customerClientUuid: customerClientUuid,
                profileClientUuid: profileClientUuid,
                revisionClientUuid: revisionClientUuid,
                action: action,
                baseVersion: baseVersion,
                payloadJson: payloadJson,
                createdAt: createdAt,
                attemptCount: attemptCount,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MeasurementSyncOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MeasurementSyncOperationsTable,
      MeasurementSyncOperation,
      $$MeasurementSyncOperationsTableFilterComposer,
      $$MeasurementSyncOperationsTableOrderingComposer,
      $$MeasurementSyncOperationsTableAnnotationComposer,
      $$MeasurementSyncOperationsTableCreateCompanionBuilder,
      $$MeasurementSyncOperationsTableUpdateCompanionBuilder,
      (
        MeasurementSyncOperation,
        BaseReferences<
          _$AppDatabase,
          $MeasurementSyncOperationsTable,
          MeasurementSyncOperation
        >,
      ),
      MeasurementSyncOperation,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppMetadataTableTableManager get appMetadata =>
      $$AppMetadataTableTableManager(_db, _db.appMetadata);
  $$LocalCustomersTableTableManager get localCustomers =>
      $$LocalCustomersTableTableManager(_db, _db.localCustomers);
  $$CustomerSyncOperationsTableTableManager get customerSyncOperations =>
      $$CustomerSyncOperationsTableTableManager(
        _db,
        _db.customerSyncOperations,
      );
  $$LocalMeasurementTemplatesTableTableManager get localMeasurementTemplates =>
      $$LocalMeasurementTemplatesTableTableManager(
        _db,
        _db.localMeasurementTemplates,
      );
  $$LocalMeasurementProfilesTableTableManager get localMeasurementProfiles =>
      $$LocalMeasurementProfilesTableTableManager(
        _db,
        _db.localMeasurementProfiles,
      );
  $$LocalMeasurementRevisionsTableTableManager get localMeasurementRevisions =>
      $$LocalMeasurementRevisionsTableTableManager(
        _db,
        _db.localMeasurementRevisions,
      );
  $$MeasurementSyncOperationsTableTableManager get measurementSyncOperations =>
      $$MeasurementSyncOperationsTableTableManager(
        _db,
        _db.measurementSyncOperations,
      );
}
