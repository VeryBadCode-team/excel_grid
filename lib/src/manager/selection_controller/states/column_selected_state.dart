import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/states/multi_selected_state.dart';

class ColumnSelectedState extends MultipleCellsSelectionFinishedState {
  ColumnSelectedState({
    required CellPosition selectedFromPosition,
    required CellPosition selectedToPosition,
  }) : super(selectedFromPosition: selectedFromPosition, selectedToPosition: selectedToPosition);
}

class ColumnSelectionOngoingState extends ColumnSelectedState {
  ColumnSelectionOngoingState({
    required CellPosition selectedFromPosition,
    required CellPosition selectedToPosition,
  }) : super(selectedFromPosition: selectedFromPosition, selectedToPosition: selectedToPosition);
}

class ColumnSelectionEndState extends ColumnSelectedState {
  ColumnSelectionEndState({
    required CellPosition selectedFromPosition,
    required CellPosition selectedToPosition,
  }) : super(selectedFromPosition: selectedFromPosition, selectedToPosition: selectedToPosition);
}
