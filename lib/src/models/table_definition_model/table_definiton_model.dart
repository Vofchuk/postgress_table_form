import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';

part 'table_definiton_model.freezed.dart';
part 'table_definiton_model.g.dart';

@freezed
class TableDefinitionModel with _$TableDefinitionModel {
  const factory TableDefinitionModel({
    required String tableName,
    required List<ColumnDefinitionModel> columns,
  }) = _TableDefinitionModel;

  const TableDefinitionModel._();

  factory TableDefinitionModel.fromJson(Map<String, dynamic> json) =>
      _$TableDefinitionModelFromJson(json);

  static TableDefinitionModel fromJsonList(
      String tableName, List<dynamic> jsonList) {
    return TableDefinitionModel.fromJson({
      'tableName': tableName,
      'columns': jsonList,
    });
  }
}
