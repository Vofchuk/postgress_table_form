import 'package:postgress_table_form/postgress_table_form.dart';

class DynamicTableData {
  final TableDefinitionModel tableDefinition;
  final List<Map<String, dynamic>> data;
  final int totalCount;
  final int currentPage;
  final int pageSize;

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;

  DynamicTableData({
    required this.tableDefinition,
    required this.data,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
  });
}
