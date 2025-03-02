import 'package:flutter/material.dart';

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

class FormValidation {
  /// List of field names involved in this validation
  final List<String> involvedFields;

  /// Validation function that receives the form data and returns true if valid,
  /// or false if validation fails
  final bool Function(Map<String, dynamic> formData) validate;

  /// Error message to display if validation fails
  final String errorMessage;

  /// Class for defining form-level validations that involve multiple fields
  ///
  /// Example usage:
  ///
  /// ```dart
  /// FormValidation(
  ///   // List of field names involved in this validation
  ///   involvedFields: ['start_date', 'end_date'],
  ///
  ///   // Validation function that receives the form data and returns true if valid,
  ///   // or false if validation fails
  ///   validate: (Map<String, dynamic> formData) {
  ///     final startDate = formData['start_date'] as DateTime?;
  ///     final endDate = formData['end_date'] as DateTime?;
  ///
  ///     if (startDate != null && endDate != null && startDate.isAfter(endDate)) {
  ///       return false;
  ///     }
  ///     return true;
  ///   },
  ///
  ///   // Error message to display if validation fails
  ///   errorMessage: 'Start date must be before end date',
  /// )
  /// ```
  ///
  /// The validation error will be displayed on all involved fields, making it clear
  /// which fields need to be corrected.
  FormValidation({
    required this.involvedFields,
    required this.validate,
    required this.errorMessage,
  });
}

/// Example usage of FormValidation:
///
/// ```dart
/// // Single field validation
/// FormValidation(
///   involvedFields: ['age'],
///   validate: (formData) {
///     final age = formData['age'] as int?;
///     return age == null || age >= 18;
///   },
///   errorMessage: 'Age must be at least 18',
/// ),
///
/// // Multi-field validation (relationship between fields)
/// FormValidation(
///   involvedFields: ['startDate', 'endDate'],
///   validate: (formData) {
///     final startDate = formData['startDate'] as DateTime?;
///     final endDate = formData['endDate'] as DateTime?;
///
///     if (startDate == null || endDate == null) {
///       return true; // If either date is null, validation passes
///     }
///
///     return !startDate.isAfter(endDate); // Valid if start date is not after end date
///   },
///   errorMessage: 'End date must be after start date',
/// ),
/// ```
