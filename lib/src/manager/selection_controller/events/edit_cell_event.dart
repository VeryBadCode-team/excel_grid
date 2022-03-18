import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_single_cell_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/editing_cell_state.dart';

class EditCellEvent extends SelectSingleCellEvent {
  EditCellEvent(CellPosition cellPosition) : super(cellPosition);

  @override
  void invoke(SelectionManager selectionManager) {
    selectionManager.setState(EditingCellState(cellPosition));
  }
}

class KeyPressedEvent extends EditCellEvent {
  final String pressedKeyCharacter;

  KeyPressedEvent({
    required CellPosition cellPosition,
    required this.pressedKeyCharacter,
  }) : super(cellPosition);

  @override
  void invoke(SelectionManager selectionManager) {
    selectionManager.setState(EditingCellAfterKeyPressedState(
      cellPosition: cellPosition,
      keyCharacterValue: pressedKeyCharacter,
    ));
  }
}
