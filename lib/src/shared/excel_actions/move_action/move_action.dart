import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_single_cell_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/editing_cell_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/shared/excel_actions/move_action/move_intent.dart';
import 'package:flutter/material.dart';

class MoveAction extends Action<MoveIntent> {
  @override
  bool consumesKey(Intent intent) {
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    SelectionState selectionState = selectionManager.state;
    if (selectionState is EditingCellState) {
      return false;
    }
    return true;
  }

  @override
  void invoke(MoveIntent intent) {
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    CellPosition? movedCellPosition = calcMovedCell(intent);
    if (movedCellPosition != null) {
      selectionManager.handleEvent(SelectSingleCellEvent(movedCellPosition));
    }
  }

  CellPosition? calcMovedCell(MoveIntent intent) {
    GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    SelectionState selectionState = selectionManager.state;
    if (selectionState is EditingCellState) {
      return null;
    }
    CellPosition currentCell = selectionCell;
    int newX = currentCell.rowPosition.index + intent.moveOffset.dx.toInt();
    int newY = currentCell.columnPosition.index + intent.moveOffset.dy.toInt();
    if (newX < 1 || newY < 1 || newX > gridConfigManager.columnsCount || newY > gridConfigManager.rowsCount) {
      return null;
    }
    CellPosition newCellPosition = CellPosition(
      columnPosition: gridConfigManager.generateCellVertical(newY),
      rowPosition: gridConfigManager.generateCellHorizontal(newX),
    );
    return newCellPosition;
  }

  CellPosition get selectionCell {
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    return selectionManager.state.focusedCell;
  }
}