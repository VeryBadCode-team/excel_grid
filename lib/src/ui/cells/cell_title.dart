import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/title_cell_theme/title_cell_theme.dart';
import 'package:excel_grid/src/manager/decoration_manager/decoration_manager.dart';
import 'package:excel_grid/src/manager/scroll_manager/scroll_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_column_event.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_row_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/column_selected_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/multi_selected_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/row_selected_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selected_all_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/single_selected_state.dart';
import 'package:excel_grid/src/models/dto/grid_position.dart';
import 'package:flutter/material.dart';

enum GridDirection {
  vertical,
  horizontal,
}

class TitleConfig {
  final GridPosition position;
  final GridDirection direction;

  TitleConfig({
    required this.position,
    required this.direction,
  });
}

class CellTitle extends StatefulWidget {
  final double width;
  final double height;
  final BorderSide borderSide;
  final Color backgroundColor;
  final ScrollManager scrollManager;
  final TitleConfig titleConfig;

  const CellTitle({
    required this.width,
    required this.height,
    required this.borderSide,
    required this.backgroundColor,
    required this.titleConfig,
    required this.scrollManager,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CellTitle();
}

class _CellTitle extends State<CellTitle> {
  final SelectionManager selectionManager = globalLocator<SelectionManager>();
  final DecorationManager decorationManager = globalLocator<DecorationManager>();

  @override
  void initState() {
    selectionManager.addListener(_rebuildWidget);
    super.initState();
  }

  @override
  void dispose() {
    selectionManager.removeListener(_rebuildWidget);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    TitleCellTheme titleCellTheme = decorationManager.theme.titleCellTheme;
    return MouseRegion(
      onEnter: (_) {
        bool rowSelectionInProgress = selectionManager.state is RowSelectionOngoingState;
        bool columnSelectionInProgress = selectionManager.state is ColumnSelectionOngoingState;
        if (rowSelectionInProgress) {
          selectionManager.handleEvent(ContinueSelectingMultipleRowsEvent(widget.titleConfig.position));
        } else if (columnSelectionInProgress) {
          selectionManager.handleEvent(ContinueSelectingMultipleColumnsEvent(widget.titleConfig.position));
        }
      },
      child: GestureDetector(
        onTap: () {
          if (widget.titleConfig.direction == GridDirection.horizontal) {
            selectionManager.handleEvent(SelectRowEvent(widget.titleConfig.position));
          } else {
            selectionManager.handleEvent(SelectColumnEvent(widget.titleConfig.position));
          }
        },
        onPanStart: (_) {
          if (widget.titleConfig.direction == GridDirection.horizontal) {
            selectionManager.handleEvent(StartSelectingMultipleRowsEvent(selectFromRow: widget.titleConfig.position));
          } else if (widget.titleConfig.direction == GridDirection.vertical) {
            selectionManager.handleEvent(StartSelectingMultipleColumnsEvent(selectFromColumn: widget.titleConfig.position));
          }
        },
        onPanEnd: (_) {
          if (widget.titleConfig.direction == GridDirection.horizontal) {
            selectionManager.handleEvent(FinishSelectingMultipleRowsEvent());
          } else {
            selectionManager.handleEvent(FinishSelectingMultipleColumnsEvent());
          }
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            border: Border.fromBorderSide(widget.borderSide),
          ),
          child: Center(
            child: Text(widget.titleConfig.position.key,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleCellTheme.textStyle.fontSize,
                  color: (isRowSelected || isColumnSelected) ? Colors.white : titleCellTheme.textStyle.color,
                )),
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

  Color _getBackgroundColor() {
    if (isRowSelected || isColumnSelected) {
      return const Color(0xFF5F6368);
    }
    if (isSelected) {
      return const Color(0xFFE8EAED);
    }
    return widget.backgroundColor;
  }

  bool get isRowSelected {
    SelectionState state = selectionManager.state;
    if (state is SelectedAllState) {
      return true;
    }
    bool isSameHorizontal = state is RowSelectedState && widget.titleConfig.direction == GridDirection.horizontal;
    if (isSameHorizontal) {
      return state.isTitleCellSelected(widget.titleConfig.position, GridDirection.horizontal);
    }
    return false;
  }

  bool get isColumnSelected {
    SelectionState state = selectionManager.state;
    if (state is SelectedAllState) {
      return true;
    }
    bool isSameVertical = state is ColumnSelectedState && widget.titleConfig.direction == GridDirection.vertical;
    if (isSameVertical) {
      return state.isTitleCellSelected(widget.titleConfig.position, GridDirection.vertical);
    }
    return false;
  }

  bool get isSelected {
    SelectionState state = selectionManager.state;
    if (state is SingleCellSelectedState) {
      if (widget.titleConfig.direction == GridDirection.horizontal) {
        return state.cellPosition.columnPosition == widget.titleConfig.position;
      }
      return state.cellPosition.rowPosition == widget.titleConfig.position;
    } else if (state is MultipleCellsSelectedState) {
      return state.isTitleCellSelected(widget.titleConfig.position, widget.titleConfig.direction);
    }
    return false;
  }
}
