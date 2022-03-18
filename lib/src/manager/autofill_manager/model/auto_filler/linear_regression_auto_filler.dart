import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/autofill_manager/model/auto_filler/auto_filler.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/ui/cells/values/cell_value.dart';
import 'package:excel_grid/src/shared/math/linear_trend.dart';

class LinearRegressionAutoFiller extends AutoFiller {
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