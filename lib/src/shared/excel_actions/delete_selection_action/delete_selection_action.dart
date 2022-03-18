import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/storage_manager/events/clear_selected_event.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/shared/excel_actions/delete_selection_action/delete_selection_intent.dart';
import 'package:flutter/material.dart';

class DeleteSelectionAction extends Action<DeleteSelectionIntent> {
  @override
  void invoke(DeleteSelectionIntent intent) {
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    StorageManager storageManager = globalLocator<StorageManager>();
    storageManager.handleEvent(ClearSelectedEvent(cells: selectionManager.state.selectedCells.merged));
  }
}