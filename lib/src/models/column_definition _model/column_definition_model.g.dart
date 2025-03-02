// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'column_definition_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ForeignKeyModelImpl _$$ForeignKeyModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ForeignKeyModelImpl(
      referencedSchema: json['referenced_schema'] as String,
      referencedTable: json['referenced_table'] as String,
      referencedColumn: json['referenced_column'] as String,
    );

Map<String, dynamic> _$$ForeignKeyModelImplToJson(
        _$ForeignKeyModelImpl instance) =>
    <String, dynamic>{
      'referenced_schema': instance.referencedSchema,
      'referenced_table': instance.referencedTable,
      'referenced_column': instance.referencedColumn,
    };

_$ColumnDefinitionModelImpl _$$ColumnDefinitionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ColumnDefinitionModelImpl(
      tableName: json['table_name'] as String?,
      columnName: json['column_name'] as String,
      dataType: const PostgresDataTypeConverter()
          .fromJson(json['data_type'] as String),
      isNullable: json['is_nullable'] == null
          ? false
          : const YesNoBooleanConverter()
              .fromJson(json['is_nullable'] as String),
      columnDefault: json['column_default'],
      characterMaximumLength:
          (json['character_maximum_length'] as num?)?.toInt(),
      isIdentity: json['is_identity'] == null
          ? false
          : const YesNoBooleanConverter()
              .fromJson(json['is_identity'] as String),
      isUpdatable: json['is_updatable'] == null
          ? true
          : const YesNoBooleanConverter()
              .fromJson(json['is_updatable'] as String),
      enumOptions: (json['enum_options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      foreignKey: json['foreign_key'] == null
          ? null
          : ForeignKeyModel.fromJson(
              json['foreign_key'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ColumnDefinitionModelImplToJson(
        _$ColumnDefinitionModelImpl instance) =>
    <String, dynamic>{
      'table_name': instance.tableName,
      'column_name': instance.columnName,
      'data_type': const PostgresDataTypeConverter().toJson(instance.dataType),
      'is_nullable': const YesNoBooleanConverter().toJson(instance.isNullable),
      'column_default': instance.columnDefault,
      'character_maximum_length': instance.characterMaximumLength,
      'is_identity': const YesNoBooleanConverter().toJson(instance.isIdentity),
      'is_updatable':
          const YesNoBooleanConverter().toJson(instance.isUpdatable),
      'enum_options': instance.enumOptions,
      'foreign_key': instance.foreignKey,
    };
