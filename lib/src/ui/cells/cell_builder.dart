import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/dto/grid_position.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/grid_config.dart';
import 'package:excel_grid/src/ui/cells/cell_end.dart';
import 'package:excel_grid/src/ui/cells/cell_narrow.dart';
import 'package:excel_grid/src/ui/cells/cell_title.dart';
import 'package:excel_grid/src/ui/cells/excel_cell.dart';
import 'package:excel_grid/src/utils/cell_title_generator/cell_title_generator.dart';
import 'package:flutter/cupertino.dart';

class CellBuilder extends StatefulWidget {
  final ExcelScrollController scrollController;
  final int maxRows;
  final int maxColumns;

  final int columnIndex;
  final int rowIndex;

  const CellBuilder({
    required this.scrollController,
    required this.maxRows,
    required this.maxColumns,
    required this.columnIndex,
    required this.rowIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CellBuilder();
}

class _CellBuilder extends State<CellBuilder> {
  final GridConfig gridConfig = globalLocator<GridConfig>();

  @override
  void initState() {
    widget.scrollController.addListener(() {
      if(mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (columnGridPosition.index > widget.maxColumns || rowGridPosition.index > widget.maxRows) {
      double height = InheritedExcelTheme.of(context).theme.cellTheme.height;
      double width = InheritedExcelTheme.of(context).theme.cellTheme.width;

      if (rowGridPosition.index == 0) {
        height = InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.height;
      }

      if (columnGridPosition.index == 0) {
        width = InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.width;
      }

      return CellEnd(
        height: height,
        width: width,
        backgroundColor: const Color(0xFFF3F3F3),
      );
    }

    if (isFirstRow && isFirstColumn) {
      return _buildCellNarrow();
    }
    if (isFirstRow) {
      return _buildVerticalTitleCell(columnGridPosition);
    }
    if (isFirstColumn) {
      return _buildHorizontalTitleCell(rowGridPosition);
    }

    return _buildContentCell(
      verticalGridPosition: rowGridPosition,
      horizontalGridPosition: columnGridPosition,
    );
  }

  bool get isFirstColumn => widget.columnIndex == 0;

  bool get isFirstRow => widget.rowIndex == 0;

  int get verticalScrollOffsetValue => widget.scrollController.offset.dy.round();

  int get calculatedRowIndex => widget.rowIndex + verticalScrollOffsetValue;

  String get rowName => gridConfig.verticalCellTitleGenerator.getTitle(calculatedRowIndex);

  int get horizontalScrollOffsetValue => widget.scrollController.offset.dx.round();

  int get calculatedColumnIndex => widget.columnIndex + horizontalScrollOffsetValue;

  String get columnName => gridConfig.horizontalCellTitleGenerator.getTitle(calculatedColumnIndex);

  GridPosition get rowGridPosition => GridPosition(
        index: calculatedRowIndex,
        key: rowName,
      );

  GridPosition get columnGridPosition => GridPosition(
        index: calculatedColumnIndex,
        key: columnName,
      );

  Widget _buildCellNarrow() {
    return const CellNarrow();
  }

  Widget _buildVerticalTitleCell(GridPosition verticalGridPosition) {
    return CellTitle(
      titleConfig: TitleConfig(
        position: verticalGridPosition,
        direction: GridDirection.vertical,
      ),
      scrollController: widget.scrollController,
      width: InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.width,
      height: InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.width,
      borderSide: InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.borderSide,
      backgroundColor: InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.backgroundColor,
    );
  }

  Widget _buildHorizontalTitleCell(GridPosition horizontalGridPosition) {
    return CellTitle(
      titleConfig: TitleConfig(
        position: horizontalGridPosition,
        direction: GridDirection.horizontal,
      ),
      scrollController: widget.scrollController,
      width: InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.width,
      height: InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.width,
      borderSide: InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.borderSide,
      backgroundColor: InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.backgroundColor,
    );
  }

  Widget _buildContentCell({required GridPosition horizontalGridPosition, required GridPosition verticalGridPosition}) {
    return ExcelCell(
      cellPosition: CellPosition(
        verticalPosition: verticalGridPosition,
        horizontalPosition: horizontalGridPosition,
      ),
    );
  }
}
