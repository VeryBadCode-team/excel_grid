import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/events/selection_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/multi_selected_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';

class StartSelectingMultipleCellsEvent extends SelectionEvent {
  final CellPosition selectFromPosition;

  StartSelectingMultipleCellsEvent({
    required this.selectFromPosition,
  });

  @override
  void invoke(SelectionManager selectionManager) {
    selectionManager.setState(MultipleCellsSelectionOngoingState(
      selectedFromPosition: selectFromPosition,
      selectToPosition: selectFromPosition,
    ));
  }
}

class ContinueSelectingMultipleCellsEvent extends SelectionEvent {
  final CellPosition hoveredCell;

  ContinueSelectingMultipleCellsEvent(this.hoveredCell);

  @override
  void invoke(SelectionManager selectionManager) {
    SelectionState previousState = selectionManager.state;
    if (previousState is MultipleCellsSelectionOngoingState) {
      selectionManager.setState(MultipleCellsSelectionOngoingState(
          selectedFromPosition: previousState.selectedFromPosition,
          selectToPosition: hoveredCell,
      ));
    }
  }
}

class FinishSelectingMultipleCellsEvent extends SelectionEvent {
  FinishSelectingMultipleCellsEvent();

  @override
  void invoke(SelectionManager selectionManager) {
    SelectionState previousState = selectionManager.state;
    if (previousState is MultipleCellsSelectionOngoingState) {
      selectionManager.setState(MultipleCellsSelectionFinishedState(
        selectedFromPosition: previousState.selectedFromPosition,
        selectedToPosition: previousState.selectedToPosition,
      ));
    }
  }
}

class SelectMultipleCellsEvent extends FinishSelectingMultipleCellsEvent {
  final CellPosition selectFromPosition;
  final CellPosition selectToPosition;

  SelectMultipleCellsEvent({
    required this.selectFromPosition,
    required this.selectToPosition,
  });

  @override
  void invoke(SelectionManager selectionManager) {
    selectionManager.setState(MultipleCellsSelectionFinishedState(
      selectedFromPosition: selectFromPosition,
      selectedToPosition: selectToPosition,
    ));
  }
}
