import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postgress_table_form/src/models/postgress_data_type.dart';
import 'package:postgress_table_form/src/models/table_definition_model/table_definiton_model.dart';
import 'package:postgress_table_form/src/widgets/dynamic_table_view.dart';

import 'tableDef.dart';
import 'table_data.dart';

void main() {
  // Setup test data
  late TableDefinitionModel tableDefinition;
  late List<Map<String, dynamic>> data;

  setUp(() {
    // Initialize the table definition from the test data
    tableDefinition = TableDefinitionModel.fromList(tableDef);

    // Convert the table data to the expected format
    data = List<Map<String, dynamic>>.from(tableData);
  });

  testWidgets('DynamicTableView renders correctly',
      (WidgetTester tester) async {
    // Build our widget and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DynamicTableView(
            tableDefinition: tableDefinition,
            data: data,
          ),
        ),
      ),
    );

    // Verify that the widget renders
    expect(find.byType(DynamicTableView), findsOneWidget);
    expect(find.byType(DataTable), findsOneWidget);

    // Verify that columns are rendered
    for (var column in tableDefinition.columns) {
      expect(find.text(column.columnName), findsOneWidget);
    }
  });

  testWidgets('DynamicTableView renders data cells correctly',
      (WidgetTester tester) async {
    // Build our widget and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DynamicTableView(
            tableDefinition: tableDefinition,
            data: data,
          ),
        ),
      ),
    );

    // Check for some specific data values
    // This assumes the first row has these values - adjust based on your test data
    if (data.isNotEmpty) {
      // Check for a numeric value
      if (data[0]['incident_id'] != null) {
        expect(find.text(data[0]['incident_id'].toString()), findsOneWidget);
      }

      // Check for a text value
      if (data[0]['state'] != null) {
        expect(find.text(data[0]['state'].toString()), findsOneWidget);
      }
    }

    // Verify NULL values are displayed correctly
    if (data.any((row) => row.values.any((value) => value == null))) {
      expect(find.text('NULL'), findsAtLeastNWidgets(1));
    }
  });

  testWidgets('DynamicTableView handles different data types correctly',
      (WidgetTester tester) async {
    // Create a test row with various data types
    final testData = [
      {
        'integer_value': 42,
        'decimal_value': 3.14,
        'text_value': 'Test Text',
        'date_value': '2023-01-01',
        'timestamp_value': '2023-01-01 12:34:56',
        'boolean_value': true,
        'null_value': null,
      }
    ];

    // Create a matching table definition
    // final testTableDefinition = TableDefinitionModel(
    //   tableName: 'test_table',
    //   columns: [
    //     ColumnDefinitionModel(
    //       columnName: 'integer_value',
    //       dataType: PostgresDataType.integer,
    //       isNullable: 'NO',
    //     ),
    //     ColumnDefinitionModel(
    //       columnName: 'decimal_value',
    //       dataType: PostgresDataType.numeric,
    //       isNullable: 'NO',
    //     ),
    //     ColumnDefinitionModel(
    //       columnName: 'text_value',
    //       dataType: PostgresDataType.text,
    //       isNullable: 'NO',
    //     ),
    //     ColumnDefinitionModel(
    //       columnName: 'date_value',
    //       dataType: PostgresDataType.date,
    //       isNullable: 'NO',
    //     ),
    //     ColumnDefinitionModel(
    //       columnName: 'timestamp_value',
    //       dataType: PostgresDataType.timestamp,
    //       isNullable: 'NO',
    //     ),
    //     ColumnDefinitionModel(
    //       columnName: 'boolean_value',
    //       dataType: PostgresDataType.boolean,
    //       isNullable: 'NO',
    //     ),
    //     ColumnDefinitionModel(
    //       columnName: 'null_value',
    //       dataType: PostgresDataType.text,
    //       isNullable: 'YES',
    //     ),
    //   ],
    // );

    // Build our widget with the test data
    // await tester.pumpWidget(
    //   MaterialApp(
    //     home: Scaffold(
    //       body: DynamicTableView(
    //         tableDefinition: testTableDefinition,
    //         data: testData,
    //       ),
    //     ),
    //   ),
    // );

    // Verify that the widget renders
    expect(find.byType(DynamicTableView), findsOneWidget);

    // Check for specific data type renderings
    expect(find.text('42'), findsOneWidget);
    expect(find.text('3.14'), findsOneWidget);
    expect(find.text('Test Text'), findsOneWidget);
    expect(find.text('2023-01-01'), findsOneWidget);
    expect(find.text('2023-01-01 12:34:56'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text('NULL'), findsOneWidget);
  });
}

class ColumnDefinition {
  final String columnName;
  final PostgresDataType dataType;
  final String isNullable;
  final String? columnDefault;
  final List<String>? enumOptions;

  ColumnDefinition({
    required this.columnName,
    required this.dataType,
    required this.isNullable,
    this.columnDefault,
    this.enumOptions,
  });
}
