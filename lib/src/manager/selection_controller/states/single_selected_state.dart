import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_corners/selection_corners.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_corners/single_selection_corners.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_data/selection_data.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_data/single_selection_data.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_end_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';

class SingleCellSelectedState extends SelectionState with SelectionFinishedState {
  final CellPosition cellPosition;

  SingleCellSelectedState(this.cellPosition);

  @override
  CellPosition get focusedCell => cellPosition;

  @override
  CellPosition get endSelectionCell => cellPosition;

  @override
  SelectionCorners get corners => SingleSelectionCorners(cellPosition);

  @override
  SelectionData get selectedCells => SingleSelectionData(cellPosition);

  @override
  String toString() {
    return cellPosition.toString();
  }
}