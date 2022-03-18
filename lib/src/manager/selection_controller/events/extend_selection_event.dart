import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/events/selection_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/multi_selected_state.dart';

class ExtendSelectionEvent extends SelectionEvent {
  final CellPosition extendSelectionToPosition;

  ExtendSelectionEvent({
    required this.extendSelectionToPosition,
  });

  @override
  void invoke(SelectionManager selectionManager) {
    CellPosition fromCell = selectionManager.state.focusedCell;
    selectionManager.setState(MultipleCellsSelectionFinishedState(selectedFromPosition: fromCell, selectedToPosition: extendSelectionToPosition));
  }
}
