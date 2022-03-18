import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/ui/cells/values/cell_value.dart';

abstract class AutoFiller {
  List<CellPositionValue> fill(List<CellValue> trainData, List<CellPosition> cellsToFill);
}