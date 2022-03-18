import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_data/selection_data.dart';

class SingleSelectionData extends SelectionData {
  final CellPosition cellPosition;

  SingleSelectionData(this.cellPosition);

  @override
  List<List<CellPosition>> get byRows => <List<CellPosition>>[
    <CellPosition>[cellPosition]
  ];

  @override
  List<List<CellPosition>> get byColumns => <List<CellPosition>>[
    <CellPosition>[cellPosition]
  ];

  @override
  List<CellPosition> get merged => <CellPosition>[cellPosition];
}