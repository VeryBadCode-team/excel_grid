import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_multiple_cells_event.dart';
import 'package:excel_grid/src/manager/selection_controller/events/selection_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/column_selected_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/models/dto/grid_position.dart';

class SelectColumnEvent extends FinishSelectingMultipleCellsEvent {
  final GridPosition columnPosition;

  SelectColumnEvent(this.columnPosition) : super();

  @override
  void invoke(SelectionManager selectionManager) {
    GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
    selectionManager.setState(ColumnSelectedState(
      selectedFromPosition: CellPosition(
        rowPosition: columnPosition,
        columnPosition: gridConfigManager.generateCellVertical(1),
      ),
      selectedToPosition: CellPosition(
        rowPosition: columnPosition,
        columnPosition: gridConfigManager.generateCellVertical(gridConfigManager.rowsCount),
      ),
    ));
  }
}

class StartSelectingMultipleColumnsEvent extends FinishSelectingMultipleCellsEvent {
  final GridPosition selectFromColumn;

  StartSelectingMultipleColumnsEvent({
    required this.selectFromColumn,
  });

  @override
  void invoke(SelectionManager selectionManager) {
    GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
    selectionManager.setState(ColumnSelectionOngoingState(
      selectedFromPosition: CellPosition(
        rowPosition: selectFromColumn,
        columnPosition: gridConfigManager.generateCellVertical(1),
      ),
      selectedToPosition: CellPosition(
        rowPosition: selectFromColumn,
        columnPosition: gridConfigManager.generateCellVertical(gridConfigManager.rowsCount),
      ),
    ));
  }
}

class ContinueSelectingMultipleColumnsEvent extends FinishSelectingMultipleCellsEvent {
  final GridPosition hoveredColumn;

  ContinueSelectingMultipleColumnsEvent(this.hoveredColumn) : super();

  @override
  void invoke(SelectionManager selectionManager) {
    GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
    SelectionState previousState = selectionManager.state;
    if (previousState is ColumnSelectionOngoingState) {
      selectionManager.setState(ColumnSelectionOngoingState(
        selectedFromPosition: previousState.selectedFromPosition,
        selectedToPosition: CellPosition(
          rowPosition: hoveredColumn,
          columnPosition: gridConfigManager.generateCellVertical(gridConfigManager.rowsCount),
        ),
      ));
    }
  }
}

class FinishSelectingMultipleColumnsEvent extends SelectionEvent {
  FinishSelectingMultipleColumnsEvent();

  @override
  void invoke(SelectionManager selectionManager) {
    SelectionState previousState = selectionManager.state;
    if (previousState is ColumnSelectionOngoingState) {
      selectionManager.setState(ColumnSelectionEndState(
        selectedFromPosition: previousState.selectedFromPosition,
        selectedToPosition: previousState.selectedToPosition,
      ));
    }
  }
}
