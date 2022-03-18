import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';

abstract class SelectionEvent {
  void invoke(SelectionManager selectionManager);
}