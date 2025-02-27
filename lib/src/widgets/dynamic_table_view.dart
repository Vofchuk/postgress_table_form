import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgress_table_form/src/models/postgress_data_type.dart';
import 'package:postgress_table_form/src/models/table_definition_model/table_definiton_model.dart';

class DynamicTableView extends StatelessWidget {
  final TableDefinitionModel tableDefinition;
  final List<Map<String, dynamic>> data;
  const DynamicTableView({
    super.key,
    required this.tableDefinition,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: _buildColumns(),
          rows: _buildRows(),
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
          dataRowMinHeight: 48,
          dataRowMaxHeight: 72,
          columnSpacing: 24,
          horizontalMargin: 16,
          showCheckboxColumn: false,
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return tableDefinition.columns.map((column) {
      return DataColumn(
        label: Expanded(
          child: Text(
            column.columnName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        tooltip:
            '${column.dataType.toString().split('.').last} ${column.isNullable == 'YES' ? '(nullable)' : ''}',
      );
    }).toList();
  }

  List<DataRow> _buildRows() {
    return data.map((rowData) {
      return DataRow(
        cells: tableDefinition.columns.map((column) {
          final value = rowData[column.columnName];
          return DataCell(_buildCellWidget(value, column.dataType));
        }).toList(),
      );
    }).toList();
  }

  Widget _buildCellWidget(dynamic value, PostgresDataType dataType) {
    if (value == null) {
      return const Text('NULL',
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey));
    }

    try {
      switch (dataType) {
        // Numeric Types
        case PostgresDataType.smallint:
        case PostgresDataType.integer:
        case PostgresDataType.bigint:
        case PostgresDataType.serial:
        case PostgresDataType.bigserial:
          return Text(value.toString());

        case PostgresDataType.decimal:
        case PostgresDataType.numeric:
        case PostgresDataType.real:
        case PostgresDataType.doublePrecision:
          final num numValue =
              value is num ? value : num.tryParse(value.toString()) ?? 0;
          return Text(NumberFormat('#,##0.00').format(numValue));

        // Character Types
        case PostgresDataType.characterVarying:
        case PostgresDataType.character:
        case PostgresDataType.text:
          return Text(value.toString());

        // Date & Time Types
        case PostgresDataType.date:
          DateTime? date;
          if (value is DateTime) {
            date = value;
          } else if (value is String) {
            try {
              date = DateTime.parse(value);
            } catch (_) {
              return Text(value);
            }
          }
          return date != null
              ? Text(DateFormat('yyyy-MM-dd').format(date))
              : Text(value.toString());

        case PostgresDataType.timestamp:
        case PostgresDataType.timestampWithTimeZone:
          DateTime? date;
          if (value is DateTime) {
            date = value;
          } else if (value is String) {
            try {
              date = DateTime.parse(value);
            } catch (_) {
              return Text(value);
            }
          }
          return date != null
              ? Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(date))
              : Text(value.toString());

        case PostgresDataType.time:
        case PostgresDataType.timeWithTimeZone:
          return Text(value.toString());

        case PostgresDataType.interval:
          return Text(value.toString());

        // Boolean Type
        case PostgresDataType.boolean:
          bool boolValue;
          if (value is bool) {
            boolValue = value;
          } else if (value is String) {
            boolValue =
                value.toLowerCase() == 'true' || value == 't' || value == '1';
          } else if (value is num) {
            boolValue = value != 0;
          } else {
            return Text(value.toString());
          }

          return Icon(
            boolValue ? Icons.check_circle : Icons.cancel,
            color: boolValue ? Colors.green : Colors.red,
          );

        // UUID Type
        case PostgresDataType.uuid:
          return Text(value.toString(),
              style: const TextStyle(fontFamily: 'monospace'));

        // JSON Types
        case PostgresDataType.json:
        case PostgresDataType.jsonb:
          return Tooltip(
            message: value.toString(),
            child: const Text('JSON',
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline)),
          );

        // Array Types
        case PostgresDataType.integerArray:
        case PostgresDataType.textArray:
        case PostgresDataType.uuidArray:
          List<dynamic> array;
          if (value is List) {
            array = value;
          } else if (value is String &&
              (value.startsWith('{') && value.endsWith('}'))) {
            // Handle PostgreSQL array format like '{1,2,3}'
            array = value.substring(1, value.length - 1).split(',');
          } else if (value is String) {
            // Try to handle other string formats
            array = value.split(',');
          } else {
            return Text(value.toString());
          }

          return Tooltip(
            message: array.join(', '),
            child: Text('Array[${array.length}]',
                style: const TextStyle(color: Colors.blue)),
          );

        // Geometric Types
        case PostgresDataType.point:
        case PostgresDataType.line:
        case PostgresDataType.lseg:
        case PostgresDataType.box:
        case PostgresDataType.path:
        case PostgresDataType.polygon:
        case PostgresDataType.circle:
          return Tooltip(
            message: value.toString(),
            child:
                const Text('Geometric', style: TextStyle(color: Colors.purple)),
          );

        // Custom Types
        case PostgresDataType.userDefined:
          return Text(value.toString());

        default:
          return Text(value.toString());
      }
    } catch (e) {
      // Fallback for any errors during rendering
      return Text(
        value.toString(),
        style: const TextStyle(color: Colors.red),
      );
    }
  }
}
