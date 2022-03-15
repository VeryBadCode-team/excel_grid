import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/ui/cells/values/cell_value.dart';
import 'package:excel_grid/src/utils/math/linear_trend.dart';

class CellAutofillManager {
  final List<CellValue?> trainData;
  final List<CellPosition> cellsToFill;

  CellAutofillManager({
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
      } else {
        print('not equal');
      }
    } catch (e) {
      print(e);
      // Do nothing
    }
    return RepeatSelectionAutoFiller().fill(trainData, cellsToFill);
  }

  bool get hasTrainDataEqualType {
    Type type = trainData.first.runtimeType;
    for (CellValue? cellValue in trainData) {
      print(cellValue.runtimeType);
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

abstract class CellAutoFiller {
  List<CellPositionValue> fill(List<CellValue> trainData, List<CellPosition> cellsToFill);
}

class RepeatSelectionAutoFiller extends CellAutoFiller {
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

class LinearRegressionAutoFiller extends CellAutoFiller {
  @override
  List<CellPositionValue> fill(List<CellValue> trainData, List<CellPosition> cellsToFill) {
    if( trainData.length < 2 ) {
      throw Exception();
    }
    List<CellPositionValue> result = List<CellPositionValue>.empty(growable: true);
    LinearTrend linearTrend = LinearTrend.train(
      trainData.map<num>((CellValue e) => (e as NumberCellValue).value).toList(),
    );
    for (int i = 0; i < cellsToFill.length; i++) {
      result.add(CellPositionValue(
        cellPosition: cellsToFill[i],
        value: NumberCellValue(
          value: linearTrend.getValue(i + trainData.length + 1),
        ),
      ));
    }
    return result;
  }
}

class DateTimeAutoFiller extends CellAutoFiller {
  @override
  List<CellPositionValue> fill(List<CellValue> trainData, List<CellPosition> cellsToFill) {
    if( trainData.length < 2 ) {
      throw Exception();
    }
    List<CellPositionValue> result = List<CellPositionValue>.empty(growable: true);
    LinearTrend linearTrend = LinearTrend.train(
      trainData.map<num>((CellValue e) => (e as DateTimeCellValue).value.millisecondsSinceEpoch).toList(),
    );
    for (int i = 0; i < cellsToFill.length; i++) {
      result.add(CellPositionValue(
        cellPosition: cellsToFill[i],
        value: DateTimeCellValue(
          value: DateTime.fromMillisecondsSinceEpoch(
            linearTrend.getValue(i + trainData.length + 1).toInt(),
          ),
        ),
      ));
    }
    return result;
  }
}
