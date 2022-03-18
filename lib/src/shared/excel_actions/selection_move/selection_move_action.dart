import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/multi_selected_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/shared/excel_actions/move_action/move_action.dart';
import 'package:excel_grid/src/shared/excel_actions/move_action/move_intent.dart';

class SelectionMoveAction extends MoveAction {
  @override
  void invoke(MoveIntent intent) {
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    CellPosition? movedCellPosition = calcMovedCell(intent);
    if (movedCellPosition != null) {
      selectionManager.state = MultipleCellsSelectionFinishedState(
        selectedFromPosition: selectionManager.state.focusedCell,
        selectedToPosition: movedCellPosition,
      );
      selectionManager.notifyShouldUpdate();
    }
  }

  @override
  CellPosition get selectionCell {
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    SelectionState state = selectionManager.state;
    if (state is MultipleCellsSelectedState) {
      return state.selectedToPosition;
    }
    return selectionManager.state.focusedCell;
  }
}