import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager.dart';

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
        String? value = storageManager.getDataOnPosition(cellPosition);
        rowValues.add(value ?? '');
      }
      lines.add(rowValues);
    }
    return CsvGenerator(
      lines: lines,
    );
  }

  String generateString({String seperator = ','}) {
    List<String> parsedLines = List<String>.empty(growable: true);
    for( List<String> line in lines ) {
      List<String> parsedLine = List<String>.empty(growable: true);
      for( String text in line ) {
        text = text.replaceAll('"', '""');
        bool hasSpecialCharacters = text.contains('\t') || text.contains('\n') || text.contains('.') || text.contains(',') || text.contains(';');
        if( hasSpecialCharacters ) {
          text = '"$text"';
        }
        parsedLine.add(text);
      }
      parsedLines.add(parsedLine.join(seperator));
    }
    return parsedLines.join('\n');
  }
}
