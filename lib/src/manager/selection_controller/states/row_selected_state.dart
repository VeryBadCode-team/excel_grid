import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/states/multi_selected_state.dart';

class RowSelectedState extends MultipleCellsSelectionFinishedState {
  RowSelectedState({
    required CellPosition selectedFromPosition,
    required CellPosition selectedToPosition,
  }) : super(selectedFromPosition: selectedFromPosition, selectedToPosition: selectedToPosition);
}

class RowSelectionOngoingState extends RowSelectedState {
  RowSelectionOngoingState({
    required CellPosition selectedFromPosition,
    required CellPosition selectedToPosition,
  }) : super(selectedFromPosition: selectedFromPosition, selectedToPosition: selectedToPosition);
}

class RowSelectionFinishedState extends RowSelectedState {
  RowSelectionFinishedState({
    required CellPosition selectedFromPosition,
    required CellPosition selectedToPosition,
  }) : super(selectedFromPosition: selectedFromPosition, selectedToPosition: selectedToPosition);
}
