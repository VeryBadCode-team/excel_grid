import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/excel_keyboard_listener.dart';
import 'package:excel_grid/src/manager/autofill_manager/autofill_manager.dart';
import 'package:excel_grid/src/manager/autofill_manager/events/autofill_selection_event.dart';
import 'package:excel_grid/src/manager/autofill_manager/states/autofill_selection_state.dart';
import 'package:excel_grid/src/manager/autofill_manager/states/autofill_state.dart';
import 'package:excel_grid/src/manager/decoration_manager/decoration_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/events/edit_cell_event.dart';
import 'package:excel_grid/src/manager/selection_controller/events/extend_selection_event.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_column_event.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_multiple_cells_event.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_row_event.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_single_cell_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/column_selected_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/editing_cell_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/multi_selected_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/row_selected_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_end_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/single_selected_state.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/ui/cells/cell_container.dart';
import 'package:excel_grid/src/ui/cells/types/excel_text_cell.dart';
import 'package:excel_grid/src/shared/enums/append_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ExcelCell extends StatefulWidget {
  final CellPosition cellPosition;

  const ExcelCell({
    required this.cellPosition,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExcelCell();
}

class _ExcelCell extends State<ExcelCell> {
  final DecorationManager decorationManager = globalLocator<DecorationManager>();
  final SelectionManager selectionManager = globalLocator<SelectionManager>();
  final StorageManager storageManager = globalLocator<StorageManager>();
  final AutofillManager autofillManager = globalLocator<AutofillManager>();

  @override
  void initState() {
    selectionManager.addListener(_rebuildWidget);
    storageManager.addListener(_rebuildWidget);
    autofillManager.addListener(_rebuildWidget);
    super.initState();
  }

  @override
  void dispose() {
    selectionManager.removeListener(_rebuildWidget);
    storageManager.removeListener(_rebuildWidget);
    autofillManager.removeListener(_rebuildWidget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        bool autofillInProgress = autofillManager.state is AutofillSelectionOngoingState;
        if (autofillInProgress) {
          autofillManager.handleEvent(ContinueAutofillSelection(widget.cellPosition));
        }
        bool rowSelectionInProgress = selectionManager.state is RowSelectionOngoingState;
        bool columnSelectionInProgress = selectionManager.state is ColumnSelectionOngoingState;
        if (rowSelectionInProgress) {
          selectionManager.handleEvent(ContinueSelectingMultipleRowsEvent(widget.cellPosition.columnPosition));
        } else if (columnSelectionInProgress) {
          selectionManager.handleEvent(ContinueSelectingMultipleColumnsEvent(widget.cellPosition.rowPosition));
        }

        bool selectionInProgress = selectionManager.state is MultipleCellsSelectionOngoingState;

        if (selectionInProgress) {
          selectionManager.handleEvent(ContinueSelectingMultipleCellsEvent(widget.cellPosition));
        }
      },
      child: GestureDetector(
        onTap: () {
          if (ExcelKeyboardListener.of(context).keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
            selectionManager.handleEvent(ExtendSelectionEvent(extendSelectionToPosition: widget.cellPosition));
          } else {
            selectionManager.handleEvent(SelectSingleCellEvent(widget.cellPosition));
          }
        },
        onDoubleTap: () {
          SelectionState state = selectionManager.state;
          if (state is! EditingCellState) {
            selectionManager.handleEvent(EditCellEvent(widget.cellPosition));
          }
        },
        onPanStart: (_) {
          selectionManager.handleEvent(StartSelectingMultipleCellsEvent(selectFromPosition: widget.cellPosition));
        },
        onPanEnd: (_) {
          selectionManager.handleEvent(FinishSelectingMultipleCellsEvent());
        },
        child: CellContainer(
          height: decorationManager.getRowHeight(widget.cellPosition.columnPosition.index),
          width: decorationManager.getColumnWidth(widget.cellPosition.rowPosition.index),
          theme: decorationManager.theme,
          isEditing: isEditing,
          isSelectedCell: isSelected,
          multiSelectionBorder: multiSelectionBorder,
          autofillBorder: autofillBorder,
          readOnly: false,
          hasFocus: false,
          canAutofill: canAutofill,
          isStartSelectionCell: isStartSelectionCell,
          isEndSelectionCell: false,
          cellPosition: widget.cellPosition,
          child: ExcelTextCell(
            cellPosition: widget.cellPosition,
            value: storageManager.getCellData(widget.cellPosition),
            editing: isEditing,
            cellPadding: decorationManager.theme.cellTheme.cellPadding,
          ),
        ),
      ),
    );
  }

  void _rebuildWidget() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get canAutofill {
    SelectionState state = selectionManager.state;
    return widget.cellPosition == state.corners.rightBottom && state is SelectionFinishedState;
  }

  bool get isEditing {
    SelectionState state = selectionManager.state;
    if (state is EditingCellState) {
      bool isEditingCell = state.cellPosition == widget.cellPosition;
      return isEditingCell;
    }
    return false;
  }

  bool get isSelected {
    SelectionState state = selectionManager.state;
    if (state is SingleCellSelectedState) {
      bool isSelectedCell = state.cellPosition == widget.cellPosition;
      return isSelectedCell;
    }
    if (state is MultipleCellsSelectedState) {
      bool isSelectedCell = state.isCellSelected(widget.cellPosition);
      return isSelectedCell;
    }
    return false;
  }

  bool get isStartSelectionCell {
    SelectionState state = selectionManager.state;
    return widget.cellPosition == state.focusedCell;
  }

  bool get isEndSelectionCell {
    SelectionState state = selectionManager.state;
    return widget.cellPosition == state.endSelectionCell;
  }

  Set<AppendBorder> get autofillBorder {
    Set<AppendBorder> appendBorder = <AppendBorder>{};
    AutofillState state = autofillManager.state;
    if (state is AutofillSelectionOngoingState) {
      if (!state.selectedCells.merged.contains(widget.cellPosition)) {
        return appendBorder;
      }
      appendBorder.addAll(state.isVerticalSelectionExtreme(widget.cellPosition));
      appendBorder.addAll(state.isHorizontalSelectionExtreme(widget.cellPosition));
    }
    return appendBorder;
  }

  Set<AppendBorder> get multiSelectionBorder {
    Set<AppendBorder> appendBorder = <AppendBorder>{};
    SelectionState state = selectionManager.state;
    if (state is MultipleCellsSelectionFinishedState) {
      appendBorder.addAll(state.isVerticalSelectionExtreme(widget.cellPosition));
      appendBorder.addAll(state.isHorizontalSelectionExtreme(widget.cellPosition));
    }
    return appendBorder;
  }
}
