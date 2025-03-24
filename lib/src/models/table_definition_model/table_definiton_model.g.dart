// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_definiton_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TableDefinitionModelImpl _$$TableDefinitionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TableDefinitionModelImpl(
      columns: (json['columns'] as List<dynamic>)
          .map((e) => ColumnDefinitionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      joinedTables: (json['joinedTables'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, TableDefinitionModel.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$TableDefinitionModelImplToJson(
        _$TableDefinitionModelImpl instance) =>
    <String, dynamic>{
      'columns': instance.columns,
      'joinedTables': instance.joinedTables,
    };
