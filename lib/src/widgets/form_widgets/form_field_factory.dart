import 'package:flutter/material.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';
import 'package:postgress_table_form/src/models/postgress_data_type.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_fields/array_form_field_widget.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_fields/boolean_form_field_widget.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_fields/date_form_field_widget.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_fields/date_time_form_field_widget.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_fields/decimal_form_field_widget.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_fields/dropdown_form_field_widget.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_fields/integer_form_field_widget.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_fields/json_form_field_widget.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_fields/text_form_field_widget.dart';

/// Factory class for creating form fields based on column type
class FormFieldFactory {
  /// Helper method to get form-level error message for a specific field
  static String getFormLevelErrorForField(
      String columnName, Map<String, String> formLevelErrors) {
    for (final entry in formLevelErrors.entries) {
      final fields = entry.key.split('_');
      if (fields.contains(columnName)) {
        return entry.value;
      }
    }
    return '';
  }

  /// Builds the appropriate form field widget based on the column data type
  static Widget buildFieldForColumn({
    required BuildContext context,
    required ColumnDefinitionModel column,
    required bool isReadonly,
    required Map<String, String> columnNameMapper,
    required Map<String, String> helpTexts,
    required Map<String, String> hintTexts,
    required Map<String, String? Function(dynamic)> customValidators,
    required Map<String, String> formLevelErrors,
    required Map<String, dynamic> formData,
    required Map<String, TextEditingController> controllers,
    required Map<String, Map<String, String>> dropdownOptionMappers,
    required Function(String, dynamic) onFieldValueChanged,
  }) {
    final isRequired = column.isNullable == false;
    // Use the columnNameMapper to get a custom display name, or fall back to the column name
    final displayName =
        columnNameMapper[column.columnName] ?? column.columnName;
    final label = '$displayName${isRequired ? ' *' : ''}';

    // Check if this field is involved in any form-level validation errors
    final bool hasFormLevelError = formLevelErrors.keys
        .any((key) => key.split('_').contains(column.columnName));

    switch (column.dataType) {
      case PostgresDataType.boolean:
        return BooleanFormFieldWidget(
          column: column,
          label: label,
          isReadonly: isReadonly,
          isRequired: isRequired,
          customValidator: customValidators[column.columnName],
          helpText: helpTexts[column.columnName],
          displayName: displayName,
          hasFormLevelError: hasFormLevelError,
          formLevelErrorMessage: hasFormLevelError
              ? getFormLevelErrorForField(column.columnName, formLevelErrors)
              : null,
          initialValue: formData[column.columnName] as bool? ?? false,
          onChanged: (value) {
            onFieldValueChanged(column.columnName, value);
          },
        );

      case PostgresDataType.date:
        return DateFormFieldWidget(
          column: column,
          label: label,
          isReadonly: isReadonly,
          isRequired: isRequired,
          customValidator: customValidators[column.columnName],
          helpText: helpTexts[column.columnName],
          displayName: displayName,
          hintText: hintTexts[column.columnName] ?? 'YYYY-MM-DD',
          hasFormLevelError: hasFormLevelError,
          formLevelErrorMessage: hasFormLevelError
              ? getFormLevelErrorForField(column.columnName, formLevelErrors)
              : null,
          controller: controllers[column.columnName]!,
          onChanged: (value) {
            onFieldValueChanged(column.columnName, value);
          },
        );

      case PostgresDataType.timestamp:
      case PostgresDataType.timestampWithTimeZone:
        return DateTimeFormFieldWidget(
          column: column,
          label: label,
          isReadonly: isReadonly,
          isRequired: isRequired,
          customValidator: customValidators[column.columnName],
          helpText: helpTexts[column.columnName],
          displayName: displayName,
          hintText: hintTexts[column.columnName] ?? 'YYYY-MM-DD HH:MM:SS',
          hasFormLevelError: hasFormLevelError,
          formLevelErrorMessage: hasFormLevelError
              ? getFormLevelErrorForField(column.columnName, formLevelErrors)
              : null,
          controller: controllers[column.columnName]!,
          onChanged: (value) {
            onFieldValueChanged(column.columnName, value);
          },
        );

      case PostgresDataType.integer:
      case PostgresDataType.smallint:
      case PostgresDataType.bigint:
      case PostgresDataType.serial:
      case PostgresDataType.bigserial:
        return IntegerFormFieldWidget(
          column: column,
          label: label,
          isReadonly: isReadonly,
          isRequired: isRequired,
          customValidator: customValidators[column.columnName],
          helpText: helpTexts[column.columnName],
          displayName: displayName,
          hintText: hintTexts[column.columnName] ?? 'Enter $displayName',
          hasFormLevelError: hasFormLevelError,
          formLevelErrorMessage: hasFormLevelError
              ? getFormLevelErrorForField(column.columnName, formLevelErrors)
              : null,
          controller: controllers[column.columnName]!,
          onChanged: (value) {
            onFieldValueChanged(column.columnName, value);
          },
        );

      case PostgresDataType.decimal:
      case PostgresDataType.numeric:
      case PostgresDataType.real:
      case PostgresDataType.doublePrecision:
        return DecimalFormFieldWidget(
          column: column,
          label: label,
          isReadonly: isReadonly,
          isRequired: isRequired,
          customValidator: customValidators[column.columnName],
          helpText: helpTexts[column.columnName],
          displayName: displayName,
          hintText: hintTexts[column.columnName] ?? 'Enter $displayName',
          hasFormLevelError: hasFormLevelError,
          formLevelErrorMessage: hasFormLevelError
              ? getFormLevelErrorForField(column.columnName, formLevelErrors)
              : null,
          controller: controllers[column.columnName]!,
          onChanged: (value) {
            onFieldValueChanged(column.columnName, value);
          },
        );

      case PostgresDataType.json:
      case PostgresDataType.jsonb:
        return JsonFormFieldWidget(
          column: column,
          label: label,
          isReadonly: isReadonly,
          isRequired: isRequired,
          customValidator: customValidators[column.columnName],
          helpText: helpTexts[column.columnName],
          displayName: displayName,
          hintText: hintTexts[column.columnName] ?? 'Enter JSON',
          hasFormLevelError: hasFormLevelError,
          formLevelErrorMessage: hasFormLevelError
              ? getFormLevelErrorForField(column.columnName, formLevelErrors)
              : null,
          controller: controllers[column.columnName]!,
          onChanged: (value) {
            onFieldValueChanged(column.columnName, value);
          },
        );

      case PostgresDataType.integerArray:
      case PostgresDataType.textArray:
      case PostgresDataType.uuidArray:
        return ArrayFormFieldWidget(
          column: column,
          label: label,
          isReadonly: isReadonly,
          isRequired: isRequired,
          customValidator: customValidators[column.columnName],
          helpText: helpTexts[column.columnName],
          displayName: displayName,
          hintText:
              hintTexts[column.columnName] ?? 'Enter comma-separated values',
          hasFormLevelError: hasFormLevelError,
          formLevelErrorMessage: hasFormLevelError
              ? getFormLevelErrorForField(column.columnName, formLevelErrors)
              : null,
          controller: controllers[column.columnName]!,
          onChanged: (value) {
            onFieldValueChanged(column.columnName, value);
          },
          optionLabelMapper: dropdownOptionMappers[column.columnName],
        );

      case PostgresDataType.userDefined:
        // If it's a user-defined type with enum options, create a dropdown
        if (column.enumOptions.isNotEmpty) {
          return DropdownFormFieldWidget(
            column: column,
            label: label,
            isReadonly: isReadonly,
            isRequired: isRequired,
            customValidator: customValidators[column.columnName],
            helpText: helpTexts[column.columnName],
            displayName: displayName,
            hintText: hintTexts[column.columnName] ?? 'Select $displayName',
            hasFormLevelError: hasFormLevelError,
            formLevelErrorMessage: hasFormLevelError
                ? getFormLevelErrorForField(column.columnName, formLevelErrors)
                : null,
            initialValue: formData[column.columnName] as String?,
            optionMapper: dropdownOptionMappers[column.columnName],
            onChanged: (value) {
              onFieldValueChanged(column.columnName, value);
            },
          );
        }
        // Fall back to text field if no enum options are provided
        return TextFormFieldWidget(
          column: column,
          label: label,
          isReadonly: isReadonly,
          isRequired: isRequired,
          customValidator: customValidators[column.columnName],
          helpText: helpTexts[column.columnName],
          displayName: displayName,
          hintText: hintTexts[column.columnName] ?? 'Enter $displayName',
          hasFormLevelError: hasFormLevelError,
          formLevelErrorMessage: hasFormLevelError
              ? getFormLevelErrorForField(column.columnName, formLevelErrors)
              : null,
          controller: controllers[column.columnName]!,
          onChanged: (value) {
            onFieldValueChanged(column.columnName, value);
          },
        );
      case PostgresDataType.array:
        return ArrayFormFieldWidget(
          column: column,
          label: label,
          isReadonly: isReadonly,
          isRequired: isRequired,
          displayName: displayName,
          hintText: hintTexts[column.columnName] ?? 'Enter $displayName',
          hasFormLevelError: hasFormLevelError,
          formLevelErrorMessage: hasFormLevelError
              ? getFormLevelErrorForField(column.columnName, formLevelErrors)
              : null,
          controller: controllers[column.columnName]!,
          onChanged: (value) {
            onFieldValueChanged(column.columnName, value);
          },
          customValidator: customValidators[column.columnName],
          helpText: helpTexts[column.columnName],
          optionLabelMapper: dropdownOptionMappers[column.columnName],
        );
      default:
        return TextFormFieldWidget(
          column: column,
          label: label,
          isReadonly: isReadonly,
          isRequired: isRequired,
          customValidator: customValidators[column.columnName],
          helpText: helpTexts[column.columnName],
          displayName: displayName,
          hintText: hintTexts[column.columnName] ?? 'Enter $displayName',
          hasFormLevelError: hasFormLevelError,
          formLevelErrorMessage: hasFormLevelError
              ? getFormLevelErrorForField(column.columnName, formLevelErrors)
              : null,
          controller: controllers[column.columnName]!,
          onChanged: (value) {
            onFieldValueChanged(column.columnName, value);
          },
        );
    }
  }
}
