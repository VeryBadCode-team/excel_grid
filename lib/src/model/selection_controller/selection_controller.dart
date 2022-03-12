import 'package:excel_grid/src/model/selection_controller/selection_controller_events.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';
import 'package:flutter/cupertino.dart';

class SelectionController extends ChangeNotifier {
  SelectionState state = DefaultSelectionState();

  void handleEvent(SelectionEvent selectionEvent) {
    print('Handle event $selectionEvent');
    selectionEvent.execute(this);
  }

  void notifyShouldUpdate() {
    print('Update state ${state} - ${state is MultiSelectedState}');
    notifyListeners();
  }
}