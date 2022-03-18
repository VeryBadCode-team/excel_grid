import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_corners/selection_corners.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_data/selection_data.dart';

abstract class SelectionState {
  CellPosition get focusedCell;

  CellPosition get endSelectionCell;

  SelectionCorners get corners;

  SelectionData get selectedCells;
}
