import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';

class AutofillState {}

class AutofillDismissed extends AutofillState {}

abstract class AutofillSelection extends MultiSelectedState with AutofillState {
  AutofillSelection({required CellPosition from, required CellPosition to}) : super(from: from, to: to);
}

class AutofillOngoingState extends AutofillSelection {
  final SelectionState selectionState;
  final bool verticallySelection;

  AutofillOngoingState({
    required CellPosition from,
    required CellPosition to,
    required this.selectionState,
    required this.verticallySelection,
  }) : super(from: from, to: to);

  AutofillOngoingState copyWith({
    CellPosition? from,
    CellPosition? to,
    SelectionState? selectionState,
    bool? verticallySelection,
  }) {
    return AutofillOngoingState(
      from: from ?? this.from,
      to: to ?? this.to,
      selectionState: selectionState ?? this.selectionState,
      verticallySelection: verticallySelection ?? this.verticallySelection,
    );
  }
}
