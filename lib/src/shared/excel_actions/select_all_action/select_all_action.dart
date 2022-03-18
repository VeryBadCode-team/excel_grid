import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_all_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/shared/excel_actions/select_all_action/select_all_intent.dart';
import 'package:flutter/material.dart';

class SelectAllAction extends Action<SelectAllIntent> {
  @override
  void invoke(SelectAllIntent intent) {
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    selectionManager.handleEvent(SelectAllEvent());
  }
}