import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_multiple_cells_event.dart';
import 'package:excel_grid/src/manager/selection_controller/events/selection_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/row_selected_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/models/dto/grid_position.dart';

class SelectRowEvent extends FinishSelectingMultipleCellsEvent {
  final GridPosition rowPosition;

  SelectRowEvent(this.rowPosition) : super();

  @override
  void invoke(SelectionManager selectionManager) {
    GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
    selectionManager.setState(RowSelectedState(
      selectedFromPosition: CellPosition(
        rowPosition: gridConfigManager.generateCellHorizontal(1),
        columnPosition: rowPosition,
      ),
      selectedToPosition: CellPosition(
        rowPosition: gridConfigManager.generateCellHorizontal(gridConfigManager.columnsCount),
        columnPosition: rowPosition,
      ),
    ));
  }
}

class StartSelectingMultipleRowsEvent extends FinishSelectingMultipleCellsEvent {
  final GridPosition selectFromRow;

  StartSelectingMultipleRowsEvent({
    required this.selectFromRow,
  });

  @override
  void invoke(SelectionManager selectionManager) {
    GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
    selectionManager.setState(RowSelectionOngoingState(
      selectedFromPosition: CellPosition(
        rowPosition: gridConfigManager.generateCellHorizontal(1),
        columnPosition: selectFromRow,
      ),
      selectedToPosition: CellPosition(
        rowPosition: gridConfigManager.generateCellHorizontal(gridConfigManager.columnsCount),
        columnPosition: selectFromRow,
      ),
    ));
  }
}

class ContinueSelectingMultipleRowsEvent extends FinishSelectingMultipleCellsEvent {
  final GridPosition hoveredRow;

  ContinueSelectingMultipleRowsEvent(this.hoveredRow);

  @override
  void invoke(SelectionManager selectionManager) {
    GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
    SelectionState previousState = selectionManager.state;
    if (previousState is RowSelectionOngoingState) {
      selectionManager.setState(RowSelectionOngoingState(
        selectedFromPosition: previousState.selectedFromPosition,
        selectedToPosition: CellPosition(
          rowPosition: gridConfigManager.generateCellHorizontal(gridConfigManager.columnsCount),
          columnPosition: hoveredRow,
        ),
      ));
    }
  }
}

class FinishSelectingMultipleRowsEvent extends SelectionEvent {
  FinishSelectingMultipleRowsEvent();

  @override
  void invoke(SelectionManager selectionManager) {
    SelectionState previousState = selectionManager.state;
    if (previousState is RowSelectionOngoingState) {
      selectionManager.setState(RowSelectionFinishedState(
        selectedFromPosition: previousState.selectedFromPosition,
        selectedToPosition: previousState.selectedToPosition,
      ));
    }
  }
}
