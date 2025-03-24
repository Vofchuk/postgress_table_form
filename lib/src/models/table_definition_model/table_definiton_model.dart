import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';

part 'table_definiton_model.freezed.dart';
part 'table_definiton_model.g.dart';

@freezed
class TableDefinitionModel with _$TableDefinitionModel {
  const factory TableDefinitionModel({
    // required String tableName,
    required List<ColumnDefinitionModel> columns,
    @Default({}) Map<String, TableDefinitionModel> joinedTables,
  }) = _TableDefinitionModel;

  const TableDefinitionModel._();

  factory TableDefinitionModel.fromJson(Map<String, dynamic> json) =>
      _$TableDefinitionModelFromJson(json);

  factory TableDefinitionModel.fromList(List<dynamic> list) =>
      TableDefinitionModel.fromJson({
        'columns': list,
      });

  /// Adds a joined table definition
  TableDefinitionModel addJoinedTable(
      String key, TableDefinitionModel joinedTable) {
    final updatedJoinedTables =
        Map<String, TableDefinitionModel>.from(joinedTables);
    updatedJoinedTables[key] = joinedTable;
    return copyWith(joinedTables: updatedJoinedTables);
  }

  /// Gets all columns including joined table columns with prefixed names
  List<ColumnDefinitionModel> getAllColumns() {
    final allColumns = List<ColumnDefinitionModel>.from(columns);

    joinedTables.forEach((prefix, tableDefinition) {
      final joinedColumns = tableDefinition.columns.map((column) {
        return column.copyWith(
          columnName: '$prefix.${column.columnName}',
        );
      });
      allColumns.addAll(joinedColumns);
    });

    return allColumns;
  }

  // static TableDefinitionModel fromJsonList(
  //     String tableName, List<dynamic> jsonList) {
  //   return TableDefinitionModel.fromJson({
  //     'tableName': tableName,
  //     'columns': jsonList,
  //   });
  // }
}
