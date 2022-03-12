import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/dto/grid_position.dart';
import 'package:excel_grid/src/ui/cells/cell_title.dart';
import 'package:excel_grid/src/utils/enums/append_border.dart';

abstract class SelectionState {}

class DefaultSelectionState extends SelectionState {}

class SingleSelectedState extends SelectionState {
  final CellPosition cellPosition;

  SingleSelectedState(this.cellPosition);

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