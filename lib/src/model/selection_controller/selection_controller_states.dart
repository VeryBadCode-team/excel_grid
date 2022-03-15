import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/dto/grid_position.dart';
import 'package:excel_grid/src/model/grid_config.dart';
import 'package:excel_grid/src/ui/cells/cell_title.dart';
import 'package:excel_grid/src/utils/enums/append_border.dart';

abstract class SelectionState {
  CellPosition get focusedCell;

  CellPosition get lastFocusedCell;

  CellPosition get leftTopCell;

  CellPosition get leftBottomCell;

  CellPosition get rightTopCell;

  CellPosition get rightBottomCell;

  List<List<CellPosition>> get selectedCellsByRows;

  List<List<CellPosition>> get selectedCellsByColumns;

  List<CellPosition> get selectedCellsMerged;
}

abstract class SelectionEndState {}

class SingleSelectedState extends SelectionState with SelectionEndState {
  final CellPosition cellPosition;

  SingleSelectedState(this.cellPosition);

  @override
  CellPosition get focusedCell => cellPosition;

  @override
  CellPosition get lastFocusedCell => cellPosition;

  @override
  List<List<CellPosition>> get selectedCellsByRows => <List<CellPosition>>[
        <CellPosition>[cellPosition]
      ];

  @override
  List<List<CellPosition>> get selectedCellsByColumns => <List<CellPosition>>[
        <CellPosition>[cellPosition]
      ];

  @override
  List<CellPosition> get selectedCellsMerged => <CellPosition>[cellPosition];

  @override
  String toString() {
    return cellPosition.toString();
  }

  @override
  CellPosition get leftBottomCell => cellPosition;

  @override
  CellPosition get leftTopCell => cellPosition;

  @override
  CellPosition get rightBottomCell => cellPosition;

  @override
  CellPosition get rightTopCell => cellPosition;
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
  CellPosition get lastFocusedCell => to;

  @override
  List<List<CellPosition>> get selectedCellsByRows {
    GridConfig gridConfig = globalLocator<GridConfig>();
    List<List<CellPosition>> selected = List<List<CellPosition>>.empty(growable: true);
    CellPosition selectionFrom = leftTopCell;
    CellPosition selectionTo = rightBottomCell;
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
  List<List<CellPosition>> get selectedCellsByColumns {
    GridConfig gridConfig = globalLocator<GridConfig>();
    List<List<CellPosition>> selected = List<List<CellPosition>>.empty(growable: true);
    CellPosition selectionFrom = leftTopCell;
    CellPosition selectionTo = rightBottomCell;
    for (int x = selectionFrom.horizontalPosition.index; x <= selectionTo.horizontalPosition.index; x++) {
      List<CellPosition> columnCells = List<CellPosition>.empty(growable: true);
      for (int y = selectionFrom.verticalPosition.index; y <= selectionTo.verticalPosition.index; y++) {
        columnCells.add(CellPosition(
          verticalPosition: gridConfig.generateCellVertical(y),
          horizontalPosition: gridConfig.generateCellHorizontal(x),
        ));
      }
      selected.add(columnCells);
    }
    return selected;
  }

  @override
  List<CellPosition> get selectedCellsMerged {
    List<List<CellPosition>> allCells = selectedCellsByRows;
    List<CellPosition> mergedCells = List<CellPosition>.empty(growable: true);
    for (List<CellPosition> row in allCells) {
      mergedCells.addAll(row);
    }
    return mergedCells;
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
      appendBorder.add(verticalSelectionReversed ? AppendBorder.bottom : AppendBorder.top);
    }
    if (isToExtreme) {
      appendBorder.add(verticalSelectionReversed ? AppendBorder.top : AppendBorder.bottom);
    }
    return appendBorder;
  }

  Set<AppendBorder> isHorizontalSelectionExtreme(CellPosition cellPosition) {
    Set<AppendBorder> appendBorder = <AppendBorder>{};
    bool isFromExtreme = compareCellsHorizontalPosition(cellPosition, from);
    bool isToExtreme = compareCellsHorizontalPosition(cellPosition, to);

    if (isFromExtreme) {
      appendBorder.add(horizontalSelectionReversed ? AppendBorder.right : AppendBorder.left);
    }
    if (isToExtreme) {
      appendBorder.add(horizontalSelectionReversed ? AppendBorder.left : AppendBorder.right);
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
    return from.verticalPosition.index > to.verticalPosition.index;
  }

  bool get horizontalSelectionReversed {
    return from.horizontalPosition.index > to.horizontalPosition.index;
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
  CellPosition get leftBottomCell {
    if (verticalSelectionReversed && horizontalSelectionReversed) {
      return from.copyWith(horizontalPosition: to.horizontalPosition);
    } else if (!verticalSelectionReversed && !horizontalSelectionReversed) {
      return from.copyWith(verticalPosition: to.verticalPosition);
    } else if (horizontalSelectionReversed) {
      return to;
    }
    return from;
  }

  @override
  CellPosition get leftTopCell {
    if (verticalSelectionReversed && horizontalSelectionReversed) {
      return to;
    } else if (!verticalSelectionReversed && !horizontalSelectionReversed) {
      return from;
    } else if (horizontalSelectionReversed) {
      return from.copyWith(horizontalPosition: to.horizontalPosition);
    }
    return from.copyWith(verticalPosition: to.verticalPosition);
  }

  @override
  CellPosition get rightBottomCell {
    if (verticalSelectionReversed && horizontalSelectionReversed) {
      return from;
    } else if (!verticalSelectionReversed && !horizontalSelectionReversed) {
      return to;
    } else if (verticalSelectionReversed) {
      return from.copyWith(horizontalPosition: to.horizontalPosition);
    }
    return from.copyWith(verticalPosition: to.verticalPosition);
  }

  @override
  CellPosition get rightTopCell {
    if (verticalSelectionReversed && horizontalSelectionReversed) {
      return from.copyWith(verticalPosition: to.verticalPosition);
    } else if (!verticalSelectionReversed && !horizontalSelectionReversed) {
      return from.copyWith(horizontalPosition: to.horizontalPosition);
    } else if (horizontalSelectionReversed) {
      return from;
    }
    return to;
  }

  @override
  String toString() {
    return '$leftTopCell:$rightBottomCell';
  }
}

class MultiSelectedOngoingState extends MultiSelectedState {
  MultiSelectedOngoingState({
    required CellPosition from,
    required CellPosition to,
  }) : super(from: from, to: to);
}

class MultiSelectedEndState extends MultiSelectedState with SelectionEndState {
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
