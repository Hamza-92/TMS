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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppMetadataTable appMetadata = $AppMetadataTable(this);
  late final $LocalCustomersTable localCustomers = $LocalCustomersTable(this);
  late final $CustomerSyncOperationsTable customerSyncOperations =
      $CustomerSyncOperationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appMetadata,
    localCustomers,
    customerSyncOperations,
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
}
