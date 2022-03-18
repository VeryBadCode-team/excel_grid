import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/autofill_manager/states/autofill_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/multi_selected_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';

abstract class AutofillSelectionState extends MultipleCellsSelectedState with AutofillState {
  AutofillSelectionState({required CellPosition selectedFromPosition, required CellPosition selectedToPosition})
      : super(selectedFromPosition: selectedFromPosition, selectedToPosition: selectedToPosition);
}

class AutofillSelectionOngoingState extends AutofillSelectionState {
  final SelectionState selectionState;
  final bool verticallySelection;

  AutofillSelectionOngoingState({
    required CellPosition autofillFrom,
    required CellPosition autofillTo,
    required this.selectionState,
    required this.verticallySelection,
  }) : super(selectedFromPosition: autofillFrom, selectedToPosition: autofillTo);

  @override
  AutofillSelectionOngoingState copyWith({
    CellPosition? selectedFromPosition,
    CellPosition? selectedToPosition,
    SelectionState? selectionState,
    bool? verticallySelection,
  }) {
    return AutofillSelectionOngoingState(
      autofillFrom: selectedFromPosition ?? this.selectedFromPosition,
      autofillTo: selectedToPosition ?? this.selectedToPosition,
      selectionState: selectionState ?? this.selectionState,
      verticallySelection: verticallySelection ?? this.verticallySelection,
    );
  }
}
