import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/manager/selection_controller/events/edit_cell_event.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_single_cell_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/editing_cell_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/shared/excel_actions/focused_cell_edit_action/focused_cell_edit_intent.dart';
import 'package:excel_grid/src/shared/excel_actions/move_action/move_action.dart';
import 'package:excel_grid/src/shared/excel_actions/move_action/move_intent.dart';
import 'package:flutter/material.dart';

class FocusedCellEditAction extends Action<FocusedCellEditIntent> {
  @override
  void invoke(FocusedCellEditIntent intent) {
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    SelectionState selectionState = selectionManager.state;
    if (selectionState is! EditingCellState) {
      selectionManager.handleEvent(EditCellEvent(selectionState.focusedCell));
    } else {
      selectionManager.handleEvent(SelectSingleCellEvent(selectionState.focusedCell));
      MoveAction moveAction = MoveAction();
      moveAction.invoke(MoveDownIntent());
    }
  }
}