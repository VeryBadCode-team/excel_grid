import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/dto/grid_position.dart';
import 'package:excel_grid/src/model/grid_config.dart';
import 'package:excel_grid/src/ui/cells/cell_title.dart';
import 'package:excel_grid/src/utils/enums/append_border.dart';

abstract class SelectionState {
  CellPosition get focusedCell;

  List<List<CellPosition>> get selectedCells;
  List<CellPosition> get selectedCellsMerged;
}

class SingleSelectedState extends SelectionState {
  final CellPosition cellPosition;

  SingleSelectedState(this.cellPosition);

  @override
  CellPosition get focusedCell => cellPosition;

  @override
  List<List<CellPosition>> get selectedCells => <List<CellPosition>>[
        <CellPosition>[cellPosition]
      ];

  @override
  List<CellPosition> get selectedCellsMerged => <CellPosition>[cellPosition];

  @override
  String toString() {
    return cellPosition.toString();
  }
}

class MultiSelectedState extends SelectionState {
  final CellPosition from;
  final CellPosition to;

  MultiSelectedState({
    required this.from,
    required this.to,
  });

  @override
  CellPosition get focusedCell => from;

  @override
  List<List<CellPosition>> get selectedCells {
    GridConfig gridConfig = globalLocator<GridConfig>();
    List<List<CellPosition>> selected = List<List<CellPosition>>.empty(growable: true);
    CellPosition selectionFrom = calcLeftTopNarrow();
    CellPosition selectionTo = calcRightBottomNarrow();
    for (int y = selectionFrom.verticalPosition.index; y <= selectionTo.verticalPosition.index; y++) {
      List<CellPosition> rowCells = List<CellPosition>.empty(growable: true);
      for (int x = selectionFrom.horizontalPosition.index; x <= selectionTo.horizontalPosition.index; x++) {
        rowCells.add(CellPosition(
          verticalPosition: gridConfig.generateCellVertical(y),
          horizontalPosition: gridConfig.generateCellHorizontal(x),
        ));
      }
      selected.add(rowCells);
    }
    return selected;
  }

  @override
  List<CellPosition> get selectedCellsMerged {
    List<List<CellPosition>> allCells = selectedCells;
    List<CellPosition> mergedCells = List<CellPosition>.empty(growable: true);
    for( List<CellPosition> row in allCells ) {
      mergedCells.addAll(row);
    }
    return mergedCells;
  }

  CellPosition calcLeftTopNarrow() {
    if (verticalSelectionReversed && horizontalSelectionReversed) {
      return from;
    }
    if (!verticalSelectionReversed && !horizontalSelectionReversed) {
      return to;
    }
    if( horizontalSelectionReversed ) {
      return CellPosition(verticalPosition: to.verticalPosition, horizontalPosition: from.horizontalPosition);
    }
    return CellPosition(verticalPosition: from.verticalPosition, horizontalPosition: to.horizontalPosition);
  }

  CellPosition calcRightBottomNarrow() {
    if (verticalSelectionReversed && horizontalSelectionReversed) {
      return to;
    }
    if (!verticalSelectionReversed && !horizontalSelectionReversed) {
      return from;
    }
    if( verticalSelectionReversed ) {
      return CellPosition(verticalPosition: to.verticalPosition, horizontalPosition: from.horizontalPosition);
    }
    return CellPosition(verticalPosition: from.verticalPosition, horizontalPosition: to.horizontalPosition);
  }

  bool isCellSelected(CellPosition cellPosition) {
    return compareCellBetweenPoints(
      cell: cellPosition,
      a: from,
      b: to,
    );
  }

  bool isTitleCellSelected(GridPosition gridPosition, GridDirection direction) {
    if (direction == GridDirection.vertical) {
      return compareCellBetweenPointsHorizontal(
        position: gridPosition,
        a: from,
        b: to,
      );
    }
    return compareCellBetweenPointsVertical(
      position: gridPosition,
      a: from,
      b: to,
    );
  }

  Set<AppendBorder> isVerticalSelectionExtreme(CellPosition cellPosition) {
    Set<AppendBorder> appendBorder = <AppendBorder>{};
    bool isFromExtreme = compareCellsVerticalPosition(cellPosition, from);
    bool isToExtreme = compareCellsVerticalPosition(cellPosition, to);

    if (isFromExtreme) {
      appendBorder.add(verticalSelectionReversed ? AppendBorder.top : AppendBorder.bottom);
    }
    if (isToExtreme) {
      appendBorder.add(verticalSelectionReversed ? AppendBorder.bottom : AppendBorder.top);
    }
    return appendBorder;
  }

  Set<AppendBorder> isHorizontalSelectionExtreme(CellPosition cellPosition) {
    Set<AppendBorder> appendBorder = <AppendBorder>{};
    bool isFromExtreme = compareCellsHorizontalPosition(cellPosition, from);
    bool isToExtreme = compareCellsHorizontalPosition(cellPosition, to);

    if (isFromExtreme) {
      appendBorder.add(horizontalSelectionReversed ? AppendBorder.left : AppendBorder.right);
    }
    if (isToExtreme) {
      appendBorder.add(horizontalSelectionReversed ? AppendBorder.right : AppendBorder.left);
    }
    return appendBorder;
  }

  bool compareCellsVerticalPosition(CellPosition a, CellPosition b) {
    return a.verticalPosition.index == b.verticalPosition.index;
  }

  bool compareCellsHorizontalPosition(CellPosition a, CellPosition b) {
    return a.horizontalPosition.index == b.horizontalPosition.index;
  }

  bool get verticalSelectionReversed {
    return from.verticalPosition.index < to.verticalPosition.index;
  }

  bool get horizontalSelectionReversed {
    return from.horizontalPosition.index < to.horizontalPosition.index;
  }

  bool compareCellBetweenPoints({
    required CellPosition cell,
    required CellPosition a,
    required CellPosition b,
  }) {
    bool sameVertical = compareCellBetweenPointsVertical(
      position: cell.verticalPosition,
      a: a,
      b: b,
    );
    bool sameHorizontal = compareCellBetweenPointsHorizontal(
      position: cell.horizontalPosition,
      a: a,
      b: b,
    );
    return sameVertical && sameHorizontal;
  }

  bool compareCellBetweenPointsVertical({
    required GridPosition position,
    required CellPosition a,
    required CellPosition b,
  }) {
    bool sameVertical = (position.index <= a.verticalPosition.index && position.index >= b.verticalPosition.index) ||
        (position.index >= a.verticalPosition.index && position.index <= b.verticalPosition.index);
    return sameVertical;
  }

  bool compareCellBetweenPointsHorizontal({
    required GridPosition position,
    required CellPosition a,
    required CellPosition b,
  }) {
    bool sameHorizontal =
        (position.index <= a.horizontalPosition.index && position.index >= b.horizontalPosition.index) ||
            (position.index >= a.horizontalPosition.index && position.index <= b.horizontalPosition.index);
    return sameHorizontal;
  }

  @override
  String toString() {
    return '$from:$to';
  }
}

class MultiSelectedOngoingState extends MultiSelectedState {
  MultiSelectedOngoingState({
    required CellPosition from,
    required CellPosition to,
  }) : super(from: from, to: to);
}

class MultiSelectedEndState extends MultiSelectedState {
  MultiSelectedEndState({
    required CellPosition from,
    required CellPosition to,
  }) : super(from: from, to: to);
}

class RowSelectedState extends MultiSelectedEndState {
  RowSelectedState({
    required CellPosition from,
    required CellPosition to,
  }) : super(from: from, to: to);
}

class RowSelectOngoingState extends RowSelectedState {
  RowSelectOngoingState({
    required CellPosition from,
    required CellPosition to,
  }) : super(from: from, to: to);
}

class RowSelectEndState extends RowSelectedState {
  RowSelectEndState({
    required CellPosition from,
    required CellPosition to,
  }) : super(from: from, to: to);
}

class ColumnSelectedState extends MultiSelectedEndState {
  ColumnSelectedState({
    required CellPosition from,
    required CellPosition to,
  }) : super(from: from, to: to);
}

class ColumnSelectOngoingState extends ColumnSelectedState {
  ColumnSelectOngoingState({
    required CellPosition from,
    required CellPosition to,
  }) : super(from: from, to: to);
}

class ColumnSelectEndState extends ColumnSelectedState {
  ColumnSelectEndState({
    required CellPosition from,
    required CellPosition to,
  }) : super(from: from, to: to);
}

class SelectedAllState extends MultiSelectedEndState {
  SelectedAllState({
    required CellPosition from,
    required CellPosition to,
  }) : super(from: from, to: to);
}

class CellEditingState extends SingleSelectedState {
  CellEditingState(CellPosition cellPosition) : super(cellPosition);
}

class CellEditingKeyPressedState extends CellEditingState {
  final String keyValue;

  CellEditingKeyPressedState({
    required CellPosition cellPosition,
    required this.keyValue,
  }) : super(cellPosition);
}
