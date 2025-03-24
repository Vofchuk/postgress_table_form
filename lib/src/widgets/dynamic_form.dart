import 'package:flutter/material.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';
import 'package:postgress_table_form/src/models/postgress_data_type.dart';
import 'package:postgress_table_form/src/models/table_definition_model/table_definiton_model.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/field_group_widget.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_field_utils.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_models.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/ungrouped_fields_widget.dart';

/// Represents a group of fields in the form

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

  /// List of form-level validation functions that validate relationships between fields
  /// Each validation consists of:
  /// - involvedFields: List of field names involved in the validation
  /// - validate: Function that receives the form data and returns true if valid, false if invalid
  /// - errorMessage: Message to display if validation fails
  ///
  /// The error message will be displayed on all involved fields
  final List<FormValidation> formValidations;

  /// Map of column names to custom display names
  /// This allows users to customize the labels shown for each field
  final Map<String, String> columnNameMapper;

  /// Map of column names to a map of dropdown option values to display names
  /// This allows users to customize how dropdown options are displayed
  /// The key is the column name, and the value is a map of option values to display names
  /// The option values are the values stored in the database, and the display names are the values shown to the user
  /// The option values are the keys in the map, and the display names are the values
  ///
  /// Example:
  /// ```dart
  /// {
  ///   'status': {
  ///     'ACTIVE': 'Active',
  ///     'INACTIVE': 'Inactive',
  ///   },
  /// }
  /// ```
  final Map<String, Map<String, String>> dropdownOptionMappers;

  /// Custom header text for form validation errors
  final String validationErrorsHeader;

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
    this.columnNameMapper = const {},
    this.dropdownOptionMappers = const {},
    this.validationErrorsHeader = 'Please fix the following errors:',
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();

  /// Get the current form data without validation
  static Map<String, dynamic>? getFormData(BuildContext context) {
    final state = context.findAncestorStateOfType<_DynamicFormState>();
    return state?._formData;
  }

  /// Manually submit the form
  static bool submitForm(BuildContext context) {
    final state = context.findAncestorStateOfType<_DynamicFormState>();
    if (state != null) {
      state._submitForm();
      return true;
    }
    return false;
  }
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

  void _initializeFormData() {
    _formData = {};

    // Initialize form data with initial values or defaults
    for (final column in widget.tableDefinition.getAllColumns()) {
      final columnName = column.columnName;

      // Always initialize hidden fields from initialData, even if they're null
      // This ensures we track all hidden fields for updates
      if (widget.hiddenFields.contains(columnName)) {
        if (widget.initialData != null &&
            widget.initialData!.containsKey(columnName)) {
          dynamic initialValue = widget.initialData![columnName];

          // Handle empty strings as null for consistency
          if (initialValue is String && initialValue.isEmpty) {
            initialValue = null;
          }

          _formData[columnName] = initialValue;
        }

        // Create controllers for hidden text fields if needed
        if (FormFieldUtils.columnNeedsTextController(column)) {
          final initialValue = _formData[columnName];
          final controller = TextEditingController(
            text: FormFieldUtils.formatInitialValueForTextField(
                initialValue, column.dataType),
          );
          _controllers[columnName] = controller;
        }

        continue;
      }

      // For visible fields, get the initial value
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

      // Create controllers for text fields
      if (FormFieldUtils.columnNeedsTextController(column)) {
        final controller = TextEditingController(
          text: FormFieldUtils.formatInitialValueForTextField(
              initialValue, column.dataType),
        );
        _controllers[columnName] = controller;
      }

      // Set initial form data
      _formData[columnName] = initialValue;
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
    return SizedBox(
      width: MediaQuery.of(context).size.width < 600
          ? MediaQuery.of(context).size.width
          : 600,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._buildFormFields(),
            // Display form-level validation errors
            if (_formLevelErrors.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildFormLevelErrors(),
            ],
            if (widget.showSubmitButton) ...[
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.submitButtonText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFormLevelErrors() {
    // Get unique error messages
    final Set<String> uniqueErrorMessages = _formLevelErrors.values.toSet();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade100.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.validationErrorsHeader,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...uniqueErrorMessages.map((errorMessage) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '•',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  List<Widget> _buildFormFields() {
    // If no groups are defined, build fields normally
    if (widget.fieldGroups.isEmpty) {
      return _buildUngroupedFields(widget.tableDefinition.getAllColumns());
    }

    // Get all columns that are in groups
    final Set<String> groupedColumnNames = {};
    for (final group in widget.fieldGroups) {
      groupedColumnNames.addAll(group.columnNames);
    }

    // Get ungrouped columns
    final ungroupedColumns = widget.tableDefinition
        .getAllColumns()
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
    return FieldGroupWidget(
      group: group,
      tableColumns: widget.tableDefinition.getAllColumns(),
      hiddenFields: widget.hiddenFields,
      fieldOrder: widget.fieldOrder,
      allFieldsReadonly: widget.allFieldsReadonly,
      readonlyFields: widget.readonlyFields,
      editableFields: widget.editableFields,
      columnNameMapper: widget.columnNameMapper,
      helpTexts: widget.helpTexts,
      hintTexts: widget.hintTexts,
      customValidators: widget.customValidators,
      formLevelErrors: _formLevelErrors,
      formData: _formData,
      controllers: _controllers,
      dropdownOptionMappers: widget.dropdownOptionMappers,
      expanded: _expandedGroups[group.title] ?? group.initiallyExpanded,
      onExpansionChanged: (expanded) {
        setState(() {
          _expandedGroups[group.title] = expanded;
        });
      },
      onFieldValueChanged: (columnName, value) {
        _formData[columnName] = value;
      },
    );
  }

  List<Widget> _buildUngroupedFields(List<ColumnDefinitionModel> columns) {
    return [
      UngroupedFieldsWidget(
        columns: columns,
        hiddenFields: widget.hiddenFields,
        fieldOrder: widget.fieldOrder,
        allFieldsReadonly: widget.allFieldsReadonly,
        readonlyFields: widget.readonlyFields,
        editableFields: widget.editableFields,
        columnNameMapper: widget.columnNameMapper,
        helpTexts: widget.helpTexts,
        hintTexts: widget.hintTexts,
        customValidators: widget.customValidators,
        formLevelErrors: _formLevelErrors,
        formData: _formData,
        controllers: _controllers,
        dropdownOptionMappers: widget.dropdownOptionMappers,
        onFieldValueChanged: (columnName, value) {
          _formData[columnName] = value;
        },
      ),
    ];
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // First validate all individual fields
      _formKey.currentState!.save();

      // Clear previous form-level errors
      setState(() {
        _formLevelErrors.clear();
      });

      // Ensure all text field values are updated from controllers
      _updateFormDataFromControllers();

      // Then check form-level validations
      bool hasFormLevelErrors = false;
      for (final validation in widget.formValidations) {
        // Call the validation function with the form data
        final isValid = validation.validate(_formData);

        if (!isValid) {
          hasFormLevelErrors = true;
          // Add error for each involved field
          for (final field in validation.involvedFields) {
            setState(() {
              // Use a unique key for each validation error
              _formLevelErrors['${field}_${validation.hashCode}'] =
                  validation.errorMessage;
            });
          }
        }
      }

      if (!hasFormLevelErrors) {
        // Clean form data before submission
        final Map<String, dynamic> cleanedFormData = _cleanFormData();

        // All validations passed, call onSubmit
        print('DynamicForm: Submitting form data: $cleanedFormData');
        widget.onSubmit(cleanedFormData);
      } else {
        // Force a rebuild to show form-level errors
        setState(() {});
      }
    }
  }

  // Helper method to clean form data before submission
  Map<String, dynamic> _cleanFormData() {
    final Map<String, dynamic> cleanedData = {};

    // Process each column in the table definition
    for (final column in widget.tableDefinition.getAllColumns()) {
      final columnName = column.columnName;

      // Get the value from form data
      dynamic value = _formData[columnName];

      // Handle empty strings consistently for all fields
      if (value is String && value.trim().isEmpty) {
        value = null;
      }

      // For hidden fields, include them in the cleaned data
      if (widget.hiddenFields.contains(columnName)) {
        // Include the current value from _formData if it exists
        if (value != null) {
          cleanedData[columnName] = value;
        }
        // Otherwise, include the initial value if it exists
        else if (widget.initialData != null &&
            widget.initialData!.containsKey(columnName)) {
          dynamic initialValue = widget.initialData![columnName];
          // Also check if the initial value is an empty string
          if (initialValue is String && initialValue.trim().isEmpty) {
            initialValue = null;
          }
          if (initialValue != null) {
            cleanedData[columnName] = initialValue;
          }
        }
        continue;
      }

      // Only include non-null values for visible fields
      if (value != null) {
        cleanedData[columnName] = value;
      }
    }

    return cleanedData;
  }

  // Helper method to update form data from controllers
  void _updateFormDataFromControllers() {
    _controllers.forEach((columnName, controller) {
      // Skip readonly fields
      if ((widget.allFieldsReadonly &&
              !widget.editableFields.contains(columnName)) ||
          widget.readonlyFields.contains(columnName)) {
        return;
      }

      // Note: We no longer skip hidden fields to ensure their values are updated

      // Find the column definition
      ColumnDefinitionModel? column;
      try {
        column = widget.tableDefinition.getAllColumns().firstWhere(
              (col) => col.columnName == columnName,
            );
      } catch (_) {
        // Column not found, skip this controller
        return;
      }

      // Update form data based on the column type
      if (controller.text.isEmpty) {
        _formData[columnName] = null;
      } else {
        // Handle array types specially - parse comma-separated values into a list
        if (column.dataType == PostgresDataType.array) {
          // Parse comma-separated values into a list
          final list = controller.text
              .split(',')
              .map((item) => item.trim())
              .where((item) => item.isNotEmpty)
              .toList();
          _formData[columnName] = list;
        } else {
          // For other types, just use the controller text directly
          _formData[columnName] = controller.text;
        }
      }
    });
  }
}
