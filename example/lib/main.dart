import 'package:flutter/material.dart';
import 'package:postgress_table_form/postgress_table_form.dart';

import 'data/tableDef.dart';
import 'data/table_data.dart';

void main() {
  runApp(const MyApp());
}

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? _selectedRecord;
  final int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Create a sample table definition

    // Create sample data
  }

  void _handleRecordSelection(Map<String, dynamic> record) {
    setState(() {
      _selectedRecord = record;
    });
    _showFormDialog(record);
  }

  void _showFormDialog(Map<String, dynamic> record) {
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
                Expanded(
                  child: DynamicForm(
                    tableDefinition: tableDefinition,
                    initialData: record,
                    onSubmit: (formData) {
                      _handleFormSubmit(formData);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFormSubmit(Map<String, dynamic> formData) {
    // Handle the updated data
    print('Updated data: $formData');
    // In a real app, you would update the database or perform other actions
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              '${tableData.length} records found',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // This is needed to ensure the table scrolls properly
                  return false;
                },
                child: Stack(
                  children: [
                    DynamicTableView(
                      tableDefinition: tableDefinition,
                      data: tableData,
                      enableRowSelection: true,
                      showActionsColumn: true,
                      columnNameMapper: (columnName) {
                        return columnName.replaceAll('_', ' ');
                      },
                      // onRowSelected: _handleRecordSelection,
                      actionBuilder: (record) {
                        return IconButton(
                          onPressed: () => _handleRecordSelection(record),
                          icon: const Icon(Icons.edit),
                        );
                      },
                    ),
                    // Overlay a transparent ListView to handle taps
                    // ListView.builder(
                    //   itemCount: tableData.length,
                    //   itemBuilder: (context, index) {
                    //     return GestureDetector(
                    //       onTap: () {
                    //         setState(() {
                    //           _selectedIndex = index;
                    //           _selectedRecord = tableData[index];
                    //         });
                    //         _handleRecordSelection(tableData[index]);
                    //       },
                    //       child: Container(
                    //         height: 52, // Approximate height of a table row
                    //         color: Colors.transparent,
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedRecord = null; // Clear selected record for new entry
          });
          _showFormDialog({});
        },
        tooltip: 'New Record',
        child: const Icon(Icons.add),
      ),
    );
  }
}
