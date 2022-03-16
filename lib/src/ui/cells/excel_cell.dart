import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/excel_keyboard_listener.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/autofill_manager/autofill_manager.dart';
import 'package:excel_grid/src/model/autofill_manager/autofill_manager_events.dart';
import 'package:excel_grid/src/model/autofill_manager/autofill_manager_states.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_events.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/ui/cells/cell_container.dart';
import 'package:excel_grid/src/ui/cells/types/excel_text_cell.dart';
import 'package:excel_grid/src/utils/enums/append_border.dart';
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
  final SelectionController selectionController = globalLocator<SelectionController>();
  final StorageManager storageManager = globalLocator<StorageManager>();
  final AutofillManager autofillManager = globalLocator<AutofillManager>();

  @override
  void initState() {
    selectionController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    storageManager.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    autofillManager.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ExcelGridTheme theme = InheritedExcelTheme.of(context).theme;
    return MouseRegion(
      onEnter: (_) {
        bool autofillInProgress = autofillManager.state is AutofillOngoingState;
        if (autofillInProgress) {
          autofillManager.handleEvent(AutofillOngoing(widget.cellPosition));
        }

        bool rowSelectionInProgress = selectionController.state is RowSelectOngoingState;
        bool columnSelectionInProgress = selectionController.state is ColumnSelectOngoingState;
        if (rowSelectionInProgress) {
          selectionController.handleEvent(SelectMulitRowUpdateEvent(widget.cellPosition.verticalPosition));
        } else if (columnSelectionInProgress) {
          selectionController.handleEvent(SelectMulitColumnUpdateEvent(widget.cellPosition.horizontalPosition));
        }

        bool selectionInProgress = selectionController.state is MultiSelectedOngoingState;
        if (selectionInProgress) {
          selectionController.handleEvent(MultiCellSelectUpdateEvent(widget.cellPosition));
        }
      },
      child: GestureDetector(
        onTap: () {
          print('IS SHIFT PRESSED = ${ExcelKeyboardListener.of(context).keysPressed}');
          print('IS SHIFT PRESSED = ${ExcelKeyboardListener.of(context).keysPressed.contains(LogicalKeyboardKey.shiftLeft)}');
          if( ExcelKeyboardListener.of(context).keysPressed.contains(LogicalKeyboardKey.shiftLeft)) {
            selectionController.handleEvent(ExtendSelection(to: widget.cellPosition));
          } else {
            selectionController.handleEvent(SingleCellSelectEvent(widget.cellPosition));
          }
        },
        onDoubleTap: () {
          SelectionState state = selectionController.state;
          if (state is! CellEditingState) {
            selectionController.handleEvent(CellEditingEvent(widget.cellPosition));
          }
        },
        onPanStart: (_) {
          selectionController.handleEvent(MultiCellSelectStartEvent(fromPosition: widget.cellPosition));
        },
        onPanEnd: (_) {
          selectionController.handleEvent(MultiCellSelectEndEvent());
        },
        child: CellContainer(
          height: theme.cellTheme.height,
          width: theme.cellTheme.width,
          theme: theme,
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
            cellPadding: theme.cellTheme.cellPadding,
          ),
        ),
      ),
    );
  }

  bool get canAutofill {
    SelectionState state = selectionController.state;
    return widget.cellPosition == state.rightBottomCell && state is SelectionEndState;
  }

  bool get isEditing {
    SelectionState state = selectionController.state;
    if (state is CellEditingState) {
      bool isEditingCell = state.cellPosition == widget.cellPosition;
      return isEditingCell;
    }
    return false;
  }

  bool get isSelected {
    SelectionState state = selectionController.state;
    if (state is SingleSelectedState) {
      bool isSelectedCell = state.cellPosition == widget.cellPosition;
      return isSelectedCell;
    }
    if (state is MultiSelectedState) {
      bool isSelectedCell = state.isCellSelected(widget.cellPosition);
      return isSelectedCell;
    }
    return false;
  }

  bool get isStartSelectionCell {
    SelectionState state = selectionController.state;
    return widget.cellPosition == state.focusedCell;
  }

  bool get isEndSelectionCell {
    SelectionState state = selectionController.state;
    return widget.cellPosition == state.lastFocusedCell;
  }

  Set<AppendBorder> get autofillBorder {
    Set<AppendBorder> appendBorder = <AppendBorder>{};
    AutofillState state = autofillManager.state;
    if (state is AutofillOngoingState) {
      if(!state.selectedCellsMerged.contains(widget.cellPosition)) {
        return appendBorder;
      }
      appendBorder.addAll(state.isVerticalSelectionExtreme(widget.cellPosition));
      appendBorder.addAll(state.isHorizontalSelectionExtreme(widget.cellPosition));
    }
    return appendBorder;
  }

  Set<AppendBorder> get multiSelectionBorder {
    Set<AppendBorder> appendBorder = <AppendBorder>{};
    SelectionState state = selectionController.state;
    if (state is MultiSelectedEndState) {
      appendBorder.addAll(state.isVerticalSelectionExtreme(widget.cellPosition));
      appendBorder.addAll(state.isHorizontalSelectionExtreme(widget.cellPosition));
    }
    return appendBorder;
  }
}
