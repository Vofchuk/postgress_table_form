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

A Flutter package that automatically generates form widgets based on PostgreSQL table definitions. This package simplifies the process of creating CRUD interfaces for your PostgreSQL database tables.

## Table of Contents
- [Features](#features)
- [Getting Started](#getting-started)
- [Usage](#usage)
  - [Creating a Reusable PostgreSQL Function](#creating-a-reusable-postgresql-function)
- [Complete Example: Building a CRUD Interface](#complete-example-building-a-crud-interface)
  - [Project Structure](#project-structure)
  - [Application Setup](#step-1-application-setup)
  - [Main Page Setup](#step-2-main-page-setup)
  - [Record Selection and Form Dialog](#step-3-record-selection-and-form-dialog)
  - [Building the UI with Table View](#step-4-building-the-ui-with-table-view)
  - [Key Components Explained](#key-components-explained)
  - [Data Files](#data-files)
- [How It Works](#how-it-works)
- [Customization](#customization)
- [Additional Information](#additional-information)

## Overview

PostgreSQL Table Form is designed to dramatically reduce development time for admin panels and data management applications. By automatically generating both form interfaces and table views directly from your PostgreSQL database schema, this package eliminates the need to manually create and maintain CRUD operations for each database table.

### Perfect for Admin Panels

This package is particularly valuable for:
- **Admin dashboards** that need to manage multiple database tables
- **Back-office applications** requiring data entry and management interfaces
- **Content management systems** where editors need to update database records
- **Internal tools** for data manipulation and reporting

### Comprehensive CRUD Solution

The package provides two main components:

1. **DynamicForm**: Automatically generates form fields based on your PostgreSQL table structure, handling:
   - Field types appropriate for each database column type
   - Validation based on database constraints
   - Default values and nullable fields

2. **DynamicTableView**: Displays your data in a customizable table format with:
   - Sortable columns
   - Pagination
   - Row selection
   - Action buttons for edit/delete operations
   - Customizable column rendering

By combining these components, you can create a complete CRUD interface with minimal code, saving days or even weeks of development time.

## Features

- Automatically generates form fields based on PostgreSQL column types
- Supports various PostgreSQL data types including text, numeric, boolean, date/time, and **enums**
- Handles nullable fields and default values
- Provides validation based on database constraints
- Customizable form appearance and behavior
- Easy integration with Flutter applications

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  postgress_table_form: <latest version>
```

Then run:

```bash
flutter pub get
```

## Usage

1. First, extract your PostgreSQL table definition by running the following SQL query:

```sql
SELECT json_agg(
    json_build_object(
        'column_name', column_name,
        'data_type', data_type,
        'is_nullable', is_nullable,
        'column_default', column_default,
        'enum_options', 
        CASE 
            WHEN data_type = 'USER-DEFINED' THEN (
                SELECT json_agg(enumlabel) 
                FROM pg_enum 
                JOIN pg_type ON pg_enum.enumtypid = pg_type.oid 
                WHERE pg_type.typname = udt_name
            ) 
            ELSE NULL 
        END
    )
)
FROM information_schema.columns
WHERE table_name = '<table name>' AND table_schema = 'public';
```

Replace `<table name>` with your actual table name.

### Creating a Reusable PostgreSQL Function

For convenience, you can create a reusable PostgreSQL function that extracts table schemas:

```sql
CREATE OR REPLACE FUNCTION get_table_schema_json(
    p_table_name TEXT,
    p_schema_name TEXT DEFAULT 'public'
) RETURNS JSON AS $$
DECLARE
    schema_json JSON;
BEGIN
    SELECT json_agg(
        json_build_object(
            'table_name', table_name,
            'column_name', column_name,
            'data_type', data_type,
            'is_nullable', is_nullable,
            'column_default', column_default,
            'enum_options', 
            CASE 
                WHEN data_type = 'USER-DEFINED' THEN (
                    SELECT json_agg(enumlabel) 
                    FROM pg_enum 
                    JOIN pg_type ON pg_enum.enumtypid = pg_type.oid 
                    WHERE pg_type.typname = udt_name
                ) 
                ELSE NULL 
            END
        )
    )
    INTO schema_json
    FROM information_schema.columns
    WHERE table_name = p_table_name AND table_schema = p_schema_name;

    RETURN schema_json;
END;
$$ LANGUAGE plpgsql;
```

Then you can easily get the schema for any table:

```sql
-- Get schema for a table in the public schema
SELECT get_table_schema_json('users');

-- Get schema for a table in a different schema
SELECT get_table_schema_json('users', 'auth');
```

2. Use the resulting JSON to create your form:

```dart
import 'package:flutter/material.dart';
import 'package:postgress_table_form/postgress_table_form.dart';

class MyFormPage extends StatelessWidget {
  final String tableDefinition; // JSON string from the SQL query

  const MyFormPage({Key? key, required this.tableDefinition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PostgreSQL Form')),
      body: PostgresTableForm(
        tableDefinition: tableDefinition,
        onSubmit: (formData) {
          // Handle the submitted form data
          print(formData);
        },
      ),
    );
  }
}
```

## Complete Example: Building a CRUD Interface

Below is a comprehensive example showing how to build a complete CRUD (Create, Read, Update, Delete) interface using the PostgreSQL Table Form package. The example demonstrates:

1. Setting up the application
2. Displaying table data in a dynamic table view
3. Creating and editing records with forms
4. Handling form submissions

### Project Structure

First, organize your project with these files:
- `main.dart` - Main application entry point
- `data/tableDef.dart` - Contains your table definition from PostgreSQL (in a real app, this would come from your database, dinamicaly)
- `data/table_data.dart` - Contains your table data (in a real app, this would come from your database)

### Step 1: Application Setup

```dart
// Import necessary packages
import 'package:flutter/material.dart';
import 'package:postgress_table_form/postgress_table_form.dart';

import 'data/tableDef.dart';  // Your table definition
import 'data/table_data.dart'; // Your table data

void main() {
  runApp(const MyApp());
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PostgreSQL Table Form Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PostgreSQL Table Form Example'),
    );
  }
}
```

### Step 2: Main Page Setup

```dart
// Main page widget with state management
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // State variables to track selected records
  Map<String, dynamic>? _selectedRecord;
  final int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // In a real app, you would fetch data from your database here
    // For this example, we're using static data from table_data.dart
  }
}
```

### Step 3: Record Selection and Form Dialog

```dart
  // Handle when a user selects a record from the table
  void _handleRecordSelection(Map<String, dynamic> record) {
    setState(() {
      _selectedRecord = record;
    });
    _showFormDialog(record);
  }

  // Show a dialog with a form for editing the selected record
  void _showFormDialog(Map<String, dynamic> record) {
    // Convert the table definition from JSON to a model
    final tableDefinition = TableDefinitionModel.fromList(tableDef);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog header with title and close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Record',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Dynamic form generated from table definition
                Expanded(
                  child: SingleChildScrollView(
                    child: DynamicForm(
                      tableDefinition: tableDefinition,
                      initialData: record,  // Pre-fill form with selected record data
                      onSubmit: (formData) {
                        _handleFormSubmit(formData);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Handle form submission
  void _handleFormSubmit(Map<String, dynamic> formData) {
    // Handle the updated data
    print('Updated data: $formData');
    // In a real app, you would update the database or perform other actions
  }
}
```

### Step 4: Building the UI with Table View

```dart
  @override
  Widget build(BuildContext context) {
    // Convert the table definition from JSON to a model
    final tableDefinition = TableDefinitionModel.fromList(tableDef);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Display record count
            Text(
              '${tableData.length} records found',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            // Dynamic table view to display data
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // This is needed to ensure the table scrolls properly
                  return false;
                },
                child: Stack(
                  children: [
                    // DynamicTableView automatically generates a table from your data
                    DynamicTableView(
                      tableDefinition: tableDefinition,
                      data: tableData,
                      enableRowSelection: true,
                      showActionsColumn: true,
                      // Format column headers by replacing underscores with spaces
                      columnNameMapper: (columnName) {
                        return columnName.replaceAll('_', ' ');
                      },
                      // Add an edit button for each row
                      actionBuilder: (record) {
                        return IconButton(
                          onPressed: () => _handleRecordSelection(record),
                          icon: const Icon(Icons.edit),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating action button to add new records
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedRecord = null; // Clear selected record for new entry
          });
          _showFormDialog({}); // Show empty form for new record
        },
        tooltip: 'New Record',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### Key Components Explained

1. **TableDefinitionModel**: Converts your PostgreSQL table definition JSON into a model that the package can use to generate forms and tables.

2. **DynamicTableView**: A widget that displays your data in a table format with the following features:
   - Automatically generates columns based on your table definition
   - Supports row selection
   - Customizable column headers with `columnNameMapper`
   - Action buttons for each row with `actionBuilder`

3. **DynamicForm**: A widget that generates a form based on your table definition with the following features:
   - Creates appropriate form fields for each column type
   - Pre-fills form with existing data when editing
   - Handles form submission with validation

4. **Data Flow**:
   - Table data is displayed in the `DynamicTableView`
   - When a user clicks the edit button, the record is passed to `_handleRecordSelection`
   - A dialog opens with a `DynamicForm` pre-filled with the record data
   - When the form is submitted, the updated data is passed to `_handleFormSubmit`
   - In a real application, you would update your database with the new data

### Data Files

For this example to work, you need to create:

1. `data/tableDef.dart` - Contains your table definition from PostgreSQL:
```dart
final tableDef = [
  // Your table definition JSON from PostgreSQL
  // This would be the result of the SQL query or function shown earlier
];
```

2. `data/table_data.dart` - Contains your sample data:
```dart
final tableData = [
  // Sample records matching your table structure
  {'id': 1, 'name': 'Example 1', ...},
  {'id': 2, 'name': 'Example 2', ...},
  // ...
];
```

## How It Works

1. **Table Definition Parsing**: The package parses the JSON table definition to understand the structure of your PostgreSQL table.

2. **Form Generation**: Based on the table definition, appropriate form fields are generated:
   - Text fields for character types (char, varchar, text)
   - Number fields for numeric types (integer, decimal, etc.)
   - Toggle switches for boolean types
   - Date/time pickers for date and time types
   - Dropdown selectors for enum types

3. **Validation**: Form validation is automatically applied based on:
   - Nullability constraints (is_nullable)
   - Data type constraints
   - Any custom validation rules you provide

4. **Form Submission**: When the form is submitted, the data is validated and returned in a format ready to be used in SQL queries.

## Customization

The form appearance and behavior can be customized:

```dart
PostgresTableForm(
  tableDefinition: tableDefinition,
  theme: PostgresFormTheme(
    // Custom theme options
  ),
  fieldBuilders: {
    // Custom field builders for specific column types
  },
  onSubmit: (formData) {
    // Handle form submission
  },
)
```

## Additional information

For more detailed examples, check the `/example` folder in the package repository.

For issues, feature requests, or contributions, please visit the [GitHub repository](https://github.com/yourusername/postgress_table_form).
