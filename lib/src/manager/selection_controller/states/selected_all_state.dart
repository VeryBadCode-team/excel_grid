import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/states/multi_selected_state.dart';

class SelectedAllState extends MultipleCellsSelectionFinishedState {
  SelectedAllState({
    required CellPosition selectedFromPosition,
    required CellPosition selectedToPosition,
  }) : super(selectedFromPosition: selectedFromPosition, selectedToPosition: selectedToPosition);
}