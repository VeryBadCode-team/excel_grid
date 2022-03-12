import 'package:excel_grid/src/utils/cell_title_generator/cell_title_generator.dart';
import 'package:flutter/cupertino.dart';

class GridConfig extends ChangeNotifier {
  late CellTitleGenerator horizontalCellTitleGenerator;
  late CellTitleGenerator verticalCellTitleGenerator;
  late int rowsCount;
  late int columnsCount;


  void init({
    required CellTitleGenerator horizontalCellTitleGenerator,
    required CellTitleGenerator verticalCellTitleGenerator,
    required int rowsCount,
    required int columnsCount,
  }) {
    this.rowsCount = rowsCount;
    this.columnsCount = columnsCount;
    this.horizontalCellTitleGenerator = horizontalCellTitleGenerator;
    this.verticalCellTitleGenerator = verticalCellTitleGenerator;
  }
}