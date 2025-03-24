import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:postgress_table_form/postgress_table_form.dart';

/// Enum defining the CRUD operations available in the CrudTable
enum CrudOperations {
  /// Creates new records in the table
  create,

  /// Updates existing records in the table
  update,

  /// Deletes records from the table
  delete,
}

/// A widget that combines a dynamic table view with form-based CRUD operations
///
/// This widget provides a complete solution for displaying tabular data with
/// built-in support for creating, updating, and deleting records through forms.
class CrudTable extends StatefulWidget {
  /// The definition of the table structure
  final TableDefinitionModel tableDefinition;

  /// Function that fetches data for the table
  ///
  /// This function should return a Future that resolves to a tuple containing:
  /// - A list of records (maps) where each record is a map with column names as keys and values as data
  /// - The total count of records (used for pagination)
  ///
  /// The function receives the current page, page size, search text, and optional column name parameters.
  /// When columnName is null, it should search across all columns. When columnName is provided,
  /// it should search only within that specific column.
  ///
  /// Example:
  /// ```dart
  /// getData: (page, pageSize, searchText, columnName) async {
  ///   String query;
  ///   List<dynamic> params;
  ///
  ///   if (columnName != null) {
  ///     // Column-specific search
  ///     query = 'SELECT * FROM users WHERE $columnName LIKE ? LIMIT ? OFFSET ?';
  ///     params = ['%$searchText%', pageSize, (page - 1) * pageSize];
  ///   } else {
  ///     // Search across multiple columns
  ///     query = 'SELECT * FROM users WHERE name LIKE ? OR email LIKE ? LIMIT ? OFFSET ?';
  ///     params = ['%$searchText%', '%$searchText%', pageSize, (page - 1) * pageSize];
  ///   }
  ///
  ///   final result = await database.query(query, params);
  ///   final countResult = await database.query(/* count query */);
  ///   return (result, countResult[0]['count']);
  /// }
  /// ```
  final Future<(List<Map<String, dynamic>>, int)> Function(
      int page, int pageSize, String searchText, String? columnName) getData;

  /// Callback for when a record is created
  ///
  /// This function is called with the form data when a new record is created.
  /// It should return a Future that resolves to a boolean indicating success.
  final Future<bool> Function(Map<String, dynamic> formData)? onCreate;

  /// Callback for when a record is updated
  ///
  /// This function is called with the form data when a record is updated.
  /// It should return a Future that resolves to a boolean indicating success.
  final Future<bool> Function(Map<String, dynamic> formData)? onUpdate;

  /// Callback for when a record is deleted
  ///
  /// This function is called with the row data when a record is deleted.
  /// It should return a Future that resolves to a boolean indicating success.
  final Future<bool> Function(Map<String, dynamic> rowData)? onDelete;

  /// Set of allowed CRUD operations
  ///
  /// This determines which operations (create, update, delete) are available
  /// in the table UI.
  final Set<CrudOperations> allowedOperations;

  /// Title for the create form dialog
  final String createFormTitle;

  /// Title for the update form dialog
  final String updateFormTitle;

  /// Confirmation message for delete operations
  final String deleteConfirmationMessage;

  /// Text for the create button
  final String createButtonText;

  /// Text for the submit button in the create form
  final String createSubmitButtonText;

  /// Text for the submit button in the update form
  final String updateSubmitButtonText;

  /// Text for the delete button
  final String deleteButtonText;

  /// Text for the edit button
  final String editButtonText;

  /// Text for the cancel button in dialogs
  final String cancelButtonText;

  /// Text for the confirm button in the delete confirmation dialog
  final String confirmDeleteButtonText;

  /// Title for the actions column
  ///
  /// The text displayed in the header of the actions column.
  /// Default is 'Actions'
  final String actionsColumnTitle;

  /// Map of column names to custom display names
  ///
  /// This allows customizing how column names are displayed in both
  /// the table headers and form field labels.
  final Map<String, String> columnNameMapper;

  /// Map of column names to help text for form fields
  final Map<String, String> helpTexts;

  /// Map of column names to hint text for form fields
  final Map<String, String> hintTexts;

  /// Map of column names to dropdown option mappers
  ///
  /// This allows customizing how dropdown options are displayed in both
  /// the table cells and form fields.
  final Map<String, Map<String, String>> dropdownOptionMappers;

  /// List of column names to hide in the table
  final List<String> hiddenTableColumns;

  /// List of column names to hide in the form
  final List<String> hiddenFormFields;

  /// Custom order for columns in the table
  final List<String> tableColumnOrder;

  /// Custom order for fields in the form
  final List<String> formFieldOrder;

  /// List of column names that should be readonly in the form
  final List<String> readonlyFields;

  /// If true, all fields will be readonly in the form unless specified in [editableFields]
  final bool allFieldsReadonly;

  /// List of column names that should be editable in the form (used when [allFieldsReadonly] is true)
  final List<String> editableFields;

  /// Map of column names to custom validation functions for form fields
  final Map<String, String? Function(dynamic value)> customValidators;

  /// List of form-level validation functions for the form
  final List<FormValidation> formValidations;

  /// List of field groups for organizing form fields
  final List<FieldGroup> fieldGroups;

  /// If true, fields not included in any group will be displayed at the top of the form
  final bool ungroupedFieldsAtTop;

  /// Custom styling for the table header row
  final Color? headerBackgroundColor;

  /// Custom styling for the table header text
  final TextStyle? headerTextStyle;

  /// Custom styling for table cell text
  final TextStyle? cellTextStyle;

  /// Whether to show tooltips for column data types in the table
  final bool showDataTypeTooltips;

  /// Custom row height for the table
  final double? rowHeight;

  /// Custom column spacing for the table
  final double? columnSpacing;

  /// Whether to show a horizontal scrollbar for the table
  // final bool showHorizontalScrollbar;

  // /// Whether to show a vertical scrollbar for the table
  // final bool showVerticalScrollbar;

  /// Custom cell builders for specific columns in the table
  final Map<String, Widget Function(dynamic value)>? customCellBuilders;

  /// Enhanced custom cell builders for specific columns in the table
  final Map<String, CustomCellBuilder>? advancedCustomCellBuilders;

  /// Custom tooltip mapper for the table
  final TooltipMapper? tooltipMapper;

  /// Custom styling for the table
  final DataTableThemeData? tableTheme;

  /// Text to display for null values in the table
  ///
  /// This text will be shown in the table cells when a value is null.
  /// Default is an empty string
  final String nullValueText;

  /// Whether to show a search field above the table
  ///
  /// When true, a search field will be displayed above the table,
  /// allowing users to filter the table data.
  /// Default is false
  final bool showSearchField;

  /// Callback for when the search text changes
  ///
  /// This function is called with the search text when the user types in the search field.
  /// It is debounced according to [searchDebounceTime].
  final Function(String)? onSearch;

  /// Hint text for the search field
  ///
  /// The placeholder text displayed in the search field.
  /// Default is 'Search...'
  final String searchHintText;

  /// Debounce time for search in milliseconds
  ///
  /// The time to wait after the user stops typing before triggering the search.
  /// Default is 300 milliseconds
  final int searchDebounceTime;

  /// Whether to enable column-specific search
  ///
  /// When true, a column selector will be displayed next to the search field,
  /// allowing users to search on specific columns.
  /// Default is false
  final bool enableColumnSearch;

  /// List of column names available for search
  ///
  /// If provided, only these columns will be available for selection in the column search dropdown.
  /// If not provided, all visible columns will be available for search.
  final List<String> searchableColumns;

  /// Hint text for the column search dropdown
  ///
  /// The placeholder text displayed in the column search dropdown.
  /// Default is 'Select column'
  final String columnSearchHintText;

  /// Text for the "Search All" option in the column search dropdown
  ///
  /// This is the text shown for the option that searches across all columns.
  /// Default is 'Search All'
  final String searchAllText;

  /// Key to access the CrudTable state
  ///
  /// Use this key to access pagination methods like setPageSize and refreshData.
  /// Example:
  /// ```dart
  /// final crudTableKey = GlobalKey<CrudTableState>();
  ///
  /// CrudTable(
  ///   key: crudTableKey,
  ///   ...
  /// );
  ///
  /// // Later in your code:
  /// crudTableKey.currentState?.setPageSize(25);
  /// crudTableKey.currentState?.refreshData();
  /// ```
  final GlobalKey<CrudTableState>? tableKey;

  /// Additional action builder for custom action buttons
  ///
  /// This function receives the row data as a Map and should return a Widget
  /// that will be displayed alongside the default edit and delete buttons.
  ///
  /// Example:
  /// ```dart
  /// additionalActionBuilder: (rowData) => IconButton(
  ///   icon: const Icon(Icons.visibility, color: Colors.green),
  ///   tooltip: 'View Details',
  ///   onPressed: () => showDetails(rowData),
  /// ),
  /// ```
  final ActionBuilder? additionalActionBuilder;

  /// Available options for page size in the dropdown
  ///
  /// This list determines what page size options are available in the dropdown.
  /// Default is [5, 10, 25, 50, 100]
  final List<int> pageSizeOptions;

  /// Initial page size for the table
  ///
  /// This determines how many records are displayed per page when the table is first loaded.
  /// Default is 10
  final int initialPageSize;

  /// Custom widget to display when there is no data
  ///
  /// When provided, this widget will be displayed instead of the default "No data available" text
  /// when the table has no records to display.
  final Widget? noDataWidget;

  /// Whether to show the refresh button
  ///
  /// When true, a refresh button will be displayed that allows users to manually
  /// refresh the table data.
  /// Default is true
  final bool showRefreshButton;

  /// Whether to automatically convert all text input to uppercase
  ///
  /// When true, all text input in forms will be automatically converted to uppercase
  /// while the user is typing.
  /// Default is true
  final bool allTextCapitalized;

  /// Constructs a CRUD table with the specified parameters
  const CrudTable({
    super.key,
    this.tableKey,
    required this.tableDefinition,
    required this.getData,
    this.onCreate,
    this.onUpdate,
    this.onDelete,
    this.allowedOperations = const {
      CrudOperations.create,
      CrudOperations.update,
      CrudOperations.delete
    },
    this.createFormTitle = 'Create New Record',
    this.updateFormTitle = 'Edit Record',
    this.deleteConfirmationMessage =
        'Are you sure you want to delete this record?',
    this.createButtonText = 'Create New',
    this.createSubmitButtonText = 'Create',
    this.updateSubmitButtonText = 'Update',
    this.deleteButtonText = 'Delete',
    this.editButtonText = 'Edit',
    this.cancelButtonText = 'Cancel',
    this.confirmDeleteButtonText = 'Delete',
    this.actionsColumnTitle = 'Actions',
    this.columnNameMapper = const {},
    this.helpTexts = const {},
    this.hintTexts = const {},
    this.dropdownOptionMappers = const {},
    this.hiddenTableColumns = const [],
    this.hiddenFormFields = const [],
    this.tableColumnOrder = const [],
    this.formFieldOrder = const [],
    this.readonlyFields = const [],
    this.allFieldsReadonly = false,
    this.editableFields = const [],
    this.customValidators = const {},
    this.formValidations = const [],
    this.fieldGroups = const [],
    this.ungroupedFieldsAtTop = false,
    this.headerBackgroundColor,
    this.headerTextStyle,
    this.cellTextStyle,
    this.showDataTypeTooltips = true,
    this.rowHeight,
    this.columnSpacing,
    // this.showHorizontalScrollbar = true,
    // this.showVerticalScrollbar = true,
    this.customCellBuilders,
    this.advancedCustomCellBuilders,
    this.tooltipMapper,
    this.tableTheme,
    this.additionalActionBuilder,
    this.pageSizeOptions = const [5, 10, 25, 50, 100],
    this.initialPageSize = 10,
    this.nullValueText = '',
    this.showSearchField = false,
    this.onSearch,
    this.searchHintText = 'Search...',
    this.searchDebounceTime = 300,
    this.enableColumnSearch = false,
    this.searchableColumns = const [],
    this.columnSearchHintText = 'Select column',
    this.searchAllText = 'Search All',
    this.noDataWidget,
    this.showRefreshButton = true,
    this.allTextCapitalized = true,
  });

  @override
  CrudTableState createState() => CrudTableState();

  /// Creates a CrudTable from a Future that resolves to a TableDefinitionModel
  ///
  /// This factory constructor is useful when you need to load the table definition
  /// asynchronously, such as from an API or database.
  ///
  /// Example:
  /// ```dart
  /// CrudTable.fromFuture(
  ///   tableDefinitionFuture: fetchTableDefinition(),
  ///   getData: (page, pageSize, searchText, columnName) async {
  ///     final result = await api.fetchData(page, pageSize, searchText, columnName);
  ///     final count = await api.fetchCount(searchText);
  ///     return (result, count);
  ///   },
  ///   // ... other parameters
  /// )
  /// ```
  static Widget fromFuture({
    Key? key,
    required Future<TableDefinitionModel> tableDefinitionFuture,
    required Future<(List<Map<String, dynamic>>, int)> Function(
            int page, int pageSize, String searchText, String? columnName)
        getData,
    Future<bool> Function(Map<String, dynamic> formData)? onCreate,
    Future<bool> Function(Map<String, dynamic> formData)? onUpdate,
    Future<bool> Function(Map<String, dynamic> rowData)? onDelete,
    Set<CrudOperations> allowedOperations = const {
      CrudOperations.create,
      CrudOperations.update,
      CrudOperations.delete
    },
    String createFormTitle = 'Create New Record',
    String updateFormTitle = 'Edit Record',
    String deleteConfirmationMessage =
        'Are you sure you want to delete this record?',
    String createButtonText = 'Create New',
    String createSubmitButtonText = 'Create',
    String updateSubmitButtonText = 'Update',
    String deleteButtonText = 'Delete',
    String editButtonText = 'Edit',
    String cancelButtonText = 'Cancel',
    String confirmDeleteButtonText = 'Delete',
    String actionsColumnTitle = 'Actions',
    Map<String, String> columnNameMapper = const {},
    Map<String, String> helpTexts = const {},
    Map<String, String> hintTexts = const {},
    Map<String, Map<String, String>> dropdownOptionMappers = const {},
    List<String> hiddenTableColumns = const [],
    List<String> hiddenFormFields = const [],
    List<String> tableColumnOrder = const [],
    List<String> formFieldOrder = const [],
    List<String> readonlyFields = const [],
    bool allFieldsReadonly = false,
    List<String> editableFields = const [],
    Map<String, String? Function(dynamic value)> customValidators = const {},
    List<FormValidation> formValidations = const [],
    List<FieldGroup> fieldGroups = const [],
    bool ungroupedFieldsAtTop = false,
    Color? headerBackgroundColor,
    TextStyle? headerTextStyle,
    TextStyle? cellTextStyle,
    bool showDataTypeTooltips = true,
    double? rowHeight,
    double? columnSpacing,
    bool showHorizontalScrollbar = true,
    bool showVerticalScrollbar = true,
    Map<String, Widget Function(dynamic value)>? customCellBuilders,
    Map<String, CustomCellBuilder>? advancedCustomCellBuilders,
    TooltipMapper? tooltipMapper,
    DataTableThemeData? tableTheme,
    GlobalKey<CrudTableState>? tableKey,
    ActionBuilder? additionalActionBuilder,
    List<int> pageSizeOptions = const [5, 10, 25, 50, 100],
    int initialPageSize = 10,
    String nullValueText = '',
    bool showSearchField = false,
    Function(String)? onSearch,
    String searchHintText = 'Search...',
    int searchDebounceTime = 300,
    bool enableColumnSearch = false,
    List<String> searchableColumns = const [],
    String columnSearchHintText = 'Select column',
    String searchAllText = 'Search All',
    Widget? noDataWidget,
    bool showRefreshButton = true,
    bool allTextCapitalized = true,
  }) {
    return FutureBuilder<TableDefinitionModel>(
      future: tableDefinitionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading table definition: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text('No table definition available'),
          );
        }

        return CrudTable(
          key: key,
          tableKey: tableKey,
          tableDefinition: snapshot.data!,
          getData: getData,
          onCreate: onCreate,
          onUpdate: onUpdate,
          onDelete: onDelete,
          allowedOperations: allowedOperations,
          createFormTitle: createFormTitle,
          updateFormTitle: updateFormTitle,
          deleteConfirmationMessage: deleteConfirmationMessage,
          createButtonText: createButtonText,
          createSubmitButtonText: createSubmitButtonText,
          updateSubmitButtonText: updateSubmitButtonText,
          deleteButtonText: deleteButtonText,
          editButtonText: editButtonText,
          cancelButtonText: cancelButtonText,
          confirmDeleteButtonText: confirmDeleteButtonText,
          actionsColumnTitle: actionsColumnTitle,
          columnNameMapper: columnNameMapper,
          helpTexts: helpTexts,
          hintTexts: hintTexts,
          dropdownOptionMappers: dropdownOptionMappers,
          hiddenTableColumns: hiddenTableColumns,
          hiddenFormFields: hiddenFormFields,
          tableColumnOrder: tableColumnOrder,
          formFieldOrder: formFieldOrder,
          readonlyFields: readonlyFields,
          allFieldsReadonly: allFieldsReadonly,
          editableFields: editableFields,
          customValidators: customValidators,
          formValidations: formValidations,
          fieldGroups: fieldGroups,
          ungroupedFieldsAtTop: ungroupedFieldsAtTop,
          headerBackgroundColor: headerBackgroundColor,
          headerTextStyle: headerTextStyle,
          cellTextStyle: cellTextStyle,
          showDataTypeTooltips: showDataTypeTooltips,
          rowHeight: rowHeight,
          columnSpacing: columnSpacing,
          // showHorizontalScrollbar: showHorizontalScrollbar,
          // showVerticalScrollbar: showVerticalScrollbar,
          customCellBuilders: customCellBuilders,
          advancedCustomCellBuilders: advancedCustomCellBuilders,
          tooltipMapper: tooltipMapper,
          tableTheme: tableTheme,
          additionalActionBuilder: additionalActionBuilder,
          pageSizeOptions: pageSizeOptions,
          initialPageSize: initialPageSize,
          nullValueText: nullValueText,
          showSearchField: showSearchField,
          onSearch: onSearch,
          searchHintText: searchHintText,
          searchDebounceTime: searchDebounceTime,
          enableColumnSearch: enableColumnSearch,
          searchableColumns: searchableColumns,
          columnSearchHintText: columnSearchHintText,
          searchAllText: searchAllText,
          noDataWidget: noDataWidget,
          showRefreshButton: showRefreshButton,
          allTextCapitalized: allTextCapitalized,
        );
      },
    );
  }

  /// Creates a CrudTable from a list of data
  ///
  /// This factory constructor is useful when you already have all the data and don't need pagination.
  /// It automatically handles pagination for the in-memory list.
  ///
  /// Example:
  /// ```dart
  /// CrudTable.fromList(
  ///   tableDefinition: myTableDefinition,
  ///   data: myDataList,
  ///   // ... other parameters
  /// )
  /// ```
  factory CrudTable.fromList({
    Key? key,
    required TableDefinitionModel tableDefinition,
    required List<Map<String, dynamic>> data,
    Future<bool> Function(Map<String, dynamic> formData)? onCreate,
    Future<bool> Function(Map<String, dynamic> formData)? onUpdate,
    Future<bool> Function(Map<String, dynamic> rowData)? onDelete,
    Set<CrudOperations> allowedOperations = const {
      CrudOperations.create,
      CrudOperations.update,
      CrudOperations.delete
    },
    String createFormTitle = 'Create New Record',
    String updateFormTitle = 'Edit Record',
    String deleteConfirmationMessage =
        'Are you sure you want to delete this record?',
    String createButtonText = 'Create New',
    String createSubmitButtonText = 'Create',
    String updateSubmitButtonText = 'Update',
    String deleteButtonText = 'Delete',
    String editButtonText = 'Edit',
    String cancelButtonText = 'Cancel',
    String confirmDeleteButtonText = 'Delete',
    String actionsColumnTitle = 'Actions',
    Map<String, String> columnNameMapper = const {},
    Map<String, String> helpTexts = const {},
    Map<String, String> hintTexts = const {},
    Map<String, Map<String, String>> dropdownOptionMappers = const {},
    List<String> hiddenTableColumns = const [],
    List<String> hiddenFormFields = const [],
    List<String> tableColumnOrder = const [],
    List<String> formFieldOrder = const [],
    List<String> readonlyFields = const [],
    bool allFieldsReadonly = false,
    List<String> editableFields = const [],
    Map<String, String? Function(dynamic value)> customValidators = const {},
    List<FormValidation> formValidations = const [],
    List<FieldGroup> fieldGroups = const [],
    bool ungroupedFieldsAtTop = false,
    Color? headerBackgroundColor,
    TextStyle? headerTextStyle,
    TextStyle? cellTextStyle,
    bool showDataTypeTooltips = true,
    double? rowHeight,
    double? columnSpacing,
    bool showHorizontalScrollbar = true,
    bool showVerticalScrollbar = true,
    Map<String, Widget Function(dynamic value)>? customCellBuilders,
    Map<String, CustomCellBuilder>? advancedCustomCellBuilders,
    TooltipMapper? tooltipMapper,
    DataTableThemeData? tableTheme,
    GlobalKey<CrudTableState>? tableKey,
    ActionBuilder? additionalActionBuilder,
    List<int> pageSizeOptions = const [5, 10, 25, 50, 100],
    int initialPageSize = 10,
    String nullValueText = '',
    bool showSearchField = false,
    Function(String)? onSearch,
    String searchHintText = 'Search...',
    int searchDebounceTime = 300,
    bool enableColumnSearch = false,
    List<String> searchableColumns = const [],
    String columnSearchHintText = 'Select column',
    String searchAllText = 'Search All',
    Widget? noDataWidget,
    bool showRefreshButton = true,
    bool allTextCapitalized = true,
  }) {
    // Keep track of the current search text for total count calculation
    String currentSearchText = '';
    String? currentSearchColumn;

    return CrudTable(
      key: key,
      tableKey: tableKey,
      tableDefinition: tableDefinition,
      getData: (page, pageSize, searchText, columnName) async {
        // Update the current search parameters
        currentSearchText = searchText;
        currentSearchColumn = columnName;

        // Filter data based on search text and column
        List<Map<String, dynamic>> filteredData;

        if (searchText.isEmpty) {
          // If no search text, return all data
          filteredData = data;
        } else if (columnName != null) {
          // Filter by specific column
          filteredData = data.where((item) {
            // Check if the item has the column
            if (!item.containsKey(columnName)) return false;

            final value = item[columnName];
            if (value == null) return false;

            // Case-insensitive contains search
            return value
                .toString()
                .toLowerCase()
                .contains(searchText.toLowerCase());
          }).toList();
        } else {
          // Search across all columns
          filteredData =
              data.where((item) => _matchesSearch(item, searchText)).toList();
        }

        // Calculate pagination for the in-memory list
        final int startIndex = (page - 1) * pageSize;
        final int endIndex = startIndex + pageSize > filteredData.length
            ? filteredData.length
            : startIndex + pageSize;

        // Return a subset of the data based on the requested page
        final List<Map<String, dynamic>> pagedData =
            startIndex < filteredData.length
                ? filteredData.sublist(startIndex, endIndex)
                : [];

        // Return tuple with data and total count
        return (pagedData, filteredData.length);
      },
      onCreate: onCreate,
      onUpdate: onUpdate,
      onDelete: onDelete,
      allowedOperations: allowedOperations,
      createFormTitle: createFormTitle,
      updateFormTitle: updateFormTitle,
      deleteConfirmationMessage: deleteConfirmationMessage,
      createButtonText: createButtonText,
      createSubmitButtonText: createSubmitButtonText,
      updateSubmitButtonText: updateSubmitButtonText,
      deleteButtonText: deleteButtonText,
      editButtonText: editButtonText,
      cancelButtonText: cancelButtonText,
      confirmDeleteButtonText: confirmDeleteButtonText,
      actionsColumnTitle: actionsColumnTitle,
      columnNameMapper: columnNameMapper,
      helpTexts: helpTexts,
      hintTexts: hintTexts,
      dropdownOptionMappers: dropdownOptionMappers,
      hiddenTableColumns: hiddenTableColumns,
      hiddenFormFields: hiddenFormFields,
      tableColumnOrder: tableColumnOrder,
      formFieldOrder: formFieldOrder,
      readonlyFields: readonlyFields,
      allFieldsReadonly: allFieldsReadonly,
      editableFields: editableFields,
      customValidators: customValidators,
      formValidations: formValidations,
      fieldGroups: fieldGroups,
      ungroupedFieldsAtTop: ungroupedFieldsAtTop,
      headerBackgroundColor: headerBackgroundColor,
      headerTextStyle: headerTextStyle,
      cellTextStyle: cellTextStyle,
      showDataTypeTooltips: showDataTypeTooltips,
      rowHeight: rowHeight,
      columnSpacing: columnSpacing,
      // showHorizontalScrollbar: showHorizontalScrollbar,
      // showVerticalScrollbar: showVerticalScrollbar,
      customCellBuilders: customCellBuilders,
      advancedCustomCellBuilders: advancedCustomCellBuilders,
      tooltipMapper: tooltipMapper,
      tableTheme: tableTheme,
      additionalActionBuilder: additionalActionBuilder,
      pageSizeOptions: pageSizeOptions,
      initialPageSize: initialPageSize,
      nullValueText: nullValueText,
      showSearchField: showSearchField,
      onSearch: onSearch,
      searchHintText: searchHintText,
      searchDebounceTime: searchDebounceTime,
      enableColumnSearch: enableColumnSearch,
      searchableColumns: searchableColumns,
      columnSearchHintText: columnSearchHintText,
      searchAllText: searchAllText,
      noDataWidget: noDataWidget,
      showRefreshButton: showRefreshButton,
      allTextCapitalized: allTextCapitalized,
    );
  }
}

/// State for the CrudTable widget
///
/// Provides methods for controlling pagination and refreshing data.
class CrudTableState extends State<CrudTable> {
  late Future<DynamicTableData> _dataFuture;

  // Pagination variables
  late int _currentPage;
  late int _pageSize;

  // Total count of records (used for pagination)
  int _totalCount = 0;

  // Form data
  Map<String, dynamic> _createFormData = {};
  Map<String, dynamic> _updateFormData = {};

  // Search state
  String _searchText = '';
  String? _selectedSearchColumn;
  String? _selectedDropdownValue;

  // Search controller and debounce timer
  late TextEditingController _searchController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _currentPage = 1;
    _pageSize = widget.initialPageSize;
    _searchController = TextEditingController();
    _setupSearchListener();
    _refreshData();
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      final text = _searchController.text;

      // Cancel previous timer if it exists
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer!.cancel();
      }

      // Set up new timer
      _debounceTimer =
          Timer(Duration(milliseconds: widget.searchDebounceTime), () {
        if (_searchText != text) {
          setState(() {
            _searchText = text;
            _currentPage = 1; // Reset to first page when searching
          });
          _refreshData();

          // Call the external onSearch if provided
          if (widget.onSearch != null) {
            widget.onSearch!(text);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// Updates the page size and refreshes the data
  ///
  /// This method changes the number of items displayed per page and resets
  /// to the first page. Use this when you want to change how many records
  /// are shown at once.
  void setPageSize(int newPageSize) {
    setState(() {
      _pageSize = newPageSize;
      _currentPage = 1; // Reset to first page when changing page size
      _refreshData();
    });
  }

  /// Gets the current page number
  ///
  /// This is useful for external components that need to know which page
  /// is currently being displayed.
  int get currentPage => _currentPage;

  /// Gets the current page size
  ///
  /// This is useful for external components that need to know how many
  /// records are being displayed per page.
  int get pageSize => _pageSize;

  /// Sets the current page number and refreshes the data
  ///
  /// Use this method to programmatically navigate to a specific page.
  /// This will trigger a new data fetch for the requested page.
  void goToPage(int page) {
    if (page < 1) page = 1;
    setState(() {
      _currentPage = page;
      _refreshData();
    });
  }

  /// Refreshes the table data
  ///
  /// This method reloads the data from the data source using the current
  /// pagination settings. Use this when you want to refresh the table
  /// after external changes to the data.
  void refreshData() {
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      // Get data based on search parameters (with or without column filter)
      _dataFuture = widget
          .getData(_currentPage, _pageSize, _searchText,
              widget.enableColumnSearch ? _selectedSearchColumn : null)
          .then((results) {
        final data = results.$1;
        final totalCount = results.$2;

        // Store the total count for pagination
        _totalCount = totalCount;

        // Convert the list result to a DynamicTableData object
        return DynamicTableData(
          tableDefinition: widget.tableDefinition,
          data: data,
          totalCount: _totalCount,
          currentPage: _currentPage,
          pageSize: _pageSize,
        );
      });
    });
  }

  // Helper method to determine if a column is a dropdown type
  bool _isDropdownColumn(String columnName) {
    return widget.dropdownOptionMappers.containsKey(columnName);
  }

  // Helper method to get a list of searchable columns
  List<String> _getSearchableColumns() {
    if (widget.searchableColumns.isNotEmpty) {
      // Filter out any columns that aren't in the table definition
      return widget.searchableColumns.where((column) {
        return widget.tableDefinition.getAllColumns().any(
              (col) => col.columnName == column,
            );
      }).toList();
    }

    // If no searchable columns are specified, use all visible columns
    return widget.tableDefinition
        .getAllColumns()
        .where(
            (column) => !widget.hiddenTableColumns.contains(column.columnName))
        .map((column) => column.columnName)
        .toList();
  }

  // Helper method to get display name for a column
  String _getColumnDisplayName(String columnName) {
    return widget.columnNameMapper[columnName] ?? columnName;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Create button and search field are always visible
        LayoutBuilder(
          builder: (context, constraints) {
            // For narrow screens (mobile), use vertical layout
            if (constraints.maxWidth < 600) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Action buttons in a row
                  Row(
                    children: [
                      if (widget.allowedOperations
                          .contains(CrudOperations.create))
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, right: 8.0),
                            child: _buildCreateButton(),
                          ),
                        ),
                      if (widget.showRefreshButton)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildRefreshButton(),
                        ),
                    ],
                  ),
                  // Search controls in vertical layout
                  if (widget.showSearchField)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (widget.enableColumnSearch)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _buildColumnSearchControls(),
                            ),
                          _isDropdownColumn(_selectedSearchColumn ?? '') &&
                                  _selectedSearchColumn != null
                              ? _buildDropdownSearch()
                              : _buildTextSearch(),
                        ],
                      ),
                    ),
                ],
              );
            } else {
              // For wider screens, use horizontal layout
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.allowedOperations.contains(CrudOperations.create))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
                      child: _buildCreateButton(),
                    ),
                  if (widget.showRefreshButton)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
                      child: _buildRefreshButton(),
                    ),
                  if (widget.showSearchField)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.enableColumnSearch)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SizedBox(
                                  width: 120,
                                  child: _buildColumnSearchControls(),
                                ),
                              ),
                            Expanded(
                              child: _isDropdownColumn(
                                          _selectedSearchColumn ?? '') &&
                                      _selectedSearchColumn != null
                                  ? _buildDropdownSearch()
                                  : _buildTextSearch(),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }
          },
        ),
        // Only the table content area shows loading state
        FutureBuilder<DynamicTableData>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading data: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: widget.noDataWidget ?? const Text('No data available'),
                ),
              );
            }

            return Column(
              children: [
                _buildTable(snapshot.data!),
                if (snapshot.data!.totalPages > 1)
                  _buildPagination(snapshot.data!),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return ElevatedButton.icon(
      onPressed: _showCreateForm,
      icon: const Icon(Icons.add),
      label: Text(widget.createButtonText),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildRefreshButton() {
    return IconButton(
      icon: const Icon(Icons.refresh),
      tooltip: 'Refresh Data',
      onPressed: _refreshData,
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildTable(DynamicTableData data) {
    return DynamicTableView(
      tableDefinition: widget.tableDefinition,
      data: data.data,
      showActionsColumn:
          widget.allowedOperations.contains(CrudOperations.update) ||
              widget.allowedOperations.contains(CrudOperations.delete) ||
              widget.additionalActionBuilder != null,
      actionBuilder: (rowData) => _buildActionButtons(rowData),
      actionsColumnTitle: widget.actionsColumnTitle,
      hiddenColumns: widget.hiddenTableColumns,
      columnOrder: widget.tableColumnOrder,
      columnNameMapper: widget.columnNameMapper != null
          ? (columnName) => widget.columnNameMapper[columnName] ?? columnName
          : null,
      tooltipMapper: widget.tooltipMapper,
      headerBackgroundColor: widget.headerBackgroundColor,
      headerTextStyle: widget.headerTextStyle,
      cellTextStyle: widget.cellTextStyle,
      showDataTypeTooltips: widget.showDataTypeTooltips,
      rowHeight: widget.rowHeight,
      columnSpacing: widget.columnSpacing,
      dropdownOptionMappers: widget.dropdownOptionMappers,
      customCellBuilders: widget.customCellBuilders,
      advancedCustomCellBuilders: widget.advancedCustomCellBuilders,
      tableTheme: widget.tableTheme,
      nullValueText: widget.nullValueText,
      showSearchField: false,
      searchHintText: widget.searchHintText,
      searchDebounceTime: widget.searchDebounceTime,
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> rowData) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.allowedOperations.contains(CrudOperations.update))
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            tooltip: widget.editButtonText,
            onPressed: () => _showUpdateForm(rowData),
          ),
        if (widget.allowedOperations.contains(CrudOperations.delete))
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: widget.deleteButtonText,
            onPressed: () => _confirmDelete(rowData),
          ),
        // Add custom action button if provided
        if (widget.additionalActionBuilder != null)
          widget.additionalActionBuilder!(rowData),
      ],
    );
  }

  Widget _buildPagination(DynamicTableData data) {
    // Update the current page and page size from the data
    // This ensures we're in sync with what the data source provided
    _currentPage = data.currentPage;
    _pageSize = data.pageSize;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.first_page),
                onPressed: _currentPage > 1 ? _goToFirstPage : null,
                tooltip: 'First Page',
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: data.hasPreviousPage ? _goToPreviousPage : null,
                tooltip: 'Previous Page',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Page $_currentPage of ${data.totalPages}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: data.hasNextPage ? _goToNextPage : null,
                tooltip: 'Next Page',
              ),
              IconButton(
                icon: const Icon(Icons.last_page),
                onPressed: _currentPage < data.totalPages
                    ? () => _goToLastPage(data.totalPages)
                    : null,
                tooltip: 'Last Page',
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Page size selector and record count
          LayoutBuilder(
            builder: (context, constraints) {
              // For wider screens, show in a single row
              if (constraints.maxWidth > 500) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Showing ${data.data.length} of ${data.totalCount} records',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    _buildPageSizeSelector(),
                  ],
                );
              } else {
                // For narrower screens, stack vertically
                return Column(
                  children: [
                    Text(
                      'Showing ${data.data.length} of ${data.totalCount} records',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    _buildPageSizeSelector(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageSizeSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Rows per page:',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: _pageSize,
          isDense: true,
          underline: Container(height: 1, color: Colors.grey.shade300),
          items: widget.pageSizeOptions.map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setPageSize(value);
            }
          },
        ),
      ],
    );
  }

  void _goToFirstPage() {
    goToPage(1);
  }

  void _goToPreviousPage() {
    goToPage(_currentPage - 1);
  }

  void _goToNextPage() {
    goToPage(_currentPage + 1);
  }

  void _goToLastPage(int totalPages) {
    goToPage(totalPages);
  }

  void _showCreateForm() {
    // Reset form data for creating a new record
    _createFormData = {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenSize.height * 0.8,
              maxWidth: min(screenSize.width * 0.8, 600),
            ),
            child: IntrinsicHeight(
              child: IntrinsicWidth(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.createFormTitle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: SingleChildScrollView(
                          child: DynamicForm(
                            tableDefinition: widget.tableDefinition,
                            hiddenFields: widget.hiddenFormFields,
                            fieldOrder: widget.formFieldOrder,
                            readonlyFields: widget.readonlyFields,
                            allFieldsReadonly: widget.allFieldsReadonly,
                            editableFields: widget.editableFields,
                            columnNameMapper: widget.columnNameMapper,
                            helpTexts: widget.helpTexts,
                            hintTexts: widget.hintTexts,
                            customValidators: widget.customValidators,
                            formValidations: widget.formValidations,
                            fieldGroups: widget.fieldGroups,
                            ungroupedFieldsAtTop: widget.ungroupedFieldsAtTop,
                            dropdownOptionMappers: widget.dropdownOptionMappers,
                            allTextCapitalized: widget.allTextCapitalized,
                            showSubmitButton: true,
                            onSubmit: (formData) {
                              print('Form submitted with data: $formData');
                              _createFormData =
                                  Map<String, dynamic>.from(formData);
                              _handleCreateSubmitDirect(context);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Direct submission method that doesn't rely on form validation
  void _handleCreateSubmitDirect(BuildContext context) async {
    print('Direct create submission with data: $_createFormData');

    // Check if onCreate callback is provided
    if (widget.onCreate != null) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Dialog(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text("Creating record..."),
                  ],
                ),
              ),
            );
          },
        );

        // Call the onCreate callback with the form data
        final success = await widget.onCreate!(_createFormData);

        // Close the loading dialog
        if (mounted) Navigator.of(context).pop();

        if (success) {
          // If creation was successful, close the form dialog and refresh the data
          if (mounted) {
            Navigator.pop(context);
            _refreshData();

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Record created successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          // Handle unsuccessful creation
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to create record'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        // Close the loading dialog if it's open
        if (mounted) Navigator.of(context).pop();

        // Handle exceptions during creation
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating record: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // If no onCreate callback is provided, just close the dialog
      Navigator.pop(context);
    }
  }

  void _showUpdateForm(Map<String, dynamic> rowData) {
    // Initialize update form data with a copy of the row data
    _updateFormData = Map<String, dynamic>.from(rowData);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenSize.height * 0.8,
              maxWidth: min(screenSize.width * 0.8,
                  600), // Maximum width of 600 or 80% of screen width
            ),
            child: IntrinsicHeight(
              child: IntrinsicWidth(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.updateFormTitle,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: SingleChildScrollView(
                          child: DynamicForm(
                            tableDefinition: widget.tableDefinition,
                            initialData: _updateFormData,
                            hiddenFields: widget.hiddenFormFields,
                            fieldOrder: widget.formFieldOrder,
                            readonlyFields: widget.readonlyFields,
                            allFieldsReadonly: widget.allFieldsReadonly,
                            editableFields: widget.editableFields,
                            columnNameMapper: widget.columnNameMapper,
                            helpTexts: widget.helpTexts,
                            hintTexts: widget.hintTexts,
                            customValidators: widget.customValidators,
                            formValidations: widget.formValidations,
                            fieldGroups: widget.fieldGroups,
                            ungroupedFieldsAtTop: widget.ungroupedFieldsAtTop,
                            dropdownOptionMappers: widget.dropdownOptionMappers,
                            allTextCapitalized: widget.allTextCapitalized,
                            showSubmitButton: true,
                            onSubmit: (formData) {
                              print(
                                  'Update form submitted with data: $formData');
                              _updateFormData =
                                  Map<String, dynamic>.from(formData);
                              // Handle the submission
                              _handleUpdateSubmitDirect(context);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Direct submission method that doesn't rely on form validation
  void _handleUpdateSubmitDirect(BuildContext context) async {
    print('Direct update submission with data: $_updateFormData');

    // Check if onUpdate callback is provided
    if (widget.onUpdate != null) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Dialog(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text("Updating record..."),
                  ],
                ),
              ),
            );
          },
        );

        // Call the onUpdate callback with the form data
        final success = await widget.onUpdate!(_updateFormData);

        // Close the loading dialog
        if (mounted) Navigator.of(context).pop();

        if (success) {
          // If update was successful, close the form dialog and refresh the data
          if (mounted) {
            Navigator.pop(context);
            _refreshData();

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Record updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          // Handle unsuccessful update
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to update record'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        // Close the loading dialog if it's open
        if (mounted) Navigator.of(context).pop();

        // Handle exceptions during update
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating record: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // If no onUpdate callback is provided, just close the dialog
      Navigator.pop(context);
    }
  }

  Future<void> _confirmDelete(Map<String, dynamic> rowData) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.deleteButtonText),
          content: Text(widget.deleteConfirmationMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(widget.cancelButtonText),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(widget.confirmDeleteButtonText),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && widget.onDelete != null) {
      final success = await widget.onDelete!(rowData);
      if (success && mounted) {
        _refreshData();
      }
    }
  }

  @override
  void didUpdateWidget(CrudTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the widget is rebuilt with a different table definition or other key properties changed,
    // we may need to refresh the data, but we should preserve the search state
    bool shouldRefresh = false;

    if (oldWidget.tableDefinition != widget.tableDefinition ||
        oldWidget.initialPageSize != widget.initialPageSize) {
      shouldRefresh = true;
    }

    // If column search was enabled/disabled or searchable columns changed
    if (oldWidget.enableColumnSearch != widget.enableColumnSearch) {
      // If column search was disabled, reset the selected column
      if (!widget.enableColumnSearch) {
        _selectedSearchColumn = null;
        _selectedDropdownValue = null;
      }
      shouldRefresh = true;
    }

    // If dropdown mappings changed and we're using a dropdown search
    if (oldWidget.dropdownOptionMappers != widget.dropdownOptionMappers &&
        _selectedSearchColumn != null &&
        _isDropdownColumn(_selectedSearchColumn!)) {
      // Verify dropdown value is still valid in the new options
      final options =
          widget.dropdownOptionMappers[_selectedSearchColumn!] ?? {};
      if (_selectedDropdownValue != null &&
          !options.containsKey(_selectedDropdownValue)) {
        _selectedDropdownValue = null;
        _searchText = '';
        shouldRefresh = true;
      }
    }

    // Always preserve the search text state in the controller
    if (_searchController.text != _searchText) {
      _searchController.text = _searchText;
    }

    if (shouldRefresh) {
      _refreshData();
    }
  }

  // Build dropdown for column selection
  Widget _buildColumnSearchControls() {
    final searchableColumns = _getSearchableColumns();

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: widget.columnSearchHintText,
      ),
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, size: 20),
      value: _selectedSearchColumn,
      items: [
        // Add a "Search All" option
        DropdownMenuItem<String>(
          value: null,
          child: Text(
            widget.searchAllText,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        // Add all searchable columns
        ...searchableColumns.map((column) {
          return DropdownMenuItem<String>(
            value: column,
            child: Text(
              _getColumnDisplayName(column),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          );
        }),
      ],
      onChanged: (String? newValue) {
        setState(() {
          // Reset search when changing column
          if (_selectedSearchColumn != newValue) {
            _searchController.clear();
            _searchText = '';
            _selectedDropdownValue = null;
          }

          _selectedSearchColumn = newValue;
          _refreshData();
        });
      },
    );
  }

  // Build text search field
  Widget _buildTextSearch() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: widget.searchHintText,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        isDense: true,
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  // Clear the controller text
                  _searchController.clear();

                  // Force immediate search with empty string on clear
                  // Don't wait for debounce here
                  setState(() {
                    _searchText = '';
                  });

                  // Cancel any pending debounce timer
                  if (_debounceTimer?.isActive ?? false) {
                    _debounceTimer!.cancel();
                  }

                  // Explicitly trigger search with empty string
                  _refreshData();
                },
              )
            : null,
      ),
    );
  }

  // Build dropdown search for enum columns
  Widget _buildDropdownSearch() {
    // Get the dropdown options for this column
    final columnName = _selectedSearchColumn!;
    final optionMapper = widget.dropdownOptionMappers[columnName] ?? {};

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: 'Select ${_getColumnDisplayName(columnName)}',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        isDense: true,
      ),
      value: _selectedDropdownValue,
      items: [
        // Add an empty option
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Any'),
        ),
        // Add all options from the mapper
        ...optionMapper.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          );
        }),
      ],
      onChanged: (String? newValue) {
        setState(() {
          _selectedDropdownValue = newValue;
          _searchText = newValue ?? '';
          _currentPage = 1; // Reset to first page when searching
          _refreshData();
        });
      },
    );
  }
}

// Helper function to check if an item matches the search text
bool _matchesSearch(Map<String, dynamic> item, String searchText) {
  final searchLower = searchText.toLowerCase();

  // Check if any field in the item contains the search text
  return item.values.any((value) {
    if (value == null) return false;
    return value.toString().toLowerCase().contains(searchLower);
  });
}
