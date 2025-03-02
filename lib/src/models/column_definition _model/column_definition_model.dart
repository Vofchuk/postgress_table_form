import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:postgress_table_form/src/models/postgress_data_type.dart';

part 'column_definition_model.freezed.dart';
part 'column_definition_model.g.dart';

/// Custom JSON converter for PostgresDataType
class PostgresDataTypeConverter
    implements JsonConverter<PostgresDataType, String> {
  const PostgresDataTypeConverter();

  @override
  PostgresDataType fromJson(String json) {
    return PostgresDataType.fromString(json);
  }

  @override
  String toJson(PostgresDataType dataType) {
    return dataType.toString().split('.').last;
  }
}

/// Custom JSON converter for YES/NO strings to boolean
class YesNoBooleanConverter implements JsonConverter<bool, String> {
  const YesNoBooleanConverter();

  @override
  bool fromJson(String json) {
    return json.toUpperCase() == 'YES';
  }

  @override
  String toJson(bool value) {
    return value ? 'YES' : 'NO';
  }
}

/// Model for foreign key information
@freezed
class ForeignKeyModel with _$ForeignKeyModel {
  const factory ForeignKeyModel({
    @JsonKey(name: 'referenced_schema') required String referencedSchema,
    @JsonKey(name: 'referenced_table') required String referencedTable,
    @JsonKey(name: 'referenced_column') required String referencedColumn,
  }) = _ForeignKeyModel;

  const ForeignKeyModel._();

  factory ForeignKeyModel.fromJson(Map<String, dynamic> json) =>
      _$ForeignKeyModelFromJson(json);
}

@freezed
class ColumnDefinitionModel with _$ColumnDefinitionModel {
  const factory ColumnDefinitionModel({
    @JsonKey(name: 'table_name') String? tableName,
    @JsonKey(name: 'column_name') required String columnName,
    @JsonKey(name: 'data_type')
    @PostgresDataTypeConverter()
    required PostgresDataType dataType,
    @JsonKey(name: 'is_nullable')
    @YesNoBooleanConverter()
    @Default(false)
    bool isNullable,
    @JsonKey(name: 'column_default') dynamic columnDefault,
    @JsonKey(name: 'character_maximum_length') int? characterMaximumLength,
    @JsonKey(name: 'is_identity')
    @YesNoBooleanConverter()
    @Default(false)
    bool isIdentity,
    @JsonKey(name: 'is_updatable')
    @YesNoBooleanConverter()
    @Default(true)
    bool isUpdatable,
    @JsonKey(name: 'enum_options') @Default([]) List<String> enumOptions,
    @JsonKey(name: 'foreign_key') ForeignKeyModel? foreignKey,
  }) = _ColumnDefinitionModel;

  const ColumnDefinitionModel._();

  factory ColumnDefinitionModel.fromJson(Map<String, dynamic> json) =>
      _$ColumnDefinitionModelFromJson(json);
}
