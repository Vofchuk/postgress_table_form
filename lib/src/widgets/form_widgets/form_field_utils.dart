import 'package:intl/intl.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';
import 'package:postgress_table_form/src/models/postgress_data_type.dart';

/// Utility class for form field operations
class FormFieldUtils {
  /// Determines if a field should be readonly based on the configuration
  static bool isFieldReadonly({
    required String columnName,
    required bool allFieldsReadonly,
    required List<String> editableFields,
    required List<String> readonlyFields,
  }) {
    if (allFieldsReadonly) {
      // If all fields are readonly by default, check if this field is in the editable list
      return !editableFields.contains(columnName);
    } else {
      // Otherwise, check if this field is in the readonly list
      return readonlyFields.contains(columnName);
    }
  }

  /// Determines if a field should be hidden based on the configuration
  static bool isFieldHidden({
    required String columnName,
    required List<String> hiddenFields,
  }) {
    return hiddenFields.contains(columnName);
  }

  /// Sort columns based on the fieldOrder parameter
  static List<ColumnDefinitionModel> sortColumns({
    required List<ColumnDefinitionModel> columns,
    required List<String> fieldOrder,
  }) {
    if (fieldOrder.isEmpty) {
      return columns;
    }

    // Create a map of column name to index in the fieldOrder list
    final orderMap = <String, int>{};
    for (int i = 0; i < fieldOrder.length; i++) {
      orderMap[fieldOrder[i]] = i;
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

  /// Checks if a column needs a text controller
  static bool columnNeedsTextController(ColumnDefinitionModel column) {
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

  /// Formats initial value for text field
  static String? formatInitialValueForTextField(
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
}
