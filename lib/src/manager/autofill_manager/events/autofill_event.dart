import 'package:excel_grid/src/manager/autofill_manager/autofill_manager.dart';

abstract class AutofillEvent {
  void invoke(AutofillManager autofillManager);
}
