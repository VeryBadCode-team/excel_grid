import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/shared/generators/csv_parser.dart';

class CsvGenerator {
  final List<List<String>> lines;

  const CsvGenerator({
    required this.lines,
  });

  factory CsvGenerator.fromCells({
    required List<List<CellPosition>> selectedCells,
    required StorageManager storageManager,
  }) {
    List<List<String>> lines = List<List<String>>.empty(growable: true);
    for (List<CellPosition> row in selectedCells) {
      List<String> rowValues = List<String>.empty(growable: true);
      for (CellPosition cellPosition in row) {
        String? value = storageManager.getCellData(cellPosition)?.asString;
        rowValues.add(value ?? '');
      }
      lines.add(rowValues);
    }
    return CsvGenerator(
      lines: lines,
    );
  }

  String generateString({String seperator = ','}) {
    return CsvParser.toCsv(lines, seperator: seperator);
  }
}
