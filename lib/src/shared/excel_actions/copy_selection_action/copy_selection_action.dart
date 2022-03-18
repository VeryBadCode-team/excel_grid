import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/shared/excel_actions/copy_selection_action/copy_selection_action.dart';
import 'package:excel_grid/src/shared/excel_actions/copy_selection_action/copy_selection_intent.dart';
import 'package:excel_grid/src/shared/generators/csv_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopySelectionAction extends Action<CopySelectionIntent> {
  @override
  void invoke(CopySelectionIntent intent) {
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    StorageManager storageManager = globalLocator<StorageManager>();
    CsvGenerator selectionCsvGenerator = CsvGenerator.fromCells(
      selectedCells: selectionManager.state.selectedCells.byRows,
      storageManager: storageManager,
    );
    String selectedText = selectionCsvGenerator.generateString(seperator: '\t');
    Clipboard.setData(ClipboardData(text: selectedText));
  }
}
