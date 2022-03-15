import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/model/autofill_manager/autofill_manager.dart';
import 'package:excel_grid/src/model/autofill_manager/autofill_manager_states.dart';
import 'package:excel_grid/src/model/autofill_manager/cell_filler.dart';
import 'package:excel_grid/src/model/grid_config.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_events.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager_events.dart';

abstract class AutofillEvent {
  void execute(AutofillManager autofillManager);
}

class AutofillStarted extends AutofillEvent {
  final CellPosition from;

  AutofillStarted(this.from);

  @override
  void execute(AutofillManager autofillManager) {
    SelectionController selectionController = globalLocator<SelectionController>();
    autofillManager.state = AutofillOngoingState(
      verticallySelection: true,
      from: from,
      to: from,
      selectionState: selectionController.state,
    );
  }
}

class AutofillOngoing extends AutofillEvent {
  final CellPosition hoveredCell;

  AutofillOngoing(this.hoveredCell);

  @override
  void execute(AutofillManager autofillManager) {
    GridConfig gridConfig = globalLocator<GridConfig>();
    AutofillState state = autofillManager.state;
    if (state is AutofillOngoingState) {
      SelectionState selectionState = state.selectionState;

      // horizontal case
      CellPosition leftBottomCell = selectionState.leftBottomCell;
      CellPosition rightBottomCell = selectionState.rightBottomCell;
      CellPosition rightTopCell = selectionState.rightTopCell;

      int horizontalDiff = hoveredCell.horizontalPosition.index - rightBottomCell.horizontalPosition.index;
      int verticalDiff = hoveredCell.verticalPosition.index - rightBottomCell.verticalPosition.index;
      print('$horizontalDiff ----- $verticalDiff');
      if (horizontalDiff <= 0 && verticalDiff <= 0) {
        return;
      }

      late CellPosition fromPosition;
      late CellPosition toPosition;

      // Go horizontally
      if (horizontalDiff > verticalDiff) {
        fromPosition = rightTopCell.copyWith(
          horizontalPosition: gridConfig.generateCellHorizontal(rightTopCell.horizontalPosition.index + 1),
        );
        toPosition = rightBottomCell.copyWith(horizontalPosition: hoveredCell.horizontalPosition);
        // Go vertically
      } else {
        fromPosition = leftBottomCell.copyWith(
          verticalPosition: gridConfig.generateCellVertical(leftBottomCell.verticalPosition.index + 1),
        );
        toPosition = rightBottomCell.copyWith(verticalPosition: hoveredCell.verticalPosition);
      }

      autofillManager.state = state.copyWith(
        from: fromPosition,
        to: toPosition,
        verticallySelection: horizontalDiff < verticalDiff,
      );
      autofillManager.notifyShouldUpdate();
    }
  }
}

class AutofillEnd extends AutofillEvent {
  AutofillEnd();

  @override
  void execute(AutofillManager autofillManager) {
    StorageManager storageManager = globalLocator<StorageManager>();
    SelectionController selectionController = globalLocator<SelectionController>();
    AutofillState state = autofillManager.state;
    if (state is AutofillOngoingState) {
      selectionController.handleEvent(MultiSelectEvent(
        fromPosition: state.selectionState.leftTopCell,
        toPosition: state.to,
      ));

      late List<List<CellPosition>> selection;
      late List<List<CellPosition>> autofillSelection;
      if (state.verticallySelection) {
        selection = state.selectionState.selectedCellsByColumns;
        autofillSelection = state.selectedCellsByColumns;
      } else {
        selection = state.selectionState.selectedCellsByRows;
        autofillSelection = state.selectedCellsByRows;
      }

      for (int i = 0; i < selection.length; i++) {
        List<CellPosition> selectionColumn = selection[i];
        List<CellPosition> autofillColumn = autofillSelection[i];
        List<CellPositionValue> cellPositionsValue = storageManager.getCellsData(selectionColumn);
        CellAutofillManager cellAutofillManager = CellAutofillManager(
          trainData: cellPositionsValue.map((CellPositionValue e) => e.value).toList(),
          cellsToFill: autofillColumn,
        );

        List<CellPositionValue> filledValues = cellAutofillManager.fill();
        storageManager.handleEvent(MultiCellEditedEvent(cellValues: filledValues));
      }
    }
    autofillManager.state = AutofillDismissed();
  }
}
