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
  /// This function should return a Future that resolves to a list of records (maps).
  /// Each record is a map where keys are column names and values are the data.
  ///
  /// The function receives the current page and page size as parameters to support pagination.
  /// It should return data for the requested page.
  ///
  /// The component will handle pagination internally based on the total count of records.
  final Future<List<Map<String, dynamic>>> Function(int page, int pageSize)
      getData;

  /// Function that returns the total count of records
  ///
  /// This function is used for pagination to calculate the total number of pages.
  /// If not provided, the component will use the length of the data returned by [getData].
  ///
  /// Example:
  /// ```dart
  /// getTotalCount: () async {
  ///   final result = await database.query('SELECT COUNT(*) FROM users');
  ///   return result[0]['count'];
  /// }
  /// ```
  final Future<int> Function()? getTotalCount;

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
  final bool showHorizontalScrollbar;

  /// Whether to show a vertical scrollbar for the table
  final bool showVerticalScrollbar;

  /// Custom cell builders for specific columns in the table
  final Map<String, Widget Function(dynamic value)>? customCellBuilders;

  /// Enhanced custom cell builders for specific columns in the table
  final Map<String, CustomCellBuilder>? advancedCustomCellBuilders;

  /// Custom tooltip mapper for the table
  final TooltipMapper? tooltipMapper;

  /// Custom styling for the table
  final DataTableThemeData? tableTheme;

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

  /// Constructs a CRUD table with the specified parameters
  const CrudTable({
    super.key,
    this.tableKey,
    required this.tableDefinition,
    required this.getData,
    this.getTotalCount,
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
    this.showHorizontalScrollbar = true,
    this.showVerticalScrollbar = true,
    this.customCellBuilders,
    this.advancedCustomCellBuilders,
    this.tooltipMapper,
    this.tableTheme,
    this.pageSizeOptions = const [5, 10, 25, 50, 100],
    this.initialPageSize = 10,
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
  ///   getData: (page, pageSize) => fetchData(page, pageSize),
  ///   // ... other parameters
  /// )
  /// ```
  static Widget fromFuture({
    Key? key,
    required Future<TableDefinitionModel> tableDefinitionFuture,
    required Future<List<Map<String, dynamic>>> Function(int page, int pageSize)
        getData,
    Future<int> Function()? getTotalCount,
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
    List<int> pageSizeOptions = const [5, 10, 25, 50, 100],
    int initialPageSize = 10,
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
          getTotalCount: getTotalCount,
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
          showHorizontalScrollbar: showHorizontalScrollbar,
          showVerticalScrollbar: showVerticalScrollbar,
          customCellBuilders: customCellBuilders,
          advancedCustomCellBuilders: advancedCustomCellBuilders,
          tooltipMapper: tooltipMapper,
          tableTheme: tableTheme,
          pageSizeOptions: pageSizeOptions,
          initialPageSize: initialPageSize,
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
    List<int> pageSizeOptions = const [5, 10, 25, 50, 100],
    int initialPageSize = 10,
  }) {
    return CrudTable(
      key: key,
      tableKey: tableKey,
      tableDefinition: tableDefinition,
      getData: (page, pageSize) async {
        // Calculate pagination for the in-memory list
        final int startIndex = (page - 1) * pageSize;
        final int endIndex = startIndex + pageSize > data.length
            ? data.length
            : startIndex + pageSize;

        // Return a subset of the data based on the requested page
        final List<Map<String, dynamic>> pagedData =
            startIndex < data.length ? data.sublist(startIndex, endIndex) : [];

        return pagedData;
      },
      getTotalCount: () async {
        return data.length;
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
      showHorizontalScrollbar: showHorizontalScrollbar,
      showVerticalScrollbar: showVerticalScrollbar,
      customCellBuilders: customCellBuilders,
      advancedCustomCellBuilders: advancedCustomCellBuilders,
      tooltipMapper: tooltipMapper,
      tableTheme: tableTheme,
      pageSizeOptions: pageSizeOptions,
      initialPageSize: initialPageSize,
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

  @override
  void initState() {
    super.initState();
    _currentPage = 1;
    _pageSize = widget.initialPageSize;
    _refreshData();
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
      // First, get the data for the current page
      final dataFuture = widget.getData(_currentPage, _pageSize);

      // If getTotalCount is provided, use it to get the total count
      final totalCountFuture = widget.getTotalCount != null
          ? widget.getTotalCount!()
          : dataFuture.then((result) => result.length);

      // Combine the futures
      _dataFuture = Future.wait([dataFuture, totalCountFuture]).then((results) {
        final data = results[0] as List<Map<String, dynamic>>;
        final totalCount = results[1] as int;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.allowedOperations.contains(CrudOperations.create))
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildCreateButton(),
          ),
        Expanded(
          child: FutureBuilder<DynamicTableData>(
            future: _dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading data: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                return const Center(
                  child: Text('No data available'),
                );
              }

              return Column(
                children: [
                  Expanded(child: _buildTable(snapshot.data!)),
                  if (snapshot.data!.totalPages > 1)
                    _buildPagination(snapshot.data!),
                ],
              );
            },
          ),
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

  Widget _buildTable(DynamicTableData data) {
    return DynamicTableView(
      tableDefinition: widget.tableDefinition,
      data: data.data,
      showActionsColumn:
          widget.allowedOperations.contains(CrudOperations.update) ||
              widget.allowedOperations.contains(CrudOperations.delete),
      actionBuilder: (rowData) => _buildActionButtons(rowData),
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
      showHorizontalScrollbar: widget.showHorizontalScrollbar,
      showVerticalScrollbar: widget.showVerticalScrollbar,
      tableTheme: widget.tableTheme,
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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.createFormTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: DynamicForm(
                      key: _createFormKey,
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
                      showSubmitButton: false,
                      onSubmit: (formData) {
                        _createFormData = formData;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(widget.cancelButtonText),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _handleCreateSubmit(context),
                      child: Text(widget.createSubmitButtonText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Form key and data for the create form
  final GlobalKey<FormState> _createFormKey = GlobalKey<FormState>();
  Map<String, dynamic> _createFormData = {};

  // Form key and data for the update form
  final GlobalKey<FormState> _updateFormKey = GlobalKey<FormState>();
  Map<String, dynamic> _updateFormData = {};

  void _handleCreateSubmit(BuildContext context) async {
    if (_createFormKey.currentState?.validate() ?? false) {
      _createFormKey.currentState?.save();

      if (widget.onCreate != null) {
        final success = await widget.onCreate!(_createFormData);
        if (success) {
          if (mounted) {
            Navigator.pop(context);
            _refreshData();
          }
        }
      }
    }
  }

  void _showUpdateForm(Map<String, dynamic> rowData) {
    _updateFormData = Map<String, dynamic>.from(rowData);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.updateFormTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: DynamicForm(
                      key: _updateFormKey,
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
                      showSubmitButton: false,
                      onSubmit: (formData) {
                        _updateFormData = formData;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(widget.cancelButtonText),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _handleUpdateSubmit(context),
                      child: Text(widget.updateSubmitButtonText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleUpdateSubmit(BuildContext context) async {
    if (_updateFormKey.currentState?.validate() ?? false) {
      _updateFormKey.currentState?.save();

      if (widget.onUpdate != null) {
        final success = await widget.onUpdate!(_updateFormData);
        if (success) {
          if (mounted) {
            Navigator.pop(context);
            _refreshData();
          }
        }
      }
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
}
