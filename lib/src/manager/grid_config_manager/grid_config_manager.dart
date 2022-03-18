import 'package:excel_grid/src/models/dto/grid_position.dart';
import 'package:excel_grid/src/shared/cell_title_generator/cell_title_generator.dart';
import 'package:flutter/cupertino.dart';

class GridConfigManager extends ChangeNotifier {
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

  GridPosition generateCellVertical(int index) {
    return GridPosition(
      key: verticalCellTitleGenerator.getTitle(index),
      index: index,
    );
  }

  GridPosition generateCellHorizontal(int index) {
    return GridPosition(
      key: horizontalCellTitleGenerator.getTitle(index),
      index: index,
    );
  }
}