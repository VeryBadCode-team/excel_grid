import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_corners/multi_selection_corners.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_corners/selection_corners.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_data/multi_selection_data.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_data/selection_data.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_utils.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_end_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/models/dto/grid_position.dart';
import 'package:excel_grid/src/ui/cells/cell_title.dart';
import 'package:excel_grid/src/shared/enums/append_border.dart';

class MultipleCellsSelectedState extends SelectionState {
  final CellPosition selectedFromPosition;
  final CellPosition selectedToPosition;

  MultipleCellsSelectedState({
    required this.selectedFromPosition,
    required this.selectedToPosition,
  });

  MultipleCellsSelectedState copyWith({
    CellPosition? selectedFromPosition,
    CellPosition? selectedToPosition,
  }) {
    return MultipleCellsSelectedState(
      selectedFromPosition: selectedFromPosition ?? this.selectedFromPosition,
      selectedToPosition: selectedToPosition ?? this.selectedToPosition,
    );
  }

  @override
  CellPosition get focusedCell => selectedFromPosition;

  @override
  CellPosition get endSelectionCell => selectedToPosition;

  @override
  SelectionCorners get corners {
    return MultiSelectionCorners(
      from: selectedFromPosition,
      to: selectedToPosition,
      oppositeHorizontalSelection: horizontalSelectionReversed,
      oppositeVerticalSelection: verticalSelectionReversed,
    );
  }

  @override
  SelectionData get selectedCells => MultiSelectionData(corners);

  bool isCellSelected(CellPosition cellPosition) {
    return SelectionUtils.compareCellBetweenPoints(
      cell: cellPosition,
      a: selectedFromPosition,
      b: selectedToPosition,
    );
  }

  bool isTitleCellSelected(GridPosition gridPosition, GridDirection direction) {
    if (direction == GridDirection.vertical) {
      return SelectionUtils.compareCellBetweenPointsHorizontal(
        position: gridPosition,
        a: selectedFromPosition,
        b: selectedToPosition,
      );
    }
    return SelectionUtils.compareCellBetweenPointsVertical(
      position: gridPosition,
      a: selectedFromPosition,
      b: selectedToPosition,
    );
  }

  Set<AppendBorder> isVerticalSelectionExtreme(CellPosition cellPosition) {
    Set<AppendBorder> appendBorder = <AppendBorder>{};
    bool isFromExtreme = SelectionUtils.compareCellsVerticalPosition(cellPosition, selectedFromPosition);
    bool isToExtreme = SelectionUtils.compareCellsVerticalPosition(cellPosition, selectedToPosition);

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
    bool isFromExtreme = SelectionUtils.compareCellsHorizontalPosition(cellPosition, selectedFromPosition);
    bool isToExtreme = SelectionUtils.compareCellsHorizontalPosition(cellPosition, selectedToPosition);

    if (isFromExtreme) {
      appendBorder.add(horizontalSelectionReversed ? AppendBorder.right : AppendBorder.left);
    }
    if (isToExtreme) {
      appendBorder.add(horizontalSelectionReversed ? AppendBorder.left : AppendBorder.right);
    }
    return appendBorder;
  }

  bool get verticalSelectionReversed {
    return selectedFromPosition.columnPosition.index > selectedToPosition.columnPosition.index;
  }

  bool get horizontalSelectionReversed {
    return selectedFromPosition.rowPosition.index > selectedToPosition.rowPosition.index;
  }

  @override
  String toString() {
    return '${corners.leftTop}:${corners.rightBottom}';
  }
}

class MultipleCellsSelectionOngoingState extends MultipleCellsSelectedState {
  MultipleCellsSelectionOngoingState({
    required CellPosition selectedFromPosition,
    required CellPosition selectToPosition,
  }) : super(selectedFromPosition: selectedFromPosition, selectedToPosition: selectToPosition);
}

class MultipleCellsSelectionFinishedState extends MultipleCellsSelectedState with SelectionFinishedState {
  MultipleCellsSelectionFinishedState({
    required CellPosition selectedFromPosition,
    required CellPosition selectedToPosition,
  }) : super(selectedFromPosition: selectedFromPosition, selectedToPosition: selectedToPosition);
}
