import '../ui/cells/values/cell_value.dart';

class GridData {
  final Map<String, Map<String, CellValue>> data;

  GridData({
    required this.data,
  });

  factory GridData.fromMap({
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
    return GridData(
      data: data,
    );
  }
}
