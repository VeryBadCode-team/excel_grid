import 'package:excel_grid/src/models/dto/cell_position.dart';

abstract class SelectionData {
  List<List<CellPosition>> get byRows;

  List<List<CellPosition>> get byColumns;

  List<CellPosition> get merged;
}