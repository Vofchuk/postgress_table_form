import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_field_utils.dart';

class DateFormFieldWidget extends StatelessWidget {
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
  final TextEditingController controller;
  final Function(dynamic) onChanged;
  final bool allTextCapitalized;

  const DateFormFieldWidget({
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
    required this.controller,
    required this.onChanged,
    this.allTextCapitalized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: hasFormLevelError
                  ? BorderSide(
                      color: Theme.of(context).colorScheme.error, width: 2)
                  : BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error, width: 2),
            ),
            filled: true,
            fillColor: isReadonly ? Colors.grey.shade100 : Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            suffixIcon: isReadonly
                ? null
                : IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Theme.of(context).primaryColor,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                              ),
                              dialogTheme: DialogThemeData(
                                  backgroundColor: Colors.white),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (date != null) {
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(date);
                        controller.text = formattedDate;
                        onChanged(date);
                      }
                    },
                  ),
            // Show error text directly on the field if there's a form-level error
            errorText: hasFormLevelError ? formLevelErrorMessage : null,
          ),
          readOnly: true, // Always readonly to prevent direct editing
          enabled: !isReadonly,
          style: TextStyle(
            color: isReadonly ? Colors.grey.shade700 : Colors.black87,
            fontSize: 15,
          ),
          validator: (value) {
            // Required field validation - skip for readonly fields
            if (FormFieldUtils.shouldValidateAsRequired(
                  isRequired: isRequired,
                  isReadonly: isReadonly,
                ) &&
                (value == null || value.isEmpty)) {
              return '$displayName is required';
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
              return customValidator!(parsedDate);
            }

            // Check if this field is involved in any form-level validation errors
            if (hasFormLevelError) {
              // Return a non-null value to mark the field as invalid
              // but don't show a duplicate error message since we're using errorText
              return ' ';
            }

            return null;
          },
          onChanged: isReadonly
              ? null
              : (value) {
                  if (value.isEmpty) {
                    onChanged(null);
                  } else {
                    try {
                      onChanged(DateTime.parse(value));
                    } catch (_) {
                      // Keep the string value until validation
                      onChanged(value);
                    }
                  }
                },
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
      ],
    );
  }
}
