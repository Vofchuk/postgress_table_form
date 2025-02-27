import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:postgress_table_form/src/models/table_definition_model/table_definiton_model.dart';

void main() {
  test('test TableDefinitionModel serialization from JSON', () {
    final jsonString = '''
[
    {
        "column_name": "incident_id",
        "data_type": "bigint",
        "is_nullable": "NO",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "occurrence_date",
        "data_type": "timestamp with time zone",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "complaint_id",
        "data_type": "bigint",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "observations",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "attendance_location",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "call_origin",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "zip_code",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "state",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "city",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "address",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "number",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "complement",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "neighborhood",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "reference",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "lat",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "lng",
        "data_type": "numeric",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "patient_location",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "caller_phone",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "caller_name",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "is_caller_patient",
        "data_type": "boolean",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "complementary_phone",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "caller_observation",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "multiple_victims",
        "data_type": "boolean",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "patient_unknown",
        "data_type": "boolean",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "patient_name",
        "data_type": "text",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "location",
        "data_type": "USER-DEFINED",
        "is_nullable": "NO",
        "column_default": null,
        "enum_options": null
    },
    {
        "column_name": "status",
        "data_type": "USER-DEFINED",
        "is_nullable": "YES",
        "column_default": null,
        "enum_options": [
            "NEW",
            "DISPATCHED",
            "TRANSPORTING",
            "AT HOSPITAL",
            "RESOLVED",
            "CLOSED"
        ]
    }
]
''';

    // Parse the JSON string to a List of Maps
    final List<dynamic> jsonList = json.decode(jsonString);

    // Create a TableDefinitionModel with the columns
    final table = TableDefinitionModel.fromJsonList('incidents', jsonList);

    // Test that the model was created correctly
    expect(table.tableName, 'incidents');
    expect(table.columns.length, 27);

    // // Test specific columns
    // expect(tableDefinition.columns[0].columnName, 'incident_id');
    // expect(tableDefinition.columns[0].dataType, PostgresDataType.bigint);
    // expect(tableDefinition.columns[0].isNullable, 'NO');

    // expect(tableDefinition.columns[1].columnName, 'occurrence_date');
    // expect(tableDefinition.columns[1].dataType,
    //     PostgresDataType.timestampWithTimeZone);
    // expect(tableDefinition.columns[1].isNullable, 'YES');

    // // Test a column with enum options
    // expect(tableDefinition.columns[26].columnName, 'status');
    // expect(tableDefinition.columns[26].enumOptions.length, 6);
    // expect(tableDefinition.columns[26].enumOptions, [
    //   'NEW',
    //   'DISPATCHED',
    //   'TRANSPORTING',
    //   'AT HOSPITAL',
    //   'RESOLVED',
    //   'CLOSED'
    // ]);

    // Test serialization to JSON and back
  });
}
