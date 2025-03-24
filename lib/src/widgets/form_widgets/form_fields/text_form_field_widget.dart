import 'package:flutter/material.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';
import 'package:postgress_table_form/src/widgets/form_widgets/form_field_utils.dart';

class TextFormFieldWidget extends StatelessWidget {
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

  const TextFormFieldWidget({
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
          enableInteractiveSelection: true,
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
            errorText: hasFormLevelError ? formLevelErrorMessage : null,
          ),
          readOnly: isReadonly,
          enabled: true,
          style: TextStyle(
            color: isReadonly ? Colors.grey.shade700 : Colors.black87,
            fontSize: 15,
          ),
          textCapitalization: allTextCapitalized
              ? TextCapitalization.characters
              : TextCapitalization.none,
          validator: (value) {
            // Required field validation - skip for readonly fields
            if (FormFieldUtils.shouldValidateAsRequired(
                  isRequired: isRequired,
                  isReadonly: isReadonly,
                ) &&
                (value == null || value.isEmpty)) {
              return '$displayName is required';
            }

            // Custom validation if provided
            if (customValidator != null && value != null) {
              return customValidator!(value);
            }

            // Check if this field is involved in any form-level validation errors
            if (hasFormLevelError) {
              // Return a non-null value to mark the field as invalid
              // but don't show a duplicate error message since we're using errorText
              return ' ';
            }

            return null;
          },
          onChanged: (value) {
            if (!isReadonly) {
              // Convert to uppercase if allTextCapitalized is true
              final processedValue =
                  allTextCapitalized ? value.toUpperCase() : value;
              // If the value changes due to uppercase conversion, update the controller
              if (processedValue != value) {
                // Remember the current cursor position
                final cursorPos = controller.selection.start;
                // Update the controller text
                controller.text = processedValue;
                // Restore cursor position, adjusting for any text length changes
                if (cursorPos <= processedValue.length) {
                  controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: cursorPos),
                  );
                }
              }
              onChanged(processedValue);
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
