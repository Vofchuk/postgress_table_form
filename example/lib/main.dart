import 'package:flutter/material.dart';
import 'package:postgress_table_form/src/models/table_definition_model/table_definiton_model.dart';
import 'package:postgress_table_form/src/widgets/dynamic_table_view.dart';

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
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Create a sample table definition

    // Create sample data
  }

  @override
  Widget build(BuildContext context) {
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
              child: DynamicTableView(
                tableDefinition:
                    TableDefinitionModel.fromJsonList("Incidents", tableDef),
                data: tableData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
