import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/dto/grid_position.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_events.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';
import 'package:flutter/cupertino.dart';

class SelectionController extends ChangeNotifier {
  // TODO(dominik): Make dynamic;
  SelectionState state = SingleSelectedState(
    const CellPosition(
      horizontalPosition: GridPosition(index: 1, key: 'A'),
      verticalPosition: GridPosition(index: 1, key: '1'),
    ),
  );

  void handleEvent(SelectionEvent selectionEvent) {
    print('Handle event $selectionEvent');
    selectionEvent.execute(this);
  }

  void notifyShouldUpdate() {
    print('Update state ${state} - ${state is MultiSelectedState}');
    notifyListeners();
  }
}
