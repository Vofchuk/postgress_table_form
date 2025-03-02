<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# PostgreSQL Table Form

A Flutter package for dynamically generating forms and tables based on PostgreSQL table definitions.

## Features

- Dynamic form generation based on PostgreSQL table definitions
- Dynamic table view generation based on PostgreSQL table definitions
- CRUD (Create, Read, Update, Delete) operations with a single component
- Support for various field types (text, boolean, date, datetime, integer, decimal, JSON, array, dropdown)
- Form validation
- Form grouping
- Custom field ordering
- Custom field labels
- Custom field help text
- Custom field hint text
- Custom field validation
- Form-level validation

## Installation

```yaml
dependencies:
  postgress_table_form: ^1.0.0
```

## Usage

### Basic Form

```dart
import 'package:flutter/material.dart';
import 'package:postgress_table_form/postgress_table_form.dart';

class MyForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define your table
    final tableDefinition = TableDefinitionModel(
      tableName: 'users',
      columns: [
        ColumnDefinitionModel(
          columnName: 'name',
          dataType: PostgresDataType.text,
          isNullable: false,
        ),
        ColumnDefinitionModel(
          columnName: 'email',
          dataType: PostgresDataType.text,
          isNullable: false,
        ),
        ColumnDefinitionModel(
          columnName: 'age',
          dataType: PostgresDataType.integer,
          isNullable: true,
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text('User Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DynamicForm(
          tableDefinition: tableDefinition,
          onSubmit: (formData) {
            print('Form submitted: $formData');
          },
        ),
      ),
    );
  }
}
```

### Using Individual Form Widgets

You can also use the individual form widgets directly:

```dart
import 'package:flutter/material.dart';
import 'package:postgress_table_form/postgress_table_form.dart';

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormFieldWidget(
            column: ColumnDefinitionModel(
              columnName: 'name',
              dataType: PostgresDataType.text,
              isNullable: false,
            ),
            label: 'Name',
            isRequired: true,
            controller: _nameController,
            onChanged: (value) {
              // Handle value change
            },
          ),
          SizedBox(height: 16),
          IntegerFormFieldWidget(
            column: ColumnDefinitionModel(
              columnName: 'age',
              dataType: PostgresDataType.integer,
              isNullable: true,
            ),
            label: 'Age',
            controller: _ageController,
            onChanged: (value) {
              // Handle value change
            },
          ),
          SizedBox(height: 16),
          BooleanFormFieldWidget(
            column: ColumnDefinitionModel(
              columnName: 'is_active',
              dataType: PostgresDataType.boolean,
              isNullable: false,
            ),
            label: 'Active',
            isRequired: true,
            onChanged: (value) {
              setState(() {
                _isActive = value ?? false;
              });
            },
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Form is valid, submit
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

## Available Form Widgets

- `TextFormFieldWidget` - For text input
- `BooleanFormFieldWidget` - For boolean input (checkbox)
- `DateFormFieldWidget` - For date input
- `DateTimeFormFieldWidget` - For date and time input
- `IntegerFormFieldWidget` - For integer input
- `DecimalFormFieldWidget` - For decimal input
- `JsonFormFieldWidget` - For JSON input
- `ArrayFormFieldWidget` - For array input
- `DropdownFormFieldWidget` - For dropdown selection

## CRUD Table

The package also includes a `CrudTable` component that combines the `DynamicTableView` and `DynamicForm` widgets to provide a complete CRUD experience:

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:postgress_table_form/postgress_table_form.dart';

class MyCrudScreen extends StatefulWidget {
  @override
  _MyCrudScreenState createState() => _MyCrudScreenState();
}

class _MyCrudScreenState extends State<MyCrudScreen> {
  // Create a key to access the CrudTable state
  final crudTableKey = GlobalKey<CrudTableState>();
  
  // Define your table
  final tableDefinition = TableDefinitionModel(
    tableName: 'users',
    columns: [
      ColumnDefinitionModel(
        columnName: 'id',
        dataType: PostgresDataType.integer,
        isNullable: false,
      ),
      ColumnDefinitionModel(
        columnName: 'name',
        dataType: PostgresDataType.text,
        isNullable: false,
      ),
      ColumnDefinitionModel(
        columnName: 'email',
        dataType: PostgresDataType.text,
        isNullable: false,
      ),
      ColumnDefinitionModel(
        columnName: 'age',
        dataType: PostgresDataType.integer,
        isNullable: true,
      ),
      ColumnDefinitionModel(
        columnName: 'is_active',
        dataType: PostgresDataType.boolean,
        isNullable: false,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Page size selector
            Row(
              children: [
                Text('Page Size: '),
                DropdownButton<int>(
                  value: 10,
                  items: [10, 20, 50, 100].map((size) => 
                    DropdownMenuItem<int>(value: size, child: Text('$size'))
                  ).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      crudTableKey.currentState?.setPageSize(value);
                    }
                  },
                ),
                Spacer(),
                // Refresh button
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () => crudTableKey.currentState?.refreshData(),
                ),
              ],
            ),
            SizedBox(height: 16),
            // CrudTable with all CRUD operations
            Expanded(
              child: CrudTable(
                key: crudTableKey,
                tableDefinition: tableDefinition,
                getData: (page, pageSize) async {
                  // In a real app, you would fetch data from a database or API
                  // with the appropriate pagination parameters
                  await Future.delayed(Duration(seconds: 1)); // Simulate network delay
                  
                  // This is where you would use the page and pageSize parameters
                  // to fetch the appropriate subset of data
                  print('Fetching page $page with page size $pageSize');
                  
                  // Return only the records for the current page
                  return [
                    {'id': 1, 'name': 'John Doe', 'email': 'john@example.com', 'age': 30, 'is_active': true},
                    {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com', 'age': 25, 'is_active': true},
                    {'id': 3, 'name': 'Bob Johnson', 'email': 'bob@example.com', 'age': 45, 'is_active': false},
                  ];
                },
                getTotalCount: () async {
                  // In a real app, you would get the total count from a database or API
                  await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
                  
                  // Return the total number of records
                  return 100; // Example: 100 total records
                },
                onCreate: (formData) async {
                  // Create a new record
                  print('Creating: $formData');
                  // In a real app, you would send data to a database or API
                  return true; // Return success status
                },
                onUpdate: (formData) async {
                  // Update an existing record
                  print('Updating: $formData');
                  // In a real app, you would send data to a database or API
                  return true; // Return success status
                },
                onDelete: (rowData) async {
                  // Delete a record
                  print('Deleting: $rowData');
                  // In a real app, you would send delete request to a database or API
                  return true; // Return success status
                },
                allowedOperations: {
                  CrudOperations.create, 
                  CrudOperations.update, 
                  CrudOperations.delete
                },
                columnNameMapper: {
                  'id': 'ID',
                  'name': 'Full Name',
                  'email': 'Email Address',
                  'age': 'Age (Years)',
                  'is_active': 'Active Status'
                },
                hiddenTableColumns: ['id'], // Hide ID in the table
                hiddenFormFields: ['id'], // Hide ID in the form
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Using the Factory Constructors

The `CrudTable` provides convenient factory constructors for common use cases:

#### From a List of Data

If you already have all your data in memory, you can use the `fromList` constructor:

```dart
CrudTable.fromList(
  tableDefinition: tableDefinition,
  data: [
    {'id': 1, 'name': 'John Doe', 'email': 'john@example.com'},
    {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com'},
    {'id': 3, 'name': 'Bob Johnson', 'email': 'bob@example.com'},
  ],
  onCreate: (formData) async {
    // Handle create
    return true;
  },
  // ... other parameters
)
```

This constructor automatically handles pagination for you, slicing the data based on the current page and page size.

#### From a Future

If you need to load your table definition asynchronously, you can use the `fromFuture` constructor:

```dart
CrudTable.fromFuture(
  tableDefinitionFuture: fetchTableDefinition(), // Returns Future<TableDefinitionModel>
  getData: (page, pageSize) async {
    // Fetch data with pagination
    final result = await api.fetchUsers(page, pageSize);
    return result.items; // Return the list of records for the current page
  },
  getTotalCount: () async {
    // Get the total count of records
    final count = await api.getUsersCount();
    return count;
  },
  onCreate: (formData) async {
    // Handle create
    return true;
  },
  // ... other parameters
)
```

This constructor shows a loading indicator while the table definition is being loaded.

### Understanding Pagination

The `CrudTable` component handles pagination automatically. Here's how to implement it correctly:

1. **Page Numbers**: Pages are 1-indexed (the first page is page 1, not page 0)

2. **getData Function**: Your `getData` function receives two parameters:
   - `page`: The current page number (starting from 1)
   - `pageSize`: The number of records to display per page
   
   This function should return only the records for the requested page.

3. **getTotalCount Function**: For proper pagination with large datasets, provide a `getTotalCount` function:
   ```dart
   getTotalCount: () async {
     // Get the total count of records (e.g., from a database)
     final result = await database.query('SELECT COUNT(*) FROM users');
     return result[0]['count'];
   }
   ```
   This allows the component to calculate the correct number of pages without loading all data.

4. **Pagination Controls**: The component automatically displays pagination controls when there are multiple pages

5. **Programmatic Control**: You can control pagination programmatically using the `CrudTableState`:
   - `setPageSize(int)`: Change the number of records per page
   - `goToPage(int)`: Navigate to a specific page
   - `refreshData()`: Reload the current page
   - `currentPage`: Get the current page number
   - `pageSize`: Get the current page size

### Example with Real Pagination

Here's an example of implementing real pagination with a database:

```dart
CrudTable(
  key: crudTableKey,
  tableDefinition: tableDefinition,
  getData: (page, pageSize) async {
    // Calculate offset for SQL query
    final offset = (page - 1) * pageSize;
    
    // Execute SQL query with LIMIT and OFFSET
    final result = await database.query(
      'SELECT * FROM users LIMIT $pageSize OFFSET $offset'
    );
    
    // Return only the records for the current page
    return result;
  },
  getTotalCount: () async {
    // Execute a separate query to get the total count
    final countResult = await database.query('SELECT COUNT(*) FROM users');
    return countResult[0]['count'];
  },
  // ... other parameters
)
```

### Customizing the CrudTable

The `CrudTable` component offers extensive customization options, including:

- Control over which operations (Create, Update, Delete) are allowed
- Custom button text and dialog titles
- Separate field visibility for tables and forms
- Custom field ordering
- Form field grouping
- Custom validation
- Dropdown option mapping
- Custom cell rendering
- Custom styling for headers and cells
- Tooltips for column headers

## License

MIT
