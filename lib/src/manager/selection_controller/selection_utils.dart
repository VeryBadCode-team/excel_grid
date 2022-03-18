import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/models/dto/grid_position.dart';

class SelectionUtils {
  static bool compareCellsVerticalPosition(CellPosition a, CellPosition b) {
    return a.columnPosition.index == b.columnPosition.index;
  }

  static bool compareCellsHorizontalPosition(CellPosition a, CellPosition b) {
    return a.rowPosition.index == b.rowPosition.index;
  }

  static bool compareCellBetweenPoints({
    required CellPosition cell,
    required CellPosition a,
    required CellPosition b,
  }) {
    bool sameVertical = compareCellBetweenPointsVertical(
      position: cell.columnPosition,
      a: a,
      b: b,
    );
    bool sameHorizontal = compareCellBetweenPointsHorizontal(
      position: cell.rowPosition,
      a: a,
      b: b,
    );
    return sameVertical && sameHorizontal;
  }

  static bool compareCellBetweenPointsVertical({
    required GridPosition position,
    required CellPosition a,
    required CellPosition b,
  }) {
    bool sameVertical = (position.index <= a.columnPosition.index && position.index >= b.columnPosition.index) ||
        (position.index >= a.columnPosition.index && position.index <= b.columnPosition.index);
    return sameVertical;
  }

  static bool compareCellBetweenPointsHorizontal({
    required GridPosition position,
    required CellPosition a,
    required CellPosition b,
  }) {
    bool sameHorizontal =
        (position.index <= a.rowPosition.index && position.index >= b.rowPosition.index) ||
            (position.index >= a.rowPosition.index && position.index <= b.rowPosition.index);
    return sameHorizontal;
  }
}
