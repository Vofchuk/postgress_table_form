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

@freezed
class ColumnDefinitionModel with _$ColumnDefinitionModel {
  const factory ColumnDefinitionModel({
    @JsonKey(name: 'column_name') required String columnName,
    @JsonKey(name: 'data_type')
    @PostgresDataTypeConverter()
    required PostgresDataType dataType,
    @JsonKey(name: 'is_nullable') required String isNullable,
    @JsonKey(name: 'column_default') dynamic columnDefault,
    @JsonKey(name: 'enum_options') @Default([]) List<String> enumOptions,
  }) = _ColumnDefinitionModel;

  const ColumnDefinitionModel._();

  factory ColumnDefinitionModel.fromJson(Map<String, dynamic> json) =>
      _$ColumnDefinitionModelFromJson(json);
}
