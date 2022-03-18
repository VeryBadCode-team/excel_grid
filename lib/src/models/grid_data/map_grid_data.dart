import 'package:excel_grid/excel_grid.dart';
import 'package:excel_grid/src/ui/cells/values/cell_value.dart';

class MapGridData extends GridData {

  const MapGridData._({
    required Map<String, Map<String, CellValue>> data,
  }) : super(data: data);

  factory MapGridData({
    required Map<String, Map<String, dynamic>> rawData,
  }) {
    Map<String, Map<String, CellValue>> data = <String, Map<String, CellValue>>{};
    for (String rowKey in rawData.keys) {
      if (rawData[rowKey] == null) {
        continue;
      }
      for (String columnKey in rawData[rowKey]!.keys) {
        if (data[rowKey] == null) {
          data[rowKey] = <String, CellValue>{};
        }
        data[rowKey]![columnKey] = CellValue.assign(rawData[rowKey]![columnKey]);
      }
    }
    return MapGridData._(
      data: data,
    );
  }
}
