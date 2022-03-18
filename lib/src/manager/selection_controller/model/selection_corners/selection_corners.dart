import 'package:excel_grid/src/models/dto/cell_position.dart';

abstract class SelectionCorners {
  CellPosition get leftTop;

  CellPosition get leftBottom;

  CellPosition get rightTop;

  CellPosition get rightBottom;
}