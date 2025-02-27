# DynamicForm Widget Documentation

The `DynamicForm` widget is a powerful and flexible form builder for Flutter applications that automatically generates forms based on PostgreSQL table definitions. It supports a wide range of PostgreSQL data types and provides numerous customization options.

## Basic Usage

```dart
import 'package:postgress_table_form/postgress_table_form.dart';

// Create a form from a table definition
DynamicForm(
  tableDefinition: tableDefinition,
  initialData: initialData, // Optional
  onSubmit: (formData) {
    // Handle form submission
    print(formData);
  },
)
```

## Features

- **Automatic Form Generation**: Automatically creates form fields based on PostgreSQL table definitions
- **Data Type Support**: Supports a wide range of PostgreSQL data types including text, numbers, dates, booleans, JSON, arrays, and user-defined types
- **Field Customization**: Customize field appearance, behavior, and validation
- **Field Grouping**: Organize fields into collapsible sections
- **Field Ordering**: Control the order of fields in the form
- **Field Visibility**: Hide specific fields from the form
- **Read-only Fields**: Make specific fields read-only
- **Custom Validation**: Add custom validation rules for individual fields and form-level validation
- **Help Text and Hints**: Add help text and hints to fields
- **Form Submission**: Handle form submission with validated data

## Constructor Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `tableDefinition` | `TableDefinitionModel` | **Required**. The PostgreSQL table definition model. |
| `initialData` | `Map<String, dynamic>?` | Initial values for the form fields. |
| `onSubmit` | `Function(Map<String, dynamic>)` | **Required**. Callback function called when the form is submitted with valid data. |
| `showSubmitButton` | `bool` | Whether to show the submit button. Default is `true`. |
| `submitButtonText` | `String` | Text to display on the submit button. Default is `'Submit'`. |
| `readonlyFields` | `List<String>` | List of column names that should be read-only. |
| `allFieldsReadonly` | `bool` | If `true`, all fields will be read-only unless specified in `editableFields`. Default is `false`. |
| `editableFields` | `List<String>` | List of column names that should be editable (used when `allFieldsReadonly` is `true`). |
| `hiddenFields` | `List<String>` | List of column names that should be hidden from the form. |
| `customValidators` | `Map<String, String? Function(dynamic)>` | Map of column names to custom validation functions. |
| `fieldGroups` | `List<FieldGroup>` | List of field groups to organize fields into sections. |
| `ungroupedFieldsAtTop` | `bool` | If `true`, fields not included in any group will be displayed at the top. Default is `false`. |
| `fieldOrder` | `List<String>` | Custom order for fields. |
| `helpTexts` | `Map<String, String>` | Map of column names to help text that will be displayed below the field. |
| `hintTexts` | `Map<String, String>` | Map of column names to hint text that will be displayed inside the field. |
| `formValidations` | `List<FormValidation>` | List of form-level validation functions. |

## Examples

### Basic Form

```dart
DynamicForm(
  tableDefinition: tableDefinition,
  onSubmit: (formData) {
    // Handle form submission
    print(formData);
  },
)
```

### Form with Initial Data

```dart
DynamicForm(
  tableDefinition: tableDefinition,
  initialData: {
    'id': 1,
    'name': 'John Doe',
    'email': 'john@example.com',
  },
  onSubmit: (formData) {
    // Handle form submission
    print(formData);
  },
)
```

### Form with Read-only Fields

```dart
DynamicForm(
  tableDefinition: tableDefinition,
  readonlyFields: ['id', 'created_at'],
  onSubmit: (formData) {
    // Handle form submission
    print(formData);
  },
)
```

### Form with Hidden Fields

```dart
DynamicForm(
  tableDefinition: tableDefinition,
  hiddenFields: ['id', 'created_at'],
  onSubmit: (formData) {
    // Handle form submission
    print(formData);
  },
)
```

### Form with Custom Validation

```dart
DynamicForm(
  tableDefinition: tableDefinition,
  customValidators: {
    'email': (value) {
      if (value != null && !value.toString().contains('@')) {
        return 'Please enter a valid email address';
      }
      return null;
    },
    'age': (value) {
      if (value != null && value < 18) {
        return 'Age must be at least 18';
      }
      return null;
    },
  },
  onSubmit: (formData) {
    // Handle form submission
    print(formData);
  },
)
```

### Form with Field Groups

```dart
DynamicForm(
  tableDefinition: tableDefinition,
  fieldGroups: [
    FieldGroup(
      title: 'Personal Information',
      columnNames: ['name', 'email', 'phone'],
      icon: Icons.person,
    ),
    FieldGroup(
      title: 'Address',
      columnNames: ['street', 'city', 'state', 'zip'],
      icon: Icons.home,
      initiallyExpanded: false,
    ),
  ],
  onSubmit: (formData) {
    // Handle form submission
    print(formData);
  },
)
```

### Form with Custom Field Order

```dart
DynamicForm(
  tableDefinition: tableDefinition,
  fieldOrder: ['name', 'email', 'phone', 'address'],
  onSubmit: (formData) {
    // Handle form submission
    print(formData);
  },
)
```

### Form with Help Text and Hints

```dart
DynamicForm(
  tableDefinition: tableDefinition,
  helpTexts: {
    'email': 'We will never share your email with anyone else.',
    'password': 'Password must be at least 8 characters long.',
  },
  hintTexts: {
    'email': 'Enter your email address',
    'password': 'Enter your password',
  },
  onSubmit: (formData) {
    // Handle form submission
    print(formData);
  },
)
```

### Form with Form-Level Validation

```dart
DynamicForm(
  tableDefinition: tableDefinition,
  formValidations: [
    FormValidation(
      validate: (formData) {
        final startDate = formData['start_date'] as DateTime?;
        final endDate = formData['end_date'] as DateTime?;
        
        if (startDate != null && endDate != null && startDate.isAfter(endDate)) {
          return 'Start date must be before end date';
        }
        return null;
      },
      errorMessage: 'Start date must be before end date',
      involvedFields: ['start_date', 'end_date'],
    ),
    FormValidation(
      validate: (formData) {
        final password = formData['password'] as String?;
        final confirmPassword = formData['confirm_password'] as String?;
        
        if (password != null && confirmPassword != null && password != confirmPassword) {
          return 'Passwords do not match';
        }
        return null;
      },
      errorMessage: 'Passwords do not match',
      involvedFields: ['password', 'confirm_password'],
    ),
  ],
  onSubmit: (formData) {
    // Handle form submission
    print(formData);
  },
)
```

## Field Group

The `FieldGroup` class is used to organize fields into collapsible sections.

### Constructor Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `title` | `String` | **Required**. The title of the group. |
| `columnNames` | `List<String>` | **Required**. The list of column names in this group. |
| `initiallyExpanded` | `bool` | Whether the group is initially expanded. Default is `true`. |
| `icon` | `IconData?` | Optional icon to display next to the group title. |

## Form Validation

The `FormValidation` class is used to define form-level validation rules.

### Constructor Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `validate` | `String? Function(Map<String, dynamic>)` | **Required**. The validation function that takes the entire form data and returns an error message if validation fails, or null if validation passes. |
| `errorMessage` | `String` | **Required**. The error message to display if validation fails. |
| `involvedFields` | `List<String>` | **Required**. The fields involved in this validation rule. |

## Supported PostgreSQL Data Types

The `DynamicForm` widget supports the following PostgreSQL data types:

- `text`, `varchar`, `char`: Text fields
- `integer`, `smallint`, `bigint`, `serial`, `bigserial`: Integer fields
- `decimal`, `numeric`, `real`, `double precision`: Decimal fields
- `boolean`: Boolean fields (checkboxes)
- `date`: Date fields with date picker
- `timestamp`, `timestamptz`: Date and time fields with date and time pickers
- `json`, `jsonb`: JSON fields with multi-line text input
- `integer[]`, `text[]`, `uuid[]`: Array fields with comma-separated values
- User-defined types with enum options: Dropdown fields

## Best Practices

1. **Field Grouping**: Use field groups to organize related fields together, especially for forms with many fields.
2. **Field Ordering**: Use field order to ensure a logical flow of information in the form.
3. **Help Text**: Provide help text for fields that might be confusing or require additional explanation.
4. **Validation**: Use custom validation to ensure data integrity and provide helpful error messages.
5. **Form-Level Validation**: Use form-level validation to validate relationships between fields.
6. **Read-only Fields**: Use read-only fields for information that should be displayed but not edited.
7. **Hidden Fields**: Use hidden fields for information that should be included in the form data but not displayed to the user.

## Troubleshooting

### Form Validation Errors

If you're experiencing issues with form validation:

1. Check that your custom validation functions return `null` for valid values and an error message string for invalid values.
2. Ensure that form-level validation functions correctly handle null values.
3. Verify that the field names in `involvedFields` match the column names in your table definition.

### Field Display Issues

If fields are not displaying correctly:

1. Check that the column names in your table definition match the field names in your form configuration.
2. Ensure that fields are not both hidden and required.
3. Verify that the data types in your table definition are supported by the `DynamicForm` widget.

## Contributing

Contributions to the `DynamicForm` widget are welcome! Please feel free to submit issues and pull requests on our GitHub repository. 