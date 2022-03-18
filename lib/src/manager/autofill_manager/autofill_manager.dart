import 'package:excel_grid/src/manager/autofill_manager/events/autofill_event.dart';
import 'package:excel_grid/src/manager/autofill_manager/states/autofill_dismissed_state.dart';
import 'package:excel_grid/src/manager/autofill_manager/states/autofill_state.dart';
import 'package:flutter/cupertino.dart';

class AutofillManager extends ChangeNotifier {
  AutofillState state = AutofillDismissedState();

  void handleEvent(AutofillEvent autofillEvent) {
    autofillEvent.invoke(this);
  }

  void notifyShouldUpdate() {
    notifyListeners();
  }
}