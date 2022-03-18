import 'package:excel_grid/src/ui/cells/values/cell_value.dart';

class GridData {
  final Map<String, Map<String, CellValue>> data;

  const GridData({
    required this.data,
  });
}