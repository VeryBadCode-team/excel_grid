import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_corners/selection_corners.dart';

class SingleSelectionCorners extends SelectionCorners {
  final CellPosition cellPosition;

  SingleSelectionCorners(this.cellPosition);

  @override
  CellPosition get leftBottom => cellPosition;

  @override
  CellPosition get leftTop => cellPosition;

  @override
  CellPosition get rightBottom => cellPosition;

  @override
  CellPosition get rightTop => cellPosition;
}