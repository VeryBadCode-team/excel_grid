import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/events/selection_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/single_selected_state.dart';

class SelectSingleCellEvent extends SelectionEvent {
  final CellPosition cellPosition;

  SelectSingleCellEvent(this.cellPosition);

  @override
  void invoke(SelectionManager selectionManager) {
    selectionManager.setState(SingleCellSelectedState(cellPosition));
  }
}
