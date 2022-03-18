import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/states/single_selected_state.dart';

class EditingCellState extends SingleCellSelectedState {
  EditingCellState(CellPosition cellPosition) : super(cellPosition);
}

class EditingCellAfterKeyPressedState extends EditingCellState {
  final String keyCharacterValue;

  EditingCellAfterKeyPressedState({
    required CellPosition cellPosition,
    required this.keyCharacterValue,
  })  : assert(keyCharacterValue.length == 1, 'Provided key should be character'),
        super(cellPosition);
}
