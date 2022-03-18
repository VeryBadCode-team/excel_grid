import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_multiple_cells_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/storage_manager/events/edit_multiple_cells_event.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/models/dto/grid_position.dart';
import 'package:excel_grid/src/shared/excel_actions/paste_action/paste_intent.dart';
import 'package:excel_grid/src/shared/generators/csv_parser.dart';
import 'package:excel_grid/src/ui/cells/values/cell_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasteAction extends Action<PasteIntent> {
  @override
  Future<void> invoke(PasteIntent intent) async {
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      SelectionManager selectionManager = globalLocator<SelectionManager>();
      StorageManager storageManager = globalLocator<StorageManager>();
      GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
      String clipboardValue = clipboardData.text!;
      List<List<dynamic>> lines = CsvParser.fromCsv(clipboardValue, seperator: '\t');
      List<CellPositionValue> cellValues = List<CellPositionValue>.empty(growable: true);
      CellPosition currentCell = selectionManager.state.focusedCell;
      for (int y = 0; y < lines.length; y++) {
        GridPosition positionY = gridConfigManager.generateCellVertical(currentCell.columnPosition.index + y);
        List<dynamic> words = lines[y];
        for (int x = 0; x < words.length; x++) {
          GridPosition positionX = gridConfigManager.generateCellHorizontal(currentCell.rowPosition.index + x);
          cellValues.add(
            CellPositionValue(
              cellPosition: CellPosition(
                columnPosition: positionY,
                rowPosition: positionX,
              ),
              value: CellValue.assign(words[x]),
            ),
          );
        }
      }
      CellPosition firstSelectedPosition = cellValues.first.cellPosition;
      CellPosition lastSelectedPosition = cellValues.last.cellPosition;
      selectionManager.handleEvent(SelectMultipleCellsEvent(
        selectFromPosition: firstSelectedPosition,
        selectToPosition: lastSelectedPosition,
      ));
      storageManager.handleEvent(EditMultipleCellsEvent(cellValues: cellValues));
    }
  }
}
