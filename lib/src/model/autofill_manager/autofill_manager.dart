import 'package:excel_grid/src/model/autofill_manager/autofill_manager_events.dart';
import 'package:excel_grid/src/model/autofill_manager/autofill_manager_states.dart';
import 'package:flutter/cupertino.dart';

class AutofillManager extends ChangeNotifier {
  AutofillState state = AutofillDismissed();

  void handleEvent(AutofillEvent autofillEvent) {
    print('Handle event $autofillEvent');
    autofillEvent.execute(this);
  }

  void notifyShouldUpdate() {
    print('Update state $state}');
    notifyListeners();
  }
}