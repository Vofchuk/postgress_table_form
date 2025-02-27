// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_definiton_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TableDefinitionModelImpl _$$TableDefinitionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TableDefinitionModelImpl(
      tableName: json['tableName'] as String,
      columns: (json['columns'] as List<dynamic>)
          .map((e) => ColumnDefinitionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TableDefinitionModelImplToJson(
        _$TableDefinitionModelImpl instance) =>
    <String, dynamic>{
      'tableName': instance.tableName,
      'columns': instance.columns,
    };
