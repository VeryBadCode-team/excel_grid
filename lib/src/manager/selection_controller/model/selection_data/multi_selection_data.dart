import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_corners/selection_corners.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_data/selection_data.dart';

class MultiSelectionData extends SelectionData {
  final SelectionCorners corners;

  MultiSelectionData(this.corners);

  @override
  List<List<CellPosition>> get byRows {
    GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
    List<List<CellPosition>> selected = List<List<CellPosition>>.empty(growable: true);
    CellPosition selectionFrom = corners.leftTop;
    CellPosition selectionTo = corners.rightBottom;
    for (int y = selectionFrom.columnPosition.index; y <= selectionTo.columnPosition.index; y++) {
      List<CellPosition> rowCells = List<CellPosition>.empty(growable: true);
      for (int x = selectionFrom.rowPosition.index; x <= selectionTo.rowPosition.index; x++) {
        rowCells.add(CellPosition(
          columnPosition: gridConfigManager.generateCellVertical(y),
          rowPosition: gridConfigManager.generateCellHorizontal(x),
        ));
      }
      selected.add(rowCells);
    }
    return selected;
  }

  @override
  List<List<CellPosition>> get byColumns {
    GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
    List<List<CellPosition>> selected = List<List<CellPosition>>.empty(growable: true);
    CellPosition selectionFrom = corners.leftTop;
    CellPosition selectionTo = corners.rightBottom;
    for (int x = selectionFrom.rowPosition.index; x <= selectionTo.rowPosition.index; x++) {
      List<CellPosition> columnCells = List<CellPosition>.empty(growable: true);
      for (int y = selectionFrom.columnPosition.index; y <= selectionTo.columnPosition.index; y++) {
        columnCells.add(CellPosition(
          columnPosition: gridConfigManager.generateCellVertical(y),
          rowPosition: gridConfigManager.generateCellHorizontal(x),
        ));
      }
      selected.add(columnCells);
    }
    return selected;
  }

  @override
  List<CellPosition> get merged {
    List<List<CellPosition>> allCells = byRows;
    List<CellPosition> mergedCells = List<CellPosition>.empty(growable: true);
    for (List<CellPosition> row in allCells) {
      mergedCells.addAll(row);
    }
    return mergedCells;
  }
}
