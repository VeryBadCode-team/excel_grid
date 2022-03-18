import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/manager/selection_controller/events/edit_cell_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/editing_cell_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/multi_selected_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/single_selected_state.dart';
import 'package:excel_grid/src/shared/excel_actions/character_cell_activate_action/character_cell_activate_intent.dart';
import 'package:flutter/material.dart';

class CharacterCellActivateAction extends Action<CharacterCellActivateIntent> {
  @override
  void invoke(CharacterCellActivateIntent intent) {
    final SelectionManager selectionManager = globalLocator<SelectionManager>();
    SelectionState selectionState = selectionManager.state;
    if (selectionState is! EditingCellState) {
      if (selectionState is SingleCellSelectedState) {
        selectionManager.handleEvent(KeyPressedEvent(
          cellPosition: selectionState.cellPosition,
          pressedKeyCharacter: intent.keyCharacterValue!,
        ));
      }
      if (selectionState is MultipleCellsSelectedState) {
        selectionManager.handleEvent(KeyPressedEvent(
          cellPosition: selectionState.selectedFromPosition,
          pressedKeyCharacter: intent.keyCharacterValue!,
        ));
      }
    }
  }
}
