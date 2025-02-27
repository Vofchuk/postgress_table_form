import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';
import 'package:postgress_table_form/src/models/postgress_data_type.dart';
import 'package:postgress_table_form/src/models/table_definition_model/table_definiton_model.dart';

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
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _formData;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeFormData();
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

  void _initializeFormData() {
    _formData = {};

    // Initialize form data with initial values or defaults
    for (final column in widget.tableDefinition.columns) {
      final columnName = column.columnName;
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

  List<Widget> _buildFormFields() {
    final fields = <Widget>[];

    for (final column in widget.tableDefinition.columns) {
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

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter ${column.columnName}',
        border: const OutlineInputBorder(),
        filled: isReadonly,
        fillColor: isReadonly ? Colors.grey.shade200 : null,
      ),
      readOnly: isReadonly,
      enabled: !isReadonly,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return '${column.columnName} is required';
        }
        return null;
      },
      onChanged: isReadonly
          ? null
          : (value) {
              _formData[column.columnName] = value;
            },
    );
  }

  Widget _buildIntegerField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter ${column.columnName}',
        border: const OutlineInputBorder(),
        filled: isReadonly,
        fillColor: isReadonly ? Colors.grey.shade200 : null,
      ),
      readOnly: isReadonly,
      enabled: !isReadonly,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return '${column.columnName} is required';
        }
        if (value != null && value.isNotEmpty) {
          if (int.tryParse(value) == null) {
            return 'Please enter a valid integer';
          }
        }
        return null;
      },
      onChanged: isReadonly
          ? null
          : (value) {
              _formData[column.columnName] =
                  value.isEmpty ? null : int.tryParse(value);
            },
    );
  }

  Widget _buildDecimalField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter ${column.columnName}',
        border: const OutlineInputBorder(),
        filled: isReadonly,
        fillColor: isReadonly ? Colors.grey.shade200 : null,
      ),
      readOnly: isReadonly,
      enabled: !isReadonly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return '${column.columnName} is required';
        }
        if (value != null && value.isNotEmpty) {
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
        }
        return null;
      },
      onChanged: isReadonly
          ? null
          : (value) {
              _formData[column.columnName] =
                  value.isEmpty ? null : double.tryParse(value);
            },
    );
  }

  Widget _buildBooleanField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final isRequired = column.isNullable != 'YES';
    final initialValue = _formData[column.columnName] as bool? ?? false;

    return FormField<bool>(
      initialValue: initialValue,
      validator: (value) {
        if (isRequired && value == null) {
          return '${column.columnName} is required';
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
          ],
        );
      },
    );
  }

  Widget _buildDateField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'YYYY-MM-DD',
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
                    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
                    controller.text = formattedDate;
                    _formData[column.columnName] = date;
                  }
                },
              ),
      ),
      readOnly: isReadonly,
      enabled: !isReadonly,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return '${column.columnName} is required';
        }
        if (value != null && value.isNotEmpty) {
          try {
            DateTime.parse(value);
          } catch (_) {
            return 'Please enter a valid date (YYYY-MM-DD)';
          }
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
    );
  }

  Widget _buildDateTimeField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'YYYY-MM-DD HH:MM:SS',
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
                          DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
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
        if (isRequired && (value == null || value.isEmpty)) {
          return '${column.columnName} is required';
        }
        if (value != null && value.isNotEmpty) {
          try {
            DateTime.parse(value);
          } catch (_) {
            return 'Please enter a valid date and time (YYYY-MM-DD HH:MM:SS)';
          }
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
    );
  }

  Widget _buildJsonField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter JSON',
        border: const OutlineInputBorder(),
        filled: isReadonly,
        fillColor: isReadonly ? Colors.grey.shade200 : null,
      ),
      readOnly: isReadonly,
      enabled: !isReadonly,
      maxLines: 5,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return '${column.columnName} is required';
        }
        if (value != null && value.isNotEmpty) {
          try {
            // Validate JSON format
            jsonDecode(value);
          } catch (_) {
            return 'Please enter valid JSON';
          }
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
    );
  }

  Widget _buildArrayField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final controller = _controllers[column.columnName]!;
    final isRequired = column.isNullable != 'YES';

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter comma-separated values',
        border: const OutlineInputBorder(),
        filled: isReadonly,
        fillColor: isReadonly ? Colors.grey.shade200 : null,
      ),
      readOnly: isReadonly,
      enabled: !isReadonly,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return '${column.columnName} is required';
        }
        return null;
      },
      onChanged: isReadonly
          ? null
          : (value) {
              if (value.isEmpty) {
                _formData[column.columnName] = null;
              } else {
                final items = value.split(',').map((e) => e.trim()).toList();
                _formData[column.columnName] = items;
              }
            },
    );
  }

  Widget _buildDropdownField(
      ColumnDefinitionModel column, String label, bool isReadonly) {
    final isRequired = column.isNullable != 'YES';
    String? initialValue = _formData[column.columnName] as String?;

    // Handle empty string as null for consistency
    if (initialValue == '') {
      initialValue = null;
    }

    // Ensure the initial value is one of the enum options
    if (initialValue != null && !column.enumOptions.contains(initialValue)) {
      initialValue = null;
    }

    return FormField<String>(
      initialValue: initialValue,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return '${column.columnName} is required';
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
                hintText: 'Select ${column.columnName}',
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
                  hint: Text('Select ${column.columnName}'),
                  onChanged: isReadonly
                      ? null
                      : (String? newValue) {
                          // Handle empty string as null
                          final valueToStore = newValue == '' ? null : newValue;
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
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_formData);
    }
  }
}
