import 'package:flutter/material.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_field_utils.dart';

class BooleanFormFieldWidget extends StatelessWidget {
  final ColumnDefinitionModel column;
  final String label;
  final bool isReadonly;
  final bool isRequired;
  final String? Function(dynamic)? customValidator;
  final String? helpText;
  final String displayName;
  final bool hasFormLevelError;
  final String? formLevelErrorMessage;
  final bool? initialValue;
  final Function(dynamic) onChanged;

  const BooleanFormFieldWidget({
    super.key,
    required this.column,
    required this.label,
    required this.isReadonly,
    required this.isRequired,
    this.customValidator,
    this.helpText,
    required this.displayName,
    required this.hasFormLevelError,
    this.formLevelErrorMessage,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      initialValue: initialValue ?? false,
      validator: (value) {
        // Required field validation - skip for readonly fields
        if (FormFieldUtils.shouldValidateAsRequired(
              isRequired: isRequired,
              isReadonly: isReadonly,
            ) &&
            value == null) {
          return '$displayName is required';
        }

        // Custom validation if provided
        if (customValidator != null && value != null) {
          return customValidator!(value);
        }

        // Check if this field is involved in any form-level validation errors
        if (hasFormLevelError) {
          // Return a non-null value to mark the field as invalid
          return '';
        }

        return null;
      },
      builder: (FormFieldState<bool> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              child: Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: field.value ?? false,
                      onChanged: isReadonly
                          ? null
                          : (newValue) {
                              field.didChange(newValue);
                              onChanged(newValue);
                            },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            isReadonly ? Colors.grey.shade700 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (field.hasError && field.errorText != null && !hasFormLevelError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 14,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        field.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
            // Show form-level error message if this field is involved
            if (hasFormLevelError && formLevelErrorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 14,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        formLevelErrorMessage!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w500,
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
