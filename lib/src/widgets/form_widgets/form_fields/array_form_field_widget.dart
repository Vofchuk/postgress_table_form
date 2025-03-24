import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';

class ArrayFormFieldWidget extends StatefulWidget {
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
  final Function(List<dynamic>) onChanged;
  final dynamic initialValue;
  final Map<String, String>? optionLabelMapper;
  final bool allTextCapitalized;

  const ArrayFormFieldWidget({
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
    this.initialValue,
    this.optionLabelMapper,
    this.allTextCapitalized = false,
  });

  @override
  State<ArrayFormFieldWidget> createState() => _ArrayFormFieldWidgetState();
}

class _ArrayFormFieldWidgetState extends State<ArrayFormFieldWidget> {
  List<String> _selectedOptions = [];

  @override
  void initState() {
    super.initState();
    _formatInitialValue();
  }

  void _formatInitialValue() {
    // Format the initial value for display
    if (widget.controller.text.isNotEmpty) {
      // If the controller already has text, format it
      _formatControllerText();
    } else if (widget.initialValue != null) {
      // Initialize from initialValue
      if (widget.initialValue is List) {
        // Convert list to comma-separated string
        final List<String> items = (widget.initialValue as List)
            .map((item) => item.toString())
            .toList();

        widget.controller.text = items.join(', ');

        if (widget.column.enumOptions.isNotEmpty) {
          _selectedOptions = items;
        }
      } else if (widget.initialValue is String) {
        String value = widget.initialValue;
        _processStringValue(value);
      }
    }
  }

  void _processStringValue(String value) {
    List<String> resultItems = [];

    // First, try to parse as JSON
    try {
      // Handle case where it's a JSON string like "\"[WALK, DRIVE]\""
      if (value.startsWith('"') && value.endsWith('"')) {
        // Try to decode the JSON string
        final decoded = jsonDecode(value);
        if (decoded is String) {
          // We got a string from JSON decode, process it
          _processStringValue(decoded);
          return;
        }
      }

      // Try to parse as JSON array
      final decoded = jsonDecode(value);
      if (decoded is List) {
        resultItems = decoded.map((item) => item.toString()).toList();
        widget.controller.text = resultItems.join(', ');

        if (widget.column.enumOptions.isNotEmpty) {
          setState(() {
            _selectedOptions = resultItems;
          });
        }
        return;
      }
    } catch (_) {
      // Not valid JSON, continue with other checks
    }

    // Remove square brackets if present
    if (value.trim().startsWith('[') && value.trim().endsWith(']')) {
      value = value.trim().substring(1, value.length - 1);
    }

    // Handle escaped quotes around values
    value = value.replaceAll('"', '');

    // Split by comma and trim
    resultItems = value
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    widget.controller.text = resultItems.join(', ');

    if (widget.column.enumOptions.isNotEmpty) {
      setState(() {
        _selectedOptions = resultItems;
      });
    }
  }

  void _formatControllerText() {
    String text = widget.controller.text;

    // Skip empty text
    if (text.isEmpty) return;

    _processStringValue(text);
  }

  // Convert comma-separated string to list
  List<String> _parseInput(String input) {
    if (input.isEmpty) return [];

    // Remove square brackets if present
    String processed = input;
    if (processed.trim().startsWith('[') && processed.trim().endsWith(']')) {
      processed = processed.trim().substring(1, processed.length - 1);
    }

    // Remove quotes if present
    processed = processed.replaceAll('"', '');

    return processed
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  void _updateSelectedOptions(List<String> selected) {
    setState(() {
      _selectedOptions = selected;
    });

    // Update controller text
    widget.controller.text = selected.join(', ');

    // Notify parent about change
    widget.onChanged(selected);
  }

  // Get display label for an option value
  String _getOptionDisplayLabel(String optionValue) {
    if (widget.optionLabelMapper != null &&
        widget.optionLabelMapper!.containsKey(optionValue)) {
      return widget.optionLabelMapper![optionValue]!;
    }
    return optionValue;
  }

  @override
  Widget build(BuildContext context) {
    // Format the controller text whenever the widget builds
    // This ensures any external changes to the controller are properly formatted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use post-frame callback to avoid rebuilds during build phase
      _formatControllerText();
    });

    // Check if we need to show multi-select UI based on enum options
    final bool hasEnumOptions = widget.column.enumOptions.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasEnumOptions)
          _buildMultiSelectUI()
        else
          TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: widget.hasFormLevelError
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
              fillColor:
                  widget.isReadonly ? Colors.grey.shade100 : Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              errorText: widget.hasFormLevelError
                  ? widget.formLevelErrorMessage
                  : null,
            ),
            readOnly: widget.isReadonly,
            enabled: !widget.isReadonly,
            validator: (value) {
              // Required field validation
              if (widget.isRequired && (value == null || value.isEmpty)) {
                return '${widget.displayName} is required';
              }

              // Validate comma-separated values
              if (value != null && value.isNotEmpty) {
                final list = _parseInput(value);

                // Custom validation if provided
                if (widget.customValidator != null) {
                  return widget.customValidator!(list);
                }
              }

              // Check if this field is involved in any form-level validation errors
              if (widget.hasFormLevelError) {
                // Return a non-null value to mark the field as invalid
                return '';
              }

              return null;
            },
            onChanged: widget.isReadonly
                ? null
                : (value) {
                    if (value.isEmpty) {
                      widget.onChanged([]);
                    } else {
                      final list = _parseInput(value);
                      widget.onChanged(list);
                    }
                  },
          ),
        if (widget.helpText != null)
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
                    widget.helpText!,
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
        if (!hasEnumOptions)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 10.0),
            child: Text(
              'Enter values as a comma-separated list, e.g., walk, drive',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMultiSelectUI() {
    return FormField<List<String>>(
      initialValue: _selectedOptions,
      validator: (value) {
        // Required field validation
        if (widget.isRequired && (value == null || value.isEmpty)) {
          return '${widget.displayName} is required';
        }

        // Custom validation if provided
        if (widget.customValidator != null && value != null) {
          return widget.customValidator!(value);
        }

        // Check if this field is involved in any form-level validation errors
        if (widget.hasFormLevelError) {
          // Return a non-null value to mark the field as invalid
          return '';
        }

        return null;
      },
      builder: (FormFieldState<List<String>> field) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: widget.hasFormLevelError || field.hasError
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
            fillColor: widget.isReadonly ? Colors.grey.shade100 : Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            errorText: field.errorText ??
                (widget.hasFormLevelError
                    ? widget.formLevelErrorMessage
                    : null),
          ),
          isEmpty: _selectedOptions.isEmpty,
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: widget.column.enumOptions.map((option) {
              final bool isSelected = _selectedOptions.contains(option);
              final String displayLabel = _getOptionDisplayLabel(option);

              return ChoiceChip(
                label: Text(displayLabel),
                selected: isSelected,
                onSelected: widget.isReadonly
                    ? null
                    : (selected) {
                        List<String> newSelection = List.from(_selectedOptions);

                        if (selected) {
                          if (!newSelection.contains(option)) {
                            newSelection.add(option);
                          }
                        } else {
                          newSelection.remove(option);
                        }

                        _updateSelectedOptions(newSelection);
                        field.didChange(newSelection);
                      },
                backgroundColor: Colors.grey.shade100,
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade800,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
