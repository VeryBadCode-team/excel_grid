import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_events.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';
import 'package:excel_grid/src/ui/cells/cell_container.dart';
import 'package:excel_grid/src/ui/cells/types/excel_text_cell.dart';
import 'package:excel_grid/src/utils/enums/append_border.dart';
import 'package:flutter/cupertino.dart';

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

  @override
  void initState() {
    selectionController.addListener(() {
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
          selectionController.handleEvent(SingleCellSelectEvent(widget.cellPosition));
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
          cellPadding: theme.cellTheme.cellPadding,
          theme: theme,
          isEditing: false,
          isSelectedCell: isSelected,
          multiSelectionBorder: multiSelectionBorder,
          readOnly: false,
          hasFocus: false,
          isStartSelectionCell: isStartSelectionCell,
          isEndSelectionCell: false,
          child: const ExcelTextCell(),
        ),
      ),
    );
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
    if (state is SingleSelectedState) {
      return state.cellPosition == widget.cellPosition;
    }
    if (state is MultiSelectedState) {
      return state.from == widget.cellPosition;
    }
    return false;
  }

  bool get isEndSelectionCell {
    SelectionState state = selectionController.state;
    if (state is MultiSelectedState) {
      return state.to == widget.cellPosition;
    }
    return false;
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
