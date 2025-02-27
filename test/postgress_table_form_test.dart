import 'package:flutter_test/flutter_test.dart';
import 'package:postgress_table_form/src/models/table_definition_model/table_definiton_model.dart';

import 'tableDef.dart';

void main() {
  final table = TableDefinitionModel.fromList(tableDef);
  test('test TableDefinitionModel serialization from JSON', () {
    // Create a TableDefinitionModel with the columns

    // Test that the model was created correctly
    expect(table.columns.length, 27);
  });
}
