import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/autofill_manager/autofill_manager.dart';
import 'package:excel_grid/src/manager/autofill_manager/events/autofill_event.dart';
import 'package:excel_grid/src/manager/autofill_manager/model/autofill_selector/autofill_selector.dart';
import 'package:excel_grid/src/manager/autofill_manager/states/autofill_dismissed_state.dart';
import 'package:excel_grid/src/manager/autofill_manager/states/autofill_selection_state.dart';
import 'package:excel_grid/src/manager/autofill_manager/states/autofill_state.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_multiple_cells_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/manager/storage_manager/events/edit_multiple_cells_event.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';

class StartAutofillSelectionEvent extends AutofillEvent {
  final CellPosition autofillFromPosition;

  StartAutofillSelectionEvent(this.autofillFromPosition);

  @override
  void invoke(AutofillManager autofillManager) {
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    autofillManager.state = AutofillSelectionOngoingState(
      verticallySelection: true,
      autofillFrom: autofillFromPosition,
      autofillTo: autofillFromPosition,
      selectionState: selectionManager.state,
    );
  }
}

class ContinueAutofillSelection extends AutofillEvent {
  final CellPosition hoveredCell;

  ContinueAutofillSelection(this.hoveredCell);

  @override
  void invoke(AutofillManager autofillManager) {
    GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
    AutofillState state = autofillManager.state;
    if (state is AutofillSelectionOngoingState) {
      SelectionState selectionState = state.selectionState;

      // horizontal case
      CellPosition leftBottomCell = selectionState.corners.leftBottom;
      CellPosition rightBottomCell = selectionState.corners.rightBottom;
      CellPosition rightTopCell = selectionState.corners.rightTop;

      int horizontalDiff = hoveredCell.rowPosition.index - rightBottomCell.rowPosition.index;
      int verticalDiff = hoveredCell.columnPosition.index - rightBottomCell.columnPosition.index;
      if (horizontalDiff <= 0 && verticalDiff <= 0) {
        return;
      }

      late CellPosition autofillFromPosition;
      late CellPosition autofillToPosition;

      // Go horizontally
      if (horizontalDiff > verticalDiff) {
        autofillFromPosition = rightTopCell.copyWith(
          rowPosition: gridConfigManager.generateCellHorizontal(rightTopCell.rowPosition.index + 1),
        );
        autofillToPosition = rightBottomCell.copyWith(rowPosition: hoveredCell.rowPosition);
        // Go vertically
      } else {
        autofillFromPosition = leftBottomCell.copyWith(
          columnPosition: gridConfigManager.generateCellVertical(leftBottomCell.columnPosition.index + 1),
        );
        autofillToPosition = rightBottomCell.copyWith(columnPosition: hoveredCell.columnPosition);
      }

      autofillManager.state = state.copyWith(
        selectedFromPosition: autofillFromPosition,
        selectedToPosition: autofillToPosition,
        verticallySelection: horizontalDiff < verticalDiff,
      );
      autofillManager.notifyShouldUpdate();
    }
  }
}

class FinishAutofillSelectionEvent extends AutofillEvent {
  FinishAutofillSelectionEvent();

  @override
  void invoke(AutofillManager autofillManager) {
    StorageManager storageManager = globalLocator<StorageManager>();
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    AutofillState state = autofillManager.state;
    if (state is AutofillSelectionOngoingState) {
      selectionManager.handleEvent(SelectMultipleCellsEvent(
        selectFromPosition: state.selectionState.corners.leftTop,
        selectToPosition: state.selectedToPosition,
      ));

      late List<List<CellPosition>> selection;
      late List<List<CellPosition>> autofillSelection;
      if (state.verticallySelection) {
        selection = state.selectionState.selectedCells.byColumns;
        autofillSelection = state.selectedCells.byColumns;
      } else {
        selection = state.selectionState.selectedCells.byRows;
        autofillSelection = state.selectedCells.byRows;
      }

      for (int i = 0; i < selection.length; i++) {
        List<CellPosition> selectionColumn = selection[i];
        List<CellPosition> autofillColumn = autofillSelection[i];
        List<CellPositionValue> cellPositionsValue = storageManager.getCellsData(selectionColumn);
        AutofillSelector autofillSelector = AutofillSelector(
          trainData: cellPositionsValue.map((CellPositionValue e) => e.value).toList(),
          cellsToFill: autofillColumn,
        );

        List<CellPositionValue> filledValues = autofillSelector.fill();
        storageManager.handleEvent(EditMultipleCellsEvent(cellValues: filledValues));
      }
    }
    autofillManager.state = AutofillDismissedState();
  }
}
