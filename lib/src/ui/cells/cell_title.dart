import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/horizontal_title_cell_theme/horizontal_title_cell_theme.dart';
import 'package:excel_grid/src/dto/grid_position.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_events.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';
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
  final ExcelScrollController scrollController;
  final TitleConfig titleConfig;

  const CellTitle({
    required this.width,
    required this.height,
    required this.borderSide,
    required this.backgroundColor,
    required this.titleConfig,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CellTitle();
}

class _CellTitle extends State<CellTitle> {
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
    HorizontalTitleCellTheme horizontalTitleCellTheme = InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme;
    return MouseRegion(
      onEnter: (_) {
        bool rowSelectionInProgress = selectionController.state is RowSelectOngoingState;
        bool columnSelectionInProgress = selectionController.state is ColumnSelectOngoingState;
        if (rowSelectionInProgress) {
          selectionController.handleEvent(SelectMulitRowUpdateEvent(widget.titleConfig.position));
        } else if (columnSelectionInProgress) {
          selectionController.handleEvent(SelectMulitColumnUpdateEvent(widget.titleConfig.position));
        }
      },
      child: GestureDetector(
        onTap: () {
          if (widget.titleConfig.direction == GridDirection.horizontal) {
            selectionController.handleEvent(SelectRowEvent(widget.titleConfig.position));
          } else {
            selectionController.handleEvent(SelectColumnEvent(widget.titleConfig.position));
          }
        },
        onPanStart: (_) {
          if (widget.titleConfig.direction == GridDirection.horizontal) {
            selectionController.handleEvent(SelectMulitRowStartEvent(fromPosition: widget.titleConfig.position));
          } else if (widget.titleConfig.direction == GridDirection.vertical) {
            selectionController.handleEvent(SelectMulitColumnStartEvent(fromPosition: widget.titleConfig.position));
          }
        },
        onPanEnd: (_) {
          if (widget.titleConfig.direction == GridDirection.horizontal) {
            selectionController.handleEvent(SelectMulitRowEndEvent());
          } else {
            selectionController.handleEvent(SelectMulitColumnEndEvent());
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
                  fontSize: horizontalTitleCellTheme.textStyle.fontSize,
                  color: (isRowSelected || isColumnSelected) ? Colors.white : horizontalTitleCellTheme.textStyle.color,
                )),
          ),
        ),
      ),
    );
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
    SelectionState state = selectionController.state;
    if( state is SelectedAllState) {
      return true;
    }
    bool isSameHorizontal = state is RowSelectedState && widget.titleConfig.direction == GridDirection.horizontal;
    if (isSameHorizontal) {
      return state.isTitleCellSelected(widget.titleConfig.position, GridDirection.horizontal);
    }
    return false;
  }

  bool get isColumnSelected {
    SelectionState state = selectionController.state;
    if( state is SelectedAllState) {
      return true;
    }
    bool isSameVertical = state is ColumnSelectedState  && widget.titleConfig.direction == GridDirection.vertical;
    if (isSameVertical) {
      return state.isTitleCellSelected(widget.titleConfig.position, GridDirection.vertical);
    }
    return false;
  }

  bool get isSelected {
    SelectionState state = selectionController.state;
    if (state is SingleSelectedState) {
      if (widget.titleConfig.direction == GridDirection.horizontal) {
        return state.cellPosition.verticalPosition == widget.titleConfig.position;
      }
      return state.cellPosition.horizontalPosition == widget.titleConfig.position;
    } else if (state is MultiSelectedState) {
      return state.isTitleCellSelected(widget.titleConfig.position, widget.titleConfig.direction);
    }
    return false;
  }
}
