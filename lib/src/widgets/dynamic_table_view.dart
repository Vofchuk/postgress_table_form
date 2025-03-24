import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgress_table_form/src/models/column_definition _model/column_definition_model.dart';
import 'package:postgress_table_form/src/models/postgress_data_type.dart';
import 'package:postgress_table_form/src/models/table_definition_model/table_definiton_model.dart';

/// Callback for building action widgets for a specific row
///
/// This function receives the row data as a Map and should return a Widget
/// that will be displayed in the actions column for that row.
typedef ActionBuilder = Widget Function(Map<String, dynamic> rowData);

/// Callback for mapping column names to display names
///
/// This function receives the original column name from the database and
/// should return a user-friendly display name to be shown in the table header.
typedef ColumnNameMapper = String Function(String originalColumnName);

/// Callback for mapping column names to tooltip text
///
/// This function receives the original column name from the database and
/// should return a tooltip text to be shown when hovering over the column header.
typedef TooltipMapper = String Function(
    String originalColumnName, PostgresDataType dataType, bool isNullable);

/// Callback for building custom cell widgets
///
/// This function receives the cell value, column definition, and the entire row data,
/// and should return a Widget to be displayed in the cell.
typedef CustomCellBuilder = Widget Function(
  dynamic value,
  ColumnDefinitionModel column,
  Map<String, dynamic> rowData,
);

/// Enum to define the position of the actions column
///
/// - [start]: Actions column appears as the first column
/// - [end]: Actions column appears as the last column
enum ActionsColumnPosition {
  start,
  end,
}

/// A dynamic table widget that displays data from a PostgreSQL database
///
/// This widget automatically generates a data table based on a table definition
/// and a list of data. It supports customization of appearance, behavior, and
/// provides features like sorting, filtering, and row selection.
///
/// Example usage with dropdown option mapping:
/// ```dart
/// DynamicTableView(
///   tableDefinition: myTableDefinition,
///   data: myData,
///   // Map column names to display names
///   columnNameMapper: (columnName) => columnName.replaceAll('_', ' ').toUpperCase(),
///   // Map dropdown options to display values
///   dropdownOptionMappers: {
///     'status': {
///       'ACTIVE': 'Active',
///       'INACTIVE': 'Inactive',
///       'PENDING': 'Pending Approval',
///     },
///     'user_type': {
///       'admin': 'Administrator',
///       'user': 'Regular User',
///       'guest': 'Guest',
///     },
///   },
/// )
/// ```
class DynamicTableView extends StatefulWidget {
  /// The table definition containing column information
  ///
  /// This model defines the structure of the table, including column names,
  /// data types, and constraints.
  final TableDefinitionModel tableDefinition;

  /// The data to display in the table
  ///
  /// Each item in the list represents a row of data, typically as a Map where
  /// keys are column names and values are the cell data.
  final List<dynamic> data;

  /// Optional builder for the actions column
  ///
  /// This function receives the row data and should return a widget to be displayed
  /// in the actions column (e.g., edit/delete buttons).
  /// Remember to set [showActionsColumn] to true when using this.
  final ActionBuilder? actionBuilder;

  /// Optional mapper to customize column display names
  ///
  /// Default is the column name as defined in the database. Use this to customize
  /// the display name shown in the table header.
  ///
  /// Example:
  /// ```dart
  /// columnNameMapper: (columnName) => columnName.replaceAll('_', ' ').capitalize,
  /// ```
  final ColumnNameMapper? columnNameMapper;

  /// Optional mapper to customize column tooltips
  ///
  /// Default is the data type and nullability information. Use this to customize
  /// the tooltip shown when hovering over a column header.
  ///
  /// Example:
  /// ```dart
  /// tooltipMapper: (columnName, dataType, isNullable) =>
  ///   'Column: $columnName\nType: ${dataType.toString().split('.').last}\nNullable: ${isNullable}',
  /// ```
  final TooltipMapper? tooltipMapper;

  /// Position of the actions column (start or end)
  ///
  /// Controls whether the actions column appears as the first column or the last column.
  /// Default is [ActionsColumnPosition.start]
  final ActionsColumnPosition actionsColumnPosition;

  /// Title for the actions column
  ///
  /// The text displayed in the header of the actions column.
  /// Default is 'Actions'
  final String actionsColumnTitle;

  /// Whether to show the actions column
  ///
  /// When true, an actions column will be displayed according to the specified position.
  /// Default is false
  final bool showActionsColumn;

  /// Custom styling for the data table
  ///
  /// Allows applying a custom theme to the entire data table.
  final DataTableThemeData? tableTheme;

  /// Custom styling for the header row
  ///
  /// Background color for the header row containing column names.
  final Color? headerBackgroundColor;

  /// Custom styling for the header text
  ///
  /// Text style applied to the column names in the header row.
  final TextStyle? headerTextStyle;

  /// Custom styling for cell text
  ///
  /// Text style applied to the data cells in the table.
  final TextStyle? cellTextStyle;

  /// Whether to show tooltips for column data types
  ///
  /// When true, hovering over a column header will show a tooltip with the data type.
  /// Default is true
  final bool showDataTypeTooltips;

  /// Custom row height
  ///
  /// Sets a custom height for all data rows in the table.
  final double? rowHeight;

  /// Custom column spacing
  ///
  /// Sets the horizontal spacing between columns.
  final double? columnSpacing;

  /// Whether to enable row selection
  ///
  /// When true, rows can be selected by clicking on them.
  /// Default is false
  final bool enableRowSelection;

  /// Callback when a row is selected
  ///
  /// This function is called with the row data when a row is selected.
  /// Only used when [enableRowSelection] is true.
  final Function(Map<String, dynamic>)? onRowSelected;

  /// List of column names to hide
  ///
  /// Columns with names in this list will not be displayed in the table.
  /// Useful for hiding technical columns like IDs or timestamps.
  final List<String> hiddenColumns;

  /// Custom order for columns. If provided, columns will be displayed in this order.
  ///
  /// Columns not included in this list will be displayed after the ordered columns
  /// in their original order.
  final List<String> columnOrder;

  /// Map of column names to custom tooltips
  ///
  /// Provides specific tooltips for columns that override the default data type tooltips.
  /// Only used when [showDataTypeTooltips] is true.
  final Map<String, String> columnTooltips;

  /// Map of column names to a map of dropdown option values to display names
  /// This allows users to customize how dropdown options are displayed in the table
  /// The key is the column name, and the value is a map of option values to display names
  /// The option values are the values stored in the database, and the display names are the values shown to the user
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

  /// Custom formatters for specific columns
  ///
  /// A map where keys are column names and values are functions that build
  /// custom widgets for cells in that column.
  ///
  /// This is the simple version that only receives the cell value.
  /// For more advanced customization, use [advancedCustomCellBuilders].
  final Map<String, Widget Function(dynamic value)>? customCellBuilders;

  /// Enhanced custom formatters for specific columns
  ///
  /// A map where keys are column names and values are functions that build
  /// custom widgets for cells in that column.
  ///
  /// This version provides access to the column definition and the entire row data,
  /// allowing for more complex cell rendering based on multiple fields.
  final Map<String, CustomCellBuilder>? advancedCustomCellBuilders;

  /// Whether to show a horizontal scrollbar
  ///
  /// When true, a horizontal scrollbar will be displayed when the table is wider
  /// than its container.
  /// Default is true
  final bool showHorizontalScrollbar;

  /// Whether to show a vertical scrollbar
  ///
  /// When true, a vertical scrollbar will be displayed when the table is taller
  /// than its container.
  /// Default is true
  final bool showVerticalScrollbar;

  /// Creates a dynamic table view
  ///
  /// [tableDefinition] and [data] are required parameters.
  /// All other parameters are optional and provide customization options.
  const DynamicTableView({
    super.key,
    required this.tableDefinition,
    required this.data,
    this.actionBuilder,
    this.columnNameMapper,
    this.tooltipMapper,
    this.actionsColumnPosition = ActionsColumnPosition.start,
    this.actionsColumnTitle = 'Actions',
    this.showActionsColumn = false,
    this.tableTheme,
    this.headerBackgroundColor,
    this.headerTextStyle,
    this.cellTextStyle,
    this.showDataTypeTooltips = true,
    this.rowHeight,
    this.columnSpacing,
    this.enableRowSelection = false,
    this.onRowSelected,
    this.hiddenColumns = const [],
    this.columnOrder = const [],
    this.columnTooltips = const {},
    this.dropdownOptionMappers = const {},
    this.customCellBuilders,
    this.advancedCustomCellBuilders,
    this.showHorizontalScrollbar = true,
    this.showVerticalScrollbar = true,
  });

  @override
  State<DynamicTableView> createState() => _DynamicTableViewState();
}

class _DynamicTableViewState extends State<DynamicTableView> {
  // Controllers for scrolling
  late final ScrollController _horizontalController;
  late final ScrollController _verticalController;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
    _verticalController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget tableWidget = DataTable(
      columns: _buildColumns(),
      rows: _buildRows(),
      headingRowColor: WidgetStateProperty.all(
        widget.headerBackgroundColor ?? Colors.grey.shade200,
      ),
      dataRowMinHeight: widget.rowHeight ?? 48,
      dataRowMaxHeight: widget.rowHeight != null ? widget.rowHeight! + 24 : 72,
      columnSpacing: widget.columnSpacing ?? 24,
      horizontalMargin: 16,
      showCheckboxColumn: widget.enableRowSelection,
    );

    // Apply theme if provided
    if (widget.tableTheme != null) {
      tableWidget = Theme(
        data: Theme.of(context).copyWith(
          dataTableTheme: widget.tableTheme,
        ),
        child: tableWidget,
      );
    }

    // Add scrollbars as needed
    Widget scrollableWidget = tableWidget;

    if (widget.showHorizontalScrollbar) {
      scrollableWidget = Scrollbar(
        controller: _horizontalController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,
          child: scrollableWidget,
        ),
      );
    } else {
      scrollableWidget = SingleChildScrollView(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        child: scrollableWidget,
      );
    }

    if (widget.showVerticalScrollbar) {
      return Scrollbar(
        controller: _verticalController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _verticalController,
          child: scrollableWidget,
        ),
      );
    } else {
      return SingleChildScrollView(
        controller: _verticalController,
        child: scrollableWidget,
      );
    }
  }

  /// Builds the column headers for the data table
  ///
  /// This method creates DataColumn objects for each visible column in the table definition,
  /// and adds the actions column if configured.
  List<DataColumn> _buildColumns() {
    List<DataColumn> columns = [];

    // Get all columns including joined table columns
    final allColumns = widget.tableDefinition.getAllColumns();

    // Filter out hidden columns
    final visibleColumns = allColumns
        .where((column) => !widget.hiddenColumns.contains(column.columnName))
        .toList();

    // Sort columns based on columnOrder if provided
    if (widget.columnOrder.isNotEmpty) {
      visibleColumns.sort((a, b) {
        final aIndex = widget.columnOrder.indexOf(a.columnName);
        final bIndex = widget.columnOrder.indexOf(b.columnName);

        // If both columns are in the columnOrder, sort by their index
        if (aIndex >= 0 && bIndex >= 0) {
          return aIndex.compareTo(bIndex);
        }

        // If only one column is in the columnOrder, it comes first
        if (aIndex >= 0) return -1;
        if (bIndex >= 0) return 1;

        // If neither column is in the columnOrder, maintain their original order
        return allColumns.indexOf(a).compareTo(allColumns.indexOf(b));
      });
    }

    // Add actions column at the start if configured
    if (widget.showActionsColumn &&
        widget.actionsColumnPosition == ActionsColumnPosition.start) {
      columns.add(_buildActionsColumn());
    }

    // Add data columns
    columns.addAll(visibleColumns.map((column) {
      final displayName = widget.columnNameMapper != null
          ? widget.columnNameMapper!(column.columnName)
          : column.columnName;

      String? tooltip;
      if (widget.showDataTypeTooltips) {
        // Check if a custom tooltip is provided for this column
        if (widget.columnTooltips.containsKey(column.columnName)) {
          tooltip = widget.columnTooltips[column.columnName];
        } else if (widget.tooltipMapper != null) {
          tooltip = widget.tooltipMapper!(
              column.columnName, column.dataType, column.isNullable);
        } else {
          tooltip =
              '${column.dataType.toString().split('.').last} ${column.isNullable ? '(nullable)' : ''}';
        }
      }

      return DataColumn(
        label: Expanded(
          child: Text(
            displayName,
            style: widget.headerTextStyle ??
                const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        tooltip: tooltip,
      );
    }).toList());

    // Add actions column at the end if configured
    if (widget.showActionsColumn &&
        widget.actionsColumnPosition == ActionsColumnPosition.end) {
      columns.add(_buildActionsColumn());
    }

    return columns;
  }

  /// Builds the actions column header
  ///
  /// Creates a DataColumn for the actions column with the configured title.
  DataColumn _buildActionsColumn() {
    return DataColumn(
      label: Expanded(
        child: Text(
          widget.actionsColumnTitle,
          style: widget.headerTextStyle ??
              const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Gets the value from a nested object using dot notation
  /// Example: getValue(data, 'users.name') will return data['users']['name']
  dynamic _getNestedValue(Map<String, dynamic> data, String path) {
    final parts = path.split('.');
    dynamic value = data;

    for (final part in parts) {
      if (value is Map) {
        value = value[part];
      } else {
        return null;
      }
    }

    return value;
  }

  /// Builds the data rows for the table
  ///
  /// Creates DataRow objects for each item in the data list, with cells
  /// corresponding to the visible columns.
  List<DataRow> _buildRows() {
    return widget.data.map((rowData) {
      // Convert rowData to a Map<String, dynamic> if it's not already
      final Map<String, dynamic> rowDataMap = rowData is Map<String, dynamic>
          ? rowData
          : Map.fromEntries((rowData as Map)
              .entries
              .map((e) => MapEntry(e.key.toString(), e.value)));

      List<DataCell> cells = [];

      // Get all columns including joined table columns
      final allColumns = widget.tableDefinition.getAllColumns();

      // Filter out hidden columns
      final visibleColumns = allColumns
          .where((column) => !widget.hiddenColumns.contains(column.columnName))
          .toList();

      // Sort columns based on columnOrder if provided
      if (widget.columnOrder.isNotEmpty) {
        visibleColumns.sort((a, b) {
          final aIndex = widget.columnOrder.indexOf(a.columnName);
          final bIndex = widget.columnOrder.indexOf(b.columnName);

          // If both columns are in the columnOrder, sort by their index
          if (aIndex >= 0 && bIndex >= 0) {
            return aIndex.compareTo(bIndex);
          }

          // If only one column is in the columnOrder, it comes first
          if (aIndex >= 0) return -1;
          if (bIndex >= 0) return 1;

          // If neither column is in the columnOrder, maintain their original order
          return allColumns.indexOf(a).compareTo(allColumns.indexOf(b));
        });
      }

      // Add actions cell at the start if configured
      if (widget.showActionsColumn &&
          widget.actionsColumnPosition == ActionsColumnPosition.start) {
        cells.add(_buildActionsCell(rowDataMap));
      }

      // Add data cells
      cells.addAll(visibleColumns.map((column) {
        final value = _getNestedValue(rowDataMap, column.columnName);

        // Check for enhanced custom cell builder first
        if (widget.advancedCustomCellBuilders != null &&
            widget.advancedCustomCellBuilders!.containsKey(column.columnName)) {
          return DataCell(
            widget.advancedCustomCellBuilders![column.columnName]!(
                value, column, rowDataMap),
            onTap: widget.enableRowSelection
                ? () => _handleRowTap(rowDataMap)
                : null,
          );
        }

        // Then check for simple custom cell builder
        if (widget.customCellBuilders != null &&
            widget.customCellBuilders!.containsKey(column.columnName)) {
          return DataCell(
            widget.customCellBuilders![column.columnName]!(value),
            onTap: widget.enableRowSelection
                ? () => _handleRowTap(rowDataMap)
                : null,
          );
        }

        return DataCell(
          _buildCellWidget(value, column.dataType, column.columnName),
          onTap: widget.enableRowSelection
              ? () => _handleRowTap(rowDataMap)
              : null,
        );
      }).toList());

      // Add actions cell at the end if configured
      if (widget.showActionsColumn &&
          widget.actionsColumnPosition == ActionsColumnPosition.end) {
        cells.add(_buildActionsCell(rowDataMap));
      }

      return DataRow(cells: cells);
    }).toList();
  }

  /// Builds a cell for the actions column
  ///
  /// Creates a DataCell containing the widget returned by the actionBuilder,
  /// or an empty widget if no builder is provided.
  DataCell _buildActionsCell(Map<String, dynamic> rowData) {
    return DataCell(
      widget.actionBuilder != null
          ? widget.actionBuilder!(rowData)
          : const SizedBox.shrink(),
    );
  }

  /// Handles row selection when a row is tapped
  ///
  /// Calls the onRowSelected callback with the row data if provided.
  void _handleRowTap(Map<String, dynamic> rowData) {
    if (widget.onRowSelected != null) {
      widget.onRowSelected!(rowData);
    }
  }

  /// Builds a widget to display a cell value based on its data type
  ///
  /// This method formats and displays values differently depending on their PostgreSQL data type.
  /// For example, dates are formatted as dates, booleans as checkmarks, etc.
  Widget _buildCellWidget(
      dynamic value, PostgresDataType dataType, String columnName) {
    if (value == null) {
      return const Text('NULL',
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey));
    }

    try {
      switch (dataType) {
        // Numeric Types
        case PostgresDataType.smallint:
        case PostgresDataType.integer:
        case PostgresDataType.bigint:
        case PostgresDataType.serial:
        case PostgresDataType.bigserial:
          return Text(
            value.toString(),
            style: widget.cellTextStyle,
          );

        case PostgresDataType.decimal:
        case PostgresDataType.numeric:
        case PostgresDataType.real:
        case PostgresDataType.doublePrecision:
          final num numValue =
              value is num ? value : num.tryParse(value.toString()) ?? 0;
          return Text(
            NumberFormat('#,##0.00').format(numValue),
            style: widget.cellTextStyle,
          );

        // Character Types
        case PostgresDataType.characterVarying:
        case PostgresDataType.character:
        case PostgresDataType.text:
          // Check if we have a dropdown option mapper for this column
          if (widget.dropdownOptionMappers.containsKey(columnName)) {
            final optionMapper = widget.dropdownOptionMappers[columnName];
            if (optionMapper != null &&
                optionMapper.containsKey(value.toString())) {
              // Use the mapped display value
              return Text(
                optionMapper[value.toString()]!,
                style: widget.cellTextStyle,
              );
            }
          }
          return Text(
            value.toString(),
            style: widget.cellTextStyle,
          );

        // Date & Time Types
        case PostgresDataType.date:
          DateTime? date;
          if (value is DateTime) {
            date = value;
          } else if (value is String) {
            try {
              date = DateTime.parse(value);
            } catch (_) {
              return Text(value, style: widget.cellTextStyle);
            }
          }
          return date != null
              ? Text(DateFormat('yyyy-MM-dd').format(date),
                  style: widget.cellTextStyle)
              : Text(value.toString(), style: widget.cellTextStyle);

        case PostgresDataType.timestamp:
        case PostgresDataType.timestampWithTimeZone:
          DateTime? date;
          if (value is DateTime) {
            date = value;
          } else if (value is String) {
            try {
              date = DateTime.parse(value);
            } catch (_) {
              return Text(value, style: widget.cellTextStyle);
            }
          }
          return date != null
              ? Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(date),
                  style: widget.cellTextStyle)
              : Text(value.toString(), style: widget.cellTextStyle);

        case PostgresDataType.time:
        case PostgresDataType.timeWithTimeZone:
          return Text(value.toString(), style: widget.cellTextStyle);

        case PostgresDataType.interval:
          return Text(value.toString(), style: widget.cellTextStyle);

        // Boolean Type
        case PostgresDataType.boolean:
          bool boolValue;
          if (value is bool) {
            boolValue = value;
          } else if (value is String) {
            boolValue =
                value.toLowerCase() == 'true' || value == 't' || value == '1';
          } else if (value is num) {
            boolValue = value != 0;
          } else {
            return Text(value.toString(), style: widget.cellTextStyle);
          }

          return Icon(
            boolValue ? Icons.check_circle : Icons.cancel,
            color: boolValue ? Colors.green : Colors.red,
          );

        // UUID Type
        case PostgresDataType.uuid:
          return Text(
            value.toString(),
            style: widget.cellTextStyle != null
                ? widget.cellTextStyle!.copyWith(fontFamily: 'monospace')
                : const TextStyle(fontFamily: 'monospace'),
          );

        // JSON Types
        case PostgresDataType.json:
        case PostgresDataType.jsonb:
          return Tooltip(
            message: value.toString(),
            child: Text(
              'JSON',
              style: widget.cellTextStyle != null
                  ? widget.cellTextStyle!.copyWith(
                      color: Colors.blue, decoration: TextDecoration.underline)
                  : const TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
            ),
          );

        // Array Types
        case PostgresDataType.integerArray:
        case PostgresDataType.textArray:
        case PostgresDataType.uuidArray:
          List<dynamic> array;
          if (value is List) {
            array = value;
          } else if (value is String &&
              (value.startsWith('{') && value.endsWith('}'))) {
            // Handle PostgreSQL array format like '{1,2,3}'
            array = value.substring(1, value.length - 1).split(',');
          } else if (value is String) {
            // Try to handle other string formats
            array = value.split(',');
          } else {
            return Text(value.toString(), style: widget.cellTextStyle);
          }

          return Tooltip(
            message: array.join(', '),
            child: Text(
              'Array[${array.length}]',
              style: widget.cellTextStyle != null
                  ? widget.cellTextStyle!.copyWith(color: Colors.blue)
                  : const TextStyle(color: Colors.blue),
            ),
          );

        // Geometric Types
        case PostgresDataType.point:
        case PostgresDataType.line:
        case PostgresDataType.lseg:
        case PostgresDataType.box:
        case PostgresDataType.path:
        case PostgresDataType.polygon:
        case PostgresDataType.circle:
          return Tooltip(
            message: value.toString(),
            child: Text(
              'Geometric',
              style: widget.cellTextStyle != null
                  ? widget.cellTextStyle!.copyWith(color: Colors.purple)
                  : const TextStyle(color: Colors.purple),
            ),
          );

        // Custom Types
        case PostgresDataType.userDefined:
          // For user-defined types, check if we have a dropdown option mapper for this column
          if (widget.dropdownOptionMappers.containsKey(columnName)) {
            final optionMapper = widget.dropdownOptionMappers[columnName];
            if (optionMapper != null &&
                optionMapper.containsKey(value.toString())) {
              // Use the mapped display value
              return Text(
                optionMapper[value.toString()]!,
                style: widget.cellTextStyle,
              );
            }
          }
          return Text(value.toString(), style: widget.cellTextStyle);

        default:
          return Text(value.toString(), style: widget.cellTextStyle);
      }
    } catch (e) {
      // Fallback for any errors during rendering
      return Text(
        value.toString(),
        style: widget.cellTextStyle != null
            ? widget.cellTextStyle!.copyWith(color: Colors.red)
            : const TextStyle(color: Colors.red),
      );
    }
  }
}
