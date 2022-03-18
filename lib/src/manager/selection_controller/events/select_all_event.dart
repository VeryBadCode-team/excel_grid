import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_multiple_cells_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selected_all_state.dart';

class SelectAllEvent extends FinishSelectingMultipleCellsEvent {
  @override
  void invoke(SelectionManager selectionManager) {
    GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
    selectionManager.setState(SelectedAllState(
      selectedFromPosition: CellPosition(
        rowPosition: gridConfigManager.generateCellHorizontal(1),
        columnPosition: gridConfigManager.generateCellVertical(1),
      ),
      selectedToPosition: CellPosition(
        rowPosition: gridConfigManager.generateCellHorizontal(gridConfigManager.columnsCount),
        columnPosition: gridConfigManager.generateCellVertical(gridConfigManager.rowsCount),
      ),
    ));
  }
}
