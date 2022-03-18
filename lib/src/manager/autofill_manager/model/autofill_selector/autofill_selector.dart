import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/autofill_manager/model/auto_filler/repeat_selectrion_auto_filler.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/ui/cells/values/cell_value.dart';

class AutofillSelector {
  final List<CellValue?> trainData;
  final List<CellPosition> cellsToFill;

  AutofillSelector({
    required this.trainData,
    required this.cellsToFill,
  });

  List<CellPositionValue> fill() {
    try {
      if (hasTrainDataEqualType) {
        List<CellValue> filteredTrainData = List<CellValue>.empty(growable: true);
        for (CellValue? cellValue in trainData) {
          filteredTrainData.add(cellValue!);
        }
        return trainData.first!.autoFiller.fill(filteredTrainData, cellsToFill);
      }
    } catch (e) {
      // Do nothing
    }
    return RepeatSelectionAutoFiller().fill(trainData, cellsToFill);
  }

  bool get hasTrainDataEqualType {
    Type type = trainData.first.runtimeType;
    for (CellValue? cellValue in trainData) {
      if (cellValue == null) {
        return false;
      }
      if (cellValue.runtimeType != type) {
        return false;
      }
    }
    return true;
  }
}