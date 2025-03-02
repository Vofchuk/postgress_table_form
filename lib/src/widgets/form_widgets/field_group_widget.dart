import 'package:flutter/material.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_field_factory.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_field_utils.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_models.dart';

class FieldGroupWidget extends StatelessWidget {
  final FieldGroup group;
  final List<ColumnDefinitionModel> tableColumns;
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
  final bool expanded;
  final Function(bool) onExpansionChanged;
  final Function(String, dynamic) onFieldValueChanged;

  const FieldGroupWidget({
    super.key,
    required this.group,
    required this.tableColumns,
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
    required this.expanded,
    required this.onExpansionChanged,
    required this.onFieldValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Get columns that are in this group
    final groupColumns = <ColumnDefinitionModel>[];
    for (final columnName in group.columnNames) {
      // Find the column in the table definition, or null if it doesn't exist
      final columnMatches =
          tableColumns.where((col) => col.columnName == columnName);
      final column = columnMatches.isNotEmpty ? columnMatches.first : null;

      // Skip if column doesn't exist or is hidden
      if (column == null ||
          FormFieldUtils.isFieldHidden(
              columnName: columnName, hiddenFields: hiddenFields)) continue;

      groupColumns.add(column);
    }

    // If all columns in this group are hidden or don't exist, don't show the group
    if (groupColumns.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort columns based on the fieldOrder
    final sortedColumns = FormFieldUtils.sortColumns(
      columns: groupColumns,
      fieldOrder: fieldOrder,
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: expanded,
          onExpansionChanged: onExpansionChanged,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: EdgeInsets.zero,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Row(
            children: [
              if (group.icon != null) ...[
                Icon(
                  group.icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
              ],
              Text(
                group.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          children: [
            const Divider(height: 1, thickness: 1),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sortedColumns.map((column) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
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
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
