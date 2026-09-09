import 'dart:convert';

import 'package:tailor_app/core/database/app_database.dart';

enum MeasurementSyncState {
  synced,
  pending,
  conflict;

  static MeasurementSyncState fromStorage(String value) => values.firstWhere(
    (item) => item.name == value,
    orElse: () => MeasurementSyncState.pending,
  );
}

class MeasurementFieldDefinition {
  const MeasurementFieldDefinition({
    required this.clientUuid,
    required this.key,
    required this.label,
    required this.section,
    required this.valueType,
    required this.unitType,
    required this.isRequired,
    required this.sortOrder,
    this.labelUr,
    this.labelRomanUr,
    this.minimumValueMm,
    this.maximumValueMm,
    this.helpText,
  });

  factory MeasurementFieldDefinition.fromJson(Map<String, dynamic> json) =>
      MeasurementFieldDefinition(
        clientUuid: json['client_uuid'] as String,
        key: json['field_key'] as String,
        label: json['label'] as String,
        labelUr: json['label_ur'] as String?,
        labelRomanUr: json['label_roman_ur'] as String?,
        section: json['section'] as String,
        valueType: json['value_type'] as String,
        unitType: json['unit_type'] as String,
        isRequired: json['is_required'] as bool? ?? false,
        minimumValueMm: _asDouble(json['minimum_value_mm']),
        maximumValueMm: _asDouble(json['maximum_value_mm']),
        sortOrder: json['sort_order'] as int? ?? 0,
        helpText: json['help_text'] as String?,
      );

  final String clientUuid;
  final String key;
  final String label;
  final String? labelUr;
  final String? labelRomanUr;
  final String section;
  final String valueType;
  final String unitType;
  final bool isRequired;
  final double? minimumValueMm;
  final double? maximumValueMm;
  final int sortOrder;
  final String? helpText;

  String localizedLabel(String languageCode, String? scriptCode) {
    if (languageCode == 'ur' && scriptCode != 'Latn') {
      return labelUr?.trim().isNotEmpty == true ? labelUr! : label;
    }
    if (languageCode == 'ur' && scriptCode == 'Latn') {
      return labelRomanUr?.trim().isNotEmpty == true ? labelRomanUr! : label;
    }
    return label;
  }

  Map<String, dynamic> toJson() => {
    'client_uuid': clientUuid,
    'field_key': key,
    'label': label,
    'label_ur': labelUr,
    'label_roman_ur': labelRomanUr,
    'section': section,
    'value_type': valueType,
    'unit_type': unitType,
    'is_required': isRequired,
    'minimum_value_mm': minimumValueMm,
    'maximum_value_mm': maximumValueMm,
    'sort_order': sortOrder,
    'help_text': helpText,
  };
}

class MeasurementTemplateRecord {
  const MeasurementTemplateRecord({
    required this.businessScope,
    required this.clientUuid,
    required this.source,
    required this.name,
    required this.category,
    required this.defaultUnit,
    required this.status,
    required this.serverVersion,
    required this.definitionVersion,
    required this.fields,
    required this.createdAt,
    required this.updatedAt,
    this.serverId,
    this.systemCode,
    this.sourceTemplateUuid,
    this.nameUr,
    this.nameRomanUr,
    this.description,
    this.archivedAt,
  });

  factory MeasurementTemplateRecord.fromLocal(LocalMeasurementTemplate row) =>
      MeasurementTemplateRecord(
        businessScope: row.businessScope,
        clientUuid: row.clientUuid,
        serverId: row.serverId,
        systemCode: row.systemCode,
        source: row.source,
        sourceTemplateUuid: row.sourceTemplateUuid,
        name: row.name,
        nameUr: row.nameUr,
        nameRomanUr: row.nameRomanUr,
        category: row.category,
        defaultUnit: row.defaultUnit,
        description: row.description,
        status: row.status,
        serverVersion: row.serverVersion,
        definitionVersion: row.definitionVersion,
        fields: _decodeList(row.fieldsJson)
            .map(MeasurementFieldDefinition.fromJson)
            .toList(growable: false),
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        archivedAt: row.archivedAt,
      );

  factory MeasurementTemplateRecord.fromRemote(
    String businessId,
    Map<String, dynamic> json,
  ) => MeasurementTemplateRecord(
    businessScope: businessId,
    clientUuid: json['client_uuid'] as String,
    serverId: json['id'] as String?,
    systemCode: json['system_code'] as String?,
    source: json['source'] as String,
    sourceTemplateUuid: json['source_template_uuid'] as String?,
    name: json['name'] as String,
    nameUr: json['name_ur'] as String?,
    nameRomanUr: json['name_roman_ur'] as String?,
    category: json['category'] as String,
    defaultUnit: json['default_unit'] as String,
    description: json['description'] as String?,
    status: json['status'] as String,
    serverVersion: json['version'] as int,
    definitionVersion: json['current_definition_version'] as int,
    fields: (json['fields'] as List? ?? const [])
        .map(
          (item) => MeasurementFieldDefinition.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList(growable: false),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
    archivedAt: _optionalDate(json['archived_at']),
  );

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
  final List<MeasurementFieldDefinition> fields;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;

  String localizedName(String languageCode, String? scriptCode) {
    if (languageCode == 'ur' && scriptCode != 'Latn') {
      return nameUr?.trim().isNotEmpty == true ? nameUr! : name;
    }
    if (languageCode == 'ur' && scriptCode == 'Latn') {
      return nameRomanUr?.trim().isNotEmpty == true ? nameRomanUr! : name;
    }
    return name;
  }
}

class MeasurementValueDraft {
  const MeasurementValueDraft({
    required this.fieldUuid,
    required this.value,
    this.unit,
  });

  final String fieldUuid;
  final Object value;
  final String? unit;

  Map<String, dynamic> toJson() => {
    'field_uuid': fieldUuid,
    'value': value,
    'unit': unit,
  };
}

class MeasurementProfileDraft {
  const MeasurementProfileDraft({
    required this.templateClientUuid,
    required this.templateDefinitionVersion,
    required this.name,
    required this.preferredUnit,
    this.notes,
  });

  final String templateClientUuid;
  final int templateDefinitionVersion;
  final String name;
  final String preferredUnit;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'template_client_uuid': templateClientUuid,
    'template_definition_version': templateDefinitionVersion,
    'name': name,
    'preferred_unit': preferredUnit,
    'notes': notes,
  };
}

class MeasurementProfileRecord {
  const MeasurementProfileRecord({
    required this.businessId,
    required this.customerClientUuid,
    required this.clientUuid,
    required this.templateClientUuid,
    required this.templateDefinitionVersion,
    required this.name,
    required this.preferredUnit,
    required this.status,
    required this.serverVersion,
    required this.latestRevisionNumber,
    required this.syncState,
    required this.createdAt,
    required this.updatedAt,
    this.serverId,
    this.notes,
    this.syncError,
    this.serverUpdatedAt,
    this.archivedAt,
  });

  factory MeasurementProfileRecord.fromLocal(LocalMeasurementProfile row) =>
      MeasurementProfileRecord(
        businessId: row.businessId,
        customerClientUuid: row.customerClientUuid,
        clientUuid: row.clientUuid,
        serverId: row.serverId,
        templateClientUuid: row.templateClientUuid,
        templateDefinitionVersion: row.templateDefinitionVersion,
        name: row.name,
        preferredUnit: row.preferredUnit,
        notes: row.notes,
        status: row.status,
        serverVersion: row.serverVersion,
        latestRevisionNumber: row.latestRevisionNumber,
        syncState: MeasurementSyncState.fromStorage(row.syncState),
        syncError: row.syncError,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        serverUpdatedAt: row.serverUpdatedAt,
        archivedAt: row.archivedAt,
      );

  factory MeasurementProfileRecord.fromRemote(Map<String, dynamic> json) {
    final template = Map<String, dynamic>.from(json['template'] as Map);
    final updatedAt = DateTime.parse(json['updated_at'] as String);
    return MeasurementProfileRecord(
      businessId: json['business_id'] as String,
      customerClientUuid: json['customer_client_uuid'] as String,
      clientUuid: json['client_uuid'] as String,
      serverId: json['id'] as String?,
      templateClientUuid: template['client_uuid'] as String,
      templateDefinitionVersion: json['template_definition_version'] as int,
      name: json['name'] as String,
      preferredUnit: json['preferred_unit'] as String,
      notes: json['notes'] as String?,
      status: json['status'] as String,
      serverVersion: json['version'] as int,
      latestRevisionNumber: json['latest_revision_number'] as int,
      syncState: MeasurementSyncState.synced,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: updatedAt,
      serverUpdatedAt: updatedAt,
      archivedAt: _optionalDate(json['archived_at']),
    );
  }

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
  final MeasurementSyncState syncState;
  final String? syncError;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? serverUpdatedAt;
  final DateTime? archivedAt;

  bool get isArchived => status == 'archived';
  bool get hasConflict => syncState == MeasurementSyncState.conflict;
}

class MeasurementRevisionRecord {
  const MeasurementRevisionRecord({
    required this.businessId,
    required this.profileClientUuid,
    required this.clientUuid,
    required this.revisionNumber,
    required this.templateDefinitionVersion,
    required this.values,
    required this.measuredAt,
    required this.syncState,
    required this.createdAt,
    this.serverId,
    this.notes,
    this.syncError,
  });

  factory MeasurementRevisionRecord.fromLocal(LocalMeasurementRevision row) =>
      MeasurementRevisionRecord(
        businessId: row.businessId,
        profileClientUuid: row.profileClientUuid,
        clientUuid: row.clientUuid,
        serverId: row.serverId,
        revisionNumber: row.revisionNumber,
        templateDefinitionVersion: row.templateDefinitionVersion,
        values: _decodeList(row.valuesJson),
        notes: row.notes,
        measuredAt: row.measuredAt,
        syncState: MeasurementSyncState.fromStorage(row.syncState),
        syncError: row.syncError,
        createdAt: row.createdAt,
      );

  factory MeasurementRevisionRecord.fromRemote(
    String businessId,
    String profileClientUuid,
    Map<String, dynamic> json,
  ) => MeasurementRevisionRecord(
    businessId: businessId,
    profileClientUuid: profileClientUuid,
    clientUuid: json['client_uuid'] as String,
    serverId: json['id'] as String?,
    revisionNumber: json['revision_number'] as int,
    templateDefinitionVersion: json['template_definition_version'] as int,
    values: (json['values'] as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false),
    notes: json['notes'] as String?,
    measuredAt: DateTime.parse(json['measured_at'] as String),
    syncState: MeasurementSyncState.synced,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  final String businessId;
  final String profileClientUuid;
  final String clientUuid;
  final String? serverId;
  final int revisionNumber;
  final int templateDefinitionVersion;
  final List<Map<String, dynamic>> values;
  final String? notes;
  final DateTime measuredAt;
  final MeasurementSyncState syncState;
  final String? syncError;
  final DateTime createdAt;
}

List<Map<String, dynamic>> _decodeList(String value) =>
    (jsonDecode(value) as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false);

double? _asDouble(Object? value) => value == null
    ? null
    : value is num
    ? value.toDouble()
    : double.tryParse(value.toString());

DateTime? _optionalDate(Object? value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value);
}
