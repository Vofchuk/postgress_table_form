import 'package:flutter/material.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_field_factory.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_field_utils.dart';

class UngroupedFieldsWidget extends StatelessWidget {
  final List<ColumnDefinitionModel> columns;
  final List<String> hiddenFields;
  final List<String> fieldOrder;
  final bool allFieldsReadonly;
  final List<String> readonlyFields;
  final List<String> editableFields;
  final Map<String, String> columnNameMapper;
  final Map<String, String> helpTexts;
  final Map<String, String> hintTexts;
  final Map<String, String? Function(dynamic)> customValidators;
  final Map<String, String> formLevelErrors;
  final Map<String, dynamic> formData;
  final Map<String, TextEditingController> controllers;
  final Map<String, Map<String, String>> dropdownOptionMappers;
  final Function(String, dynamic) onFieldValueChanged;

  const UngroupedFieldsWidget({
    super.key,
    required this.columns,
    required this.hiddenFields,
    required this.fieldOrder,
    required this.allFieldsReadonly,
    required this.readonlyFields,
    required this.editableFields,
    required this.columnNameMapper,
    required this.helpTexts,
    required this.hintTexts,
    required this.customValidators,
    required this.formLevelErrors,
    required this.formData,
    required this.controllers,
    required this.dropdownOptionMappers,
    required this.onFieldValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fields = <Widget>[];

    // Sort columns based on the fieldOrder
    final sortedColumns = FormFieldUtils.sortColumns(
      columns: columns,
      fieldOrder: fieldOrder,
    );

    for (final column in sortedColumns) {
      // Skip hidden fields
      if (FormFieldUtils.isFieldHidden(
          columnName: column.columnName, hiddenFields: hiddenFields)) continue;

      fields.add(
        Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: FormFieldFactory.buildFieldForColumn(
            context: context,
            column: column,
            isReadonly: FormFieldUtils.isFieldReadonly(
              columnName: column.columnName,
              allFieldsReadonly: allFieldsReadonly,
              editableFields: editableFields,
              readonlyFields: readonlyFields,
            ),
            columnNameMapper: columnNameMapper,
            helpTexts: helpTexts,
            hintTexts: hintTexts,
            customValidators: customValidators,
            formLevelErrors: formLevelErrors,
            formData: formData,
            controllers: controllers,
            dropdownOptionMappers: dropdownOptionMappers,
            onFieldValueChanged: onFieldValueChanged,
          ),
        ),
      );
    }

    if (fields.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fields,
      ),
    );
  }
}
