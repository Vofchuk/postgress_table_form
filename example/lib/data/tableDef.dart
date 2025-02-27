import 'dart:convert';

List<dynamic> tableDef = json.decode('''[
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
]''');
