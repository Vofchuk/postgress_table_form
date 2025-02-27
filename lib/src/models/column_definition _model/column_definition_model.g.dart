// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'column_definition_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ColumnDefinitionModelImpl _$$ColumnDefinitionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ColumnDefinitionModelImpl(
      columnName: json['column_name'] as String,
      dataType: const PostgresDataTypeConverter()
          .fromJson(json['data_type'] as String),
      isNullable: json['is_nullable'] as String,
      columnDefault: json['column_default'],
      enumOptions: (json['enum_options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ColumnDefinitionModelImplToJson(
        _$ColumnDefinitionModelImpl instance) =>
    <String, dynamic>{
      'column_name': instance.columnName,
      'data_type': const PostgresDataTypeConverter().toJson(instance.dataType),
      'is_nullable': instance.isNullable,
      'column_default': instance.columnDefault,
      'enum_options': instance.enumOptions,
    };
