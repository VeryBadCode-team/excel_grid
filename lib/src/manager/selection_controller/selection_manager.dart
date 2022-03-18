import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/events/selection_event.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/single_selected_state.dart';
import 'package:excel_grid/src/models/dto/grid_position.dart';
import 'package:flutter/cupertino.dart';

class SelectionManager extends ChangeNotifier {
  SelectionState state = SingleCellSelectedState(
    const CellPosition(
      rowPosition: GridPosition(index: 1, key: 'A'),
      columnPosition: GridPosition(index: 1, key: '1'),
    ),
  );

  void setState(SelectionState state) {
    this.state = state;
    notifyListeners();
  }

  void handleEvent(SelectionEvent selectionEvent) {
    selectionEvent.invoke(this);
  }

  void notifyShouldUpdate() {
    notifyListeners();
  }
}
