import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';
import 'package:postgress_table_form/src/models/postgress_data_type.dart';
import 'package:postgress_table_form/src/models/table_definition_model/table_definiton_model.dart';

/// Represents a group of fields in the form
class FieldGroup {
  /// The title of the group
  final String title;

  /// The list of column names in this group
  final List<String> columnNames;

  /// Whether the group is initially expanded
  final bool initiallyExpanded;

  /// Optional icon to display next to the group title
  final IconData? icon;

  const FieldGroup({
    required this.title,
    required this.columnNames,
    this.initiallyExpanded = true,
    this.icon,
  });
}

/// Represents a form-level validation rule that validates relationships between multiple fields
class FormValidation {
  /// The validation function that takes the entire form data and returns an error message
  /// if validation fails, or null if validation passes
  final String? Function(Map<String, dynamic> formData) validate;

  /// The error message to display if validation fails
  final String errorMessage;

  /// The fields involved in this validation rule
  final List<String> involvedFields;

  const FormValidation({
    required this.validate,
    required this.errorMessage,
    required this.involvedFields,
  });
}

class DynamicForm extends StatefulWidget {
  final TableDefinitionModel tableDefinition;
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic> formData) onSubmit;
  final bool showSubmitButton;
  final String submitButtonText;

  /// List of column names that should be readonly
  final List<String> readonlyFields;

  /// If true, all fields will be readonly unless specified in [editableFields]
  final bool allFieldsReadonly;

  /// List of column names that should be editable (used when [allFieldsReadonly] is true)
  final List<String> editableFields;

  /// List of column names that should be hidden from the form
  final List<String> hiddenFields;

  /// Map of column names to custom validation functions
  /// The function should return null if the value is valid, or an error message if it's invalid
  final Map<String, String? Function(dynamic value)> customValidators;

  /// List of field groups to organize fields into sections
  final List<FieldGroup> fieldGroups;

  /// If true, fields not included in any group will be displayed at the top
  /// If false, fields not included in any group will be displayed at the bottom
  final bool ungroupedFieldsAtTop;

  /// Custom order for fields. If provided, fields will be displayed in this order.
  /// Fields not included in this list will be displayed after the ordered fields
  /// in their original order.
  /// This applies to ungrouped fields and to fields within each group.
  final List<String> fieldOrder;

  /// Map of column names to help text that will be displayed below the field
  final Map<String, String> helpTexts;

  /// Map of column names to hint text that will be displayed inside the field
  final Map<String, String> hintTexts;

  /// List of form-level validation functions that validate relationships between multiple fields
  /// Each function takes the entire form data and returns an error message if validation fails,
  /// or null if validation passes
  final List<FormValidation> formValidations;

  const DynamicForm({
    super.key,
    required this.tableDefinition,
    this.initialData,
    required this.onSubmit,
    this.showSubmitButton = true,
    this.submitButtonText = 'Submit',
    this.readonlyFields = const [],
    this.allFieldsReadonly = false,
    this.editableFields = const [],
    this.hiddenFields = const [],
    this.customValidators = const {},
    this.fieldGroups = const [],
    this.ungroupedFieldsAtTop = false,
    this.fieldOrder = const [],
    this.helpTexts = const {},
    this.hintTexts = const {},
    this.formValidations = const [],
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formData;
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _expandedGroups = {};

  // Store form-level validation errors
  final Map<String, String> _formLevelErrors = {};

  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _initializeExpandedGroups();
  }

  void _initializeExpandedGroups() {
    for (final group in widget.fieldGroups) {
      _expandedGroups[group.title] = group.initiallyExpanded;
    }
  }

  /// Determines if a field should be readonly based on the widget configuration
  bool _isFieldReadonly(String columnName) {
    if (widget.allFieldsReadonly) {
      // If all fields are readonly by default, check if this field is in the editable list
      return !widget.editableFields.contains(columnName);
    } else {
      // Otherwise, check if this field is in the readonly list
      return widget.readonlyFields.contains(columnName);
    }
  }

  /// Determines if a field should be hidden based on the widget configuration
  bool _isFieldHidden(String columnName) {
    return widget.hiddenFields.contains(columnName);
  }

  /// Sort columns based on the fieldOrder parameter
  List<ColumnDefinitionModel> _sortColumns(
      List<ColumnDefinitionModel> columns) {
    if (widget.fieldOrder.isEmpty) {
      return columns;
    }

    // Create a map of column name to index in the fieldOrder list
    final orderMap = <String, int>{};
    for (int i = 0; i < widget.fieldOrder.length; i++) {
      orderMap[widget.fieldOrder[i]] = i;
    }

    // Sort the columns based on the fieldOrder
    return List<ColumnDefinitionModel>.from(columns)
      ..sort((a, b) {
        final aIndex = orderMap[a.columnName];
        final bIndex = orderMap[b.columnName];

        // If both columns are in the fieldOrder, sort by their index
        if (aIndex != null && bIndex != null) {
          return aIndex.compareTo(bIndex);
        }

        // If only one column is in the fieldOrder, it comes first
        if (aIndex != null) return -1;
        if (bIndex != null) return 1;

        // If neither column is in the fieldOrder, maintain their original order
        return columns.indexOf(a).compareTo(columns.indexOf(b));
      });
  }

  void _initializeFormData() {
    _formData = {};

    // Initialize form data with initial values or defaults
    for (final column in widget.tableDefinition.columns) {
      final columnName = column.columnName;

      // Even if the field is hidden, we still need to initialize its data
      dynamic initialValue = widget.initialData?[columnName];

      // Handle empty strings as null for consistency
      if (initialValue is String && initialValue.isEmpty) {
        initialValue = null;
      }

      // For user-defined types with enum options, ensure the initial value is valid
      if (column.dataType == PostgresDataType.userDefined &&
          column.enumOptions.isNotEmpty &&
          initialValue != null) {
        // If the initial value is not in the enum options, set it to null
        if (!column.enumOptions.contains(initialValue)) {
          initialValue = null;
        }
      }

      // Create controllers for text fields (even for hidden fields, as they might be shown later)
      if (_columnNeedsTextController(column)) {
        final controller = TextEditingController(
          text: _formatInitialValueForTextField(initialValue, column.dataType),
        );
        _controllers[columnName] = controller;
      }

      // Set initial form data
      _formData[columnName] = initialValue;
    }
  }

  // Helper method to check if a column needs a text controller
  bool _columnNeedsTextController(ColumnDefinitionModel column) {
    // Boolean fields don't need text controllers
    if (column.dataType == PostgresDataType.boolean) {
      return false;
    }

    // User-defined types with enum options don't need text controllers
    if (column.dataType == PostgresDataType.userDefined &&
        column.enumOptions.isNotEmpty) {
      return false;
    }

    // All other fields need text controllers
    return true;
  }

  String? _formatInitialValueForTextField(
      dynamic value, PostgresDataType dataType) {
    if (value == null) return null;

    switch (dataType) {
      case PostgresDataType.date:
        if (value is DateTime) {
          return DateFormat('yyyy-MM-dd').format(value);
        } else if (value is String) {
          try {
            final date = DateTime.parse(value);
            return DateFormat('yyyy-MM-dd').format(date);
          } catch (_) {
            return value;
          }
        }
        return value.toString();

      case PostgresDataType.timestamp:
      case PostgresDataType.timestampWithTimeZone:
        if (value is DateTime) {
          return DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
        } else if (value is String) {
          try {
            final date = DateTime.parse(value);
            return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
          } catch (_) {
            return value;
          }
        }
        return value.toString();

      default:
        return value.toString();
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildFormFields(),
          // Display form-level validation errors
          if (_formLevelErrors.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildFormLevelErrors(),
          ],
          if (widget.showSubmitButton) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.submitButtonText),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormLevelErrors() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Please fix the following errors:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          ...(_formLevelErrors.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• ${entry.value}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }).toList()),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields() {
    // If no groups are defined, build fields normally
    if (widget.fieldGroups.isEmpty) {
      return _buildUngroupedFields(widget.tableDefinition.columns);
    }

    // Get all columns that are in groups
    final Set<String> groupedColumnNames = {};
    for (final group in widget.fieldGroups) {
      groupedColumnNames.addAll(group.columnNames);
    }

    // Get ungrouped columns
    final ungroupedColumns = widget.tableDefinition.columns
        .where((column) => !groupedColumnNames.contains(column.columnName))
        .toList();

    final widgets = <Widget>[];

    // Add ungrouped fields at the top if configured
    if (widget.ungroupedFieldsAtTop && ungroupedColumns.isNotEmpty) {
      widgets.addAll(_buildUngroupedFields(ungroupedColumns));
      widgets.add(const SizedBox(height: 16));
    }

    // Sort groups based on fieldOrder if provided
    List<FieldGroup> sortedGroups = List.from(widget.fieldGroups);
    if (widget.fieldOrder.isNotEmpty) {
      // Create a map to track the earliest appearance of each group's fields in fieldOrder
      final Map<String, int> groupOrderMap = {};

      for (final group in widget.fieldGroups) {
        int earliestIndex = widget.fieldOrder.length; // Default to end

        for (final columnName in group.columnNames) {
          final index = widget.fieldOrder.indexOf(columnName);
          if (index >= 0 && index < earliestIndex) {
            earliestIndex = index;
          }
        }

        groupOrderMap[group.title] = earliestIndex;
      }

      // Sort groups based on their earliest field appearance in fieldOrder
      sortedGroups.sort((a, b) {
        final aIndex = groupOrderMap[a.title] ?? widget.fieldOrder.length;
        final bIndex = groupOrderMap[b.title] ?? widget.fieldOrder.length;
        return aIndex.compareTo(bIndex);
      });
    }

    // Add grouped fields
    for (final group in sortedGroups) {
      widgets.add(_buildFieldGroup(group));
      widgets.add(const SizedBox(height: 16));
    }

    // Add ungrouped fields at the bottom if not configured to be at the top
    if (!widget.ungroupedFieldsAtTop && ungroupedColumns.isNotEmpty) {
      widgets.add(const SizedBox(height: 8));
      widgets.addAll(_buildUngroupedFields(ungroupedColumns));
    }

    return widgets;
  }

  Widget _buildFieldGroup(FieldGroup group) {
    // Get columns that are in this group
    final groupColumns = <ColumnDefinitionModel>[];
    for (final columnName in group.columnNames) {
      final column = widget.tableDefinition.columns.firstWhere(
          (col) => col.columnName == columnName,
          orElse: () => throw Exception(
              'Column $columnName not found in table definition'));

      // Skip hidden columns
      if (_isFieldHidden(columnName)) continue;

      groupColumns.add(column);
    }

    // If all columns in this group are hidden, don't show the group
    if (groupColumns.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort columns based on the fieldOrder
    final sortedColumns = _sortColumns(groupColumns);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        initiallyExpanded:
            _expandedGroups[group.title] ?? group.initiallyExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            _expandedGroups[group.title] = expanded;
          });
        },
        title: Row(
          children: [
            if (group.icon != null) ...[
              Icon(group.icon),
              const SizedBox(width: 8),
            ],
            Text(
              group.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: sortedColumns.map((column) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildFieldForColumn(column),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildUngroupedFields(List<ColumnDefinitionModel> columns) {
    final fields = <Widget>[];

    // Sort columns based on the fieldOrder
    final sortedColumns = _sortColumns(columns);

    for (final column in sortedColumns) {
      // Skip hidden fields
      if (_isFieldHidden(column.columnName)) continue;

      fields.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildFieldForColumn(column),
        ),
      );
    }

    return fields;
  }

  Widget _buildFieldForColumn(ColumnDefinitionModel column) {
    final isRequired = column.isNullable != 'YES';
    final label = '${column.columnName}${isRequired ? ' *' : ''}';
    final isReadonly = _isFieldReadonly(column.columnName);

    switch (column.dataType) {
      case PostgresDataType.boolean:
        return _buildBooleanField(column, label, isReadonly);

      case PostgresDataType.date:
        return _buildDateField(column, label, isReadonly);

      case PostgresDataType.timestamp:
      case PostgresDataType.timestampWithTimeZone:
        return _buildDateTimeField(column, label, isReadonly);

      case PostgresDataType.integer:
      case PostgresDataType.smallint:
      case PostgresDataType.bigint:
      case PostgresDataType.serial:
      case PostgresDataType.bigserial:
        return _buildIntegerField(column, label, isReadonly);

      case PostgresDataType.decimal:
      case PostgresDataType.numeric:
      case PostgresDataType.real:
      case PostgresDataType.doublePrecision:
        return _buildDecimalField(column, label, isReadonly);

      case PostgresDataType.json:
      case PostgresDataType.jsonb:
        return _buildJsonField(column, label, isReadonly);

      case PostgresDataType.integerArray:
      case PostgresDataType.textArray:
      case PostgresDataType.uuidArray:
        return _buildArrayField(column, label, isReadonly);

      case PostgresDataType.userDefined:
        // If it's a user-defined type with enum options, create a dropdown
        if (column.enumOptions.isNotEmpty) {
          return _buildDropdownField(column, label, isReadonly);
        }
        // Fall back to text field if no enum options are provided
        // This allows handling custom types that aren't enums
        return _buildTextField(column, label, isReadonly);

      default:
        return _buildTextField(column, label, isReadonly);
    }
  }

  Widget _buildTextField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';
    final customValidator = widget.customValidators[column.columnName];
    final helpText = widget.helpTexts[column.columnName];
    final hintText =
        widget.hintTexts[column.columnName] ?? 'Enter ${column.columnName}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: const OutlineInputBorder(),
            filled: isReadonly,
            fillColor: isReadonly ? Colors.grey.shade200 : null,
          ),
          readOnly: isReadonly,
          enabled: !isReadonly,
          validator: (value) {
            // Required field validation
            if (isRequired && (value == null || value.isEmpty)) {
              return '${column.columnName} is required';
            }

            // Custom validation if provided
            if (customValidator != null && value != null) {
              return customValidator(value);
            }

            return null;
          },
          onChanged: isReadonly
              ? null
              : (value) {
                  _formData[column.columnName] = value;
                },
        ),
        if (helpText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              helpText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIntegerField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';
    final customValidator = widget.customValidators[column.columnName];
    final helpText = widget.helpTexts[column.columnName];
    final hintText =
        widget.hintTexts[column.columnName] ?? 'Enter ${column.columnName}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: const OutlineInputBorder(),
            filled: isReadonly,
            fillColor: isReadonly ? Colors.grey.shade200 : null,
          ),
          readOnly: isReadonly,
          enabled: !isReadonly,
          keyboardType: TextInputType.number,
          validator: (value) {
            // Required field validation
            if (isRequired && (value == null || value.isEmpty)) {
              return '${column.columnName} is required';
            }

            // Type validation
            if (value != null && value.isNotEmpty) {
              if (int.tryParse(value) == null) {
                return 'Please enter a valid integer';
              }
            }

            // Custom validation if provided
            if (customValidator != null && value != null) {
              final parsedValue = value.isEmpty ? null : int.tryParse(value);
              return customValidator(parsedValue);
            }

            return null;
          },
          onChanged: isReadonly
              ? null
              : (value) {
                  _formData[column.columnName] =
                      value.isEmpty ? null : int.tryParse(value);
                },
        ),
        if (helpText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              helpText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDecimalField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';
    final customValidator = widget.customValidators[column.columnName];
    final helpText = widget.helpTexts[column.columnName];
    final hintText =
        widget.hintTexts[column.columnName] ?? 'Enter ${column.columnName}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: const OutlineInputBorder(),
            filled: isReadonly,
            fillColor: isReadonly ? Colors.grey.shade200 : null,
          ),
          readOnly: isReadonly,
          enabled: !isReadonly,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            // Required field validation
            if (isRequired && (value == null || value.isEmpty)) {
              return '${column.columnName} is required';
            }

            // Type validation
            if (value != null && value.isNotEmpty) {
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
            }

            // Custom validation if provided
            if (customValidator != null && value != null) {
              final parsedValue = value.isEmpty ? null : double.tryParse(value);
              return customValidator(parsedValue);
            }

            return null;
          },
          onChanged: isReadonly
              ? null
              : (value) {
                  _formData[column.columnName] =
                      value.isEmpty ? null : double.tryParse(value);
                },
        ),
        if (helpText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              helpText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBooleanField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final isRequired = column.isNullable != 'YES';
    final initialValue = _formData[column.columnName] as bool? ?? false;
    final customValidator = widget.customValidators[column.columnName];
    final helpText = widget.helpTexts[column.columnName];

    return FormField<bool>(
      initialValue: initialValue,
      validator: (value) {
        // Required field validation
        if (isRequired && value == null) {
          return '${column.columnName} is required';
        }

        // Custom validation if provided
        if (customValidator != null && value != null) {
          return customValidator(value);
        }

        return null;
      },
      builder: (FormFieldState<bool> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: field.value ?? false,
                  onChanged: isReadonly
                      ? null
                      : (newValue) {
                          field.didChange(newValue);
                          _formData[column.columnName] = newValue;
                        },
                ),
                Text(label),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 5),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error, fontSize: 12),
                ),
              ),
            if (helpText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                child: Text(
                  helpText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDateField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';
    final customValidator = widget.customValidators[column.columnName];
    final helpText = widget.helpTexts[column.columnName];
    final hintText = widget.hintTexts[column.columnName] ?? 'YYYY-MM-DD';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: const OutlineInputBorder(),
            filled: isReadonly,
            fillColor: isReadonly ? Colors.grey.shade200 : null,
            suffixIcon: isReadonly
                ? null
                : IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) {
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(date);
                        controller.text = formattedDate;
                        _formData[column.columnName] = date;
                      }
                    },
                  ),
          ),
          readOnly: isReadonly,
          enabled: !isReadonly,
          validator: (value) {
            // Required field validation
            if (isRequired && (value == null || value.isEmpty)) {
              return '${column.columnName} is required';
            }

            // Type validation
            DateTime? parsedDate;
            if (value != null && value.isNotEmpty) {
              try {
                parsedDate = DateTime.parse(value);
              } catch (_) {
                return 'Please enter a valid date (YYYY-MM-DD)';
              }
            }

            // Custom validation if provided
            if (customValidator != null && parsedDate != null) {
              return customValidator(parsedDate);
            }

            return null;
          },
          onChanged: isReadonly
              ? null
              : (value) {
                  if (value.isEmpty) {
                    _formData[column.columnName] = null;
                  } else {
                    try {
                      _formData[column.columnName] = DateTime.parse(value);
                    } catch (_) {
                      // Keep the string value until validation
                      _formData[column.columnName] = value;
                    }
                  }
                },
        ),
        if (helpText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              helpText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDateTimeField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';
    final customValidator = widget.customValidators[column.columnName];
    final helpText = widget.helpTexts[column.columnName];
    final hintText =
        widget.hintTexts[column.columnName] ?? 'YYYY-MM-DD HH:MM:SS';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: const OutlineInputBorder(),
            filled: isReadonly,
            fillColor: isReadonly ? Colors.grey.shade200 : null,
            suffixIcon: isReadonly
                ? null
                : IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (time != null) {
                          final dateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          final formattedDateTime =
                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(dateTime);
                          controller.text = formattedDateTime;
                          _formData[column.columnName] = dateTime;
                        }
                      }
                    },
                  ),
          ),
          readOnly: isReadonly,
          enabled: !isReadonly,
          validator: (value) {
            // Required field validation
            if (isRequired && (value == null || value.isEmpty)) {
              return '${column.columnName} is required';
            }

            // Type validation
            DateTime? parsedDateTime;
            if (value != null && value.isNotEmpty) {
              try {
                parsedDateTime = DateTime.parse(value);
              } catch (_) {
                return 'Please enter a valid date and time (YYYY-MM-DD HH:MM:SS)';
              }
            }

            // Custom validation if provided
            if (customValidator != null && parsedDateTime != null) {
              return customValidator(parsedDateTime);
            }

            return null;
          },
          onChanged: isReadonly
              ? null
              : (value) {
                  if (value.isEmpty) {
                    _formData[column.columnName] = null;
                  } else {
                    try {
                      _formData[column.columnName] = DateTime.parse(value);
                    } catch (_) {
                      // Keep the string value until validation
                      _formData[column.columnName] = value;
                    }
                  }
                },
        ),
        if (helpText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              helpText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildJsonField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';
    final customValidator = widget.customValidators[column.columnName];
    final helpText = widget.helpTexts[column.columnName];
    final hintText = widget.hintTexts[column.columnName] ?? 'Enter JSON';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: const OutlineInputBorder(),
            filled: isReadonly,
            fillColor: isReadonly ? Colors.grey.shade200 : null,
          ),
          readOnly: isReadonly,
          enabled: !isReadonly,
          maxLines: 5,
          validator: (value) {
            // Required field validation
            if (isRequired && (value == null || value.isEmpty)) {
              return '${column.columnName} is required';
            }

            // Type validation
            dynamic parsedJson;
            if (value != null && value.isNotEmpty) {
              try {
                // Validate JSON format
                parsedJson = jsonDecode(value);
              } catch (_) {
                return 'Please enter valid JSON';
              }
            }

            // Custom validation if provided
            if (customValidator != null && parsedJson != null) {
              return customValidator(parsedJson);
            }

            return null;
          },
          onChanged: isReadonly
              ? null
              : (value) {
                  if (value.isEmpty) {
                    _formData[column.columnName] = null;
                  } else {
                    try {
                      _formData[column.columnName] = jsonDecode(value);
                    } catch (_) {
                      // Keep the string value until validation
                      _formData[column.columnName] = value;
                    }
                  }
                },
        ),
        if (helpText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              helpText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildArrayField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';
    final customValidator = widget.customValidators[column.columnName];
    final helpText = widget.helpTexts[column.columnName];
    final hintText =
        widget.hintTexts[column.columnName] ?? 'Enter comma-separated values';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: const OutlineInputBorder(),
            filled: isReadonly,
            fillColor: isReadonly ? Colors.grey.shade200 : null,
          ),
          readOnly: isReadonly,
          enabled: !isReadonly,
          validator: (value) {
            // Required field validation
            if (isRequired && (value == null || value.isEmpty)) {
              return '${column.columnName} is required';
            }

            // Custom validation if provided
            if (customValidator != null && value != null && value.isNotEmpty) {
              final items = value.split(',').map((e) => e.trim()).toList();
              return customValidator(items);
            }

            return null;
          },
          onChanged: isReadonly
              ? null
              : (value) {
                  if (value.isEmpty) {
                    _formData[column.columnName] = null;
                  } else {
                    final items =
                        value.split(',').map((e) => e.trim()).toList();
                    _formData[column.columnName] = items;
                  }
                },
        ),
        if (helpText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              helpText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final isRequired = column.isNullable != 'YES';
    String? initialValue = _formData[column.columnName] as String?;
    final customValidator = widget.customValidators[column.columnName];
    final helpText = widget.helpTexts[column.columnName];
    final hintText =
        widget.hintTexts[column.columnName] ?? 'Select ${column.columnName}';

    // Handle empty string as null for consistency
    if (initialValue == '') {
      initialValue = null;
    }

    // Ensure the initial value is one of the enum options
    if (initialValue != null && !column.enumOptions.contains(initialValue)) {
      initialValue = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField<String>(
          initialValue: initialValue,
          validator: (value) {
            // Required field validation
            if (isRequired && (value == null || value.isEmpty)) {
              return '${column.columnName} is required';
            }

            // Custom validation if provided
            if (customValidator != null && value != null && value.isNotEmpty) {
              return customValidator(value);
            }

            return null;
          },
          builder: (FormFieldState<String> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: label,
                    hintText: hintText,
                    border: const OutlineInputBorder(),
                    errorText: field.errorText,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    filled: isReadonly,
                    fillColor: isReadonly ? Colors.grey.shade200 : null,
                  ),
                  isEmpty: field.value == null || field.value!.isEmpty,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: field.value,
                      isDense: true,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      hint: Text(hintText),
                      onChanged: isReadonly
                          ? null
                          : (String? newValue) {
                              // Handle empty string as null
                              final valueToStore =
                                  newValue == '' ? null : newValue;
                              field.didChange(newValue);
                              setState(() {
                                _formData[column.columnName] = valueToStore;
                              });
                            },
                      items: [
                        if (!isRequired)
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('None'),
                          ),
                        ...column.enumOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                if (field.hasError && field.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 5),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        if (helpText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              helpText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  void _submitForm() {
    // Clear previous form-level errors
    setState(() {
      _formLevelErrors.clear();
    });

    // First validate individual fields
    if (_formKey.currentState!.validate()) {
      // Then perform form-level validation
      bool formIsValid = true;

      for (final validation in widget.formValidations) {
        final errorMessage = validation.validate(_formData);
        if (errorMessage != null) {
          // Generate a unique key for this validation error
          final key = validation.involvedFields.join('_');
          _formLevelErrors[key] = errorMessage;
          formIsValid = false;

          // Expand any groups containing the involved fields
          for (final group in widget.fieldGroups) {
            for (final field in validation.involvedFields) {
              if (group.columnNames.contains(field)) {
                setState(() {
                  _expandedGroups[group.title] = true;
                });
                break;
              }
            }
          }
        }
      }

      if (formIsValid) {
        widget.onSubmit(_formData);
      } else {
        // Refresh the UI to show form-level errors
        setState(() {});
      }
    }
  }
}
