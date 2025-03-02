import 'package:flutter/material.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';

class DropdownFormFieldWidget extends StatelessWidget {
  final ColumnDefinitionModel column;
  final String label;
  final bool isReadonly;
  final bool isRequired;
  final String? Function(dynamic)? customValidator;
  final String? helpText;
  final String displayName;
  final String hintText;
  final bool hasFormLevelError;
  final String? formLevelErrorMessage;
  final String? initialValue;
  final Map<String, String>? optionMapper;
  final Function(dynamic) onChanged;

  const DropdownFormFieldWidget({
    super.key,
    required this.column,
    required this.label,
    required this.isReadonly,
    required this.isRequired,
    this.customValidator,
    this.helpText,
    required this.displayName,
    required this.hintText,
    required this.hasFormLevelError,
    this.formLevelErrorMessage,
    required this.initialValue,
    this.optionMapper,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Handle empty string as null for consistency
    String? value = initialValue;
    if (value == '') {
      value = null;
    }

    // Ensure the initial value is one of the enum options
    if (value != null && !column.enumOptions.contains(value)) {
      value = null;
    }

    return FormField<String>(
      initialValue: value,
      validator: (value) {
        // Required field validation
        if (isRequired && (value == null || value.isEmpty)) {
          return '$displayName is required';
        }

        // Custom validation if provided
        if (customValidator != null && value != null && value.isNotEmpty) {
          return customValidator!(value);
        }

        // Check if this field is involved in any form-level validation errors
        if (hasFormLevelError) {
          // Return a non-null value to mark the field as invalid
          return '';
        }

        return null;
      },
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: field.hasError || hasFormLevelError
                      ? Theme.of(context).colorScheme.error
                      : Colors.grey.shade300,
                  width: field.hasError || hasFormLevelError ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: isReadonly ? Colors.grey.shade100 : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  if (field.value != null && field.value!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          color: field.hasError || hasFormLevelError
                              ? Theme.of(context).colorScheme.error
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  // Dropdown
                  Container(
                    height: 48, // Match TextField height
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 12,
                      top: (field.value != null && field.value!.isNotEmpty)
                          ? 4
                          : 0,
                      bottom: (field.value != null && field.value!.isNotEmpty)
                          ? 8
                          : 0,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: field.value,
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: isReadonly
                              ? Colors.grey.shade400
                              : Colors.grey.shade700,
                        ),
                        hint: Text(
                          label,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: isReadonly
                              ? Colors.grey.shade700
                              : Colors.black87,
                        ),
                        onChanged: isReadonly
                            ? null
                            : (String? newValue) {
                                // Handle empty string as null
                                final valueToStore =
                                    newValue == '' ? null : newValue;
                                field.didChange(newValue);
                                onChanged(valueToStore);
                              },
                        items: [
                          if (!isRequired)
                            const DropdownMenuItem<String>(
                              value: '',
                              child: Text('None'),
                            ),
                          ...column.enumOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            // Use the option mapper if provided, otherwise use the original value
                            final displayValue = optionMapper?[value] ?? value;

                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                displayValue,
                                style: TextStyle(
                                  color: isReadonly
                                      ? Colors.grey.shade700
                                      : Colors.black87,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Error message
            if (field.hasError && !hasFormLevelError && field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 6),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            // Form-level error
            if (hasFormLevelError && formLevelErrorMessage != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 6),
                child: Text(
                  formLevelErrorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            // Help text
            if (helpText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        helpText!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
