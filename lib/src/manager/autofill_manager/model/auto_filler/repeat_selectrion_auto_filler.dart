import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/autofill_manager/model/auto_filler/auto_filler.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/ui/cells/values/cell_value.dart';

class RepeatSelectionAutoFiller extends AutoFiller {
  @override
  List<CellPositionValue> fill(List<CellValue?> trainData, List<CellPosition> cellsToFill) {
    List<CellPositionValue> result = List<CellPositionValue>.empty(growable: true);
    for (int i = 0; i < cellsToFill.length; i++) {
      int trainIndex = i % trainData.length;
      result.add(CellPositionValue(cellPosition: cellsToFill[i], value: trainData[trainIndex]));
    }
    return result;
  }
}