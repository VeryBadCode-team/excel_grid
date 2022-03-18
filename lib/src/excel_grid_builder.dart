import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/column_title_cell_theme/column_title_cell_theme.dart';
import 'package:excel_grid/src/core/theme/row_title_cell_theme/row_title_cell_theme.dart';
import 'package:excel_grid/src/core/theme/title_cell_theme/title_cell_theme.dart';
import 'package:excel_grid/src/layout_cell_builder.dart';
import 'package:excel_grid/src/manager/decoration_manager/decoration_manager.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/scroll_manager/scroll_manager.dart';
import 'package:excel_grid/src/ui/cells/cell_end.dart';
import 'package:excel_grid/src/ui/cells/cell_narrow.dart';
import 'package:excel_grid/src/ui/cells/cell_title.dart';
import 'package:excel_grid/src/ui/cells/excel_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExcelGridBuilder extends StatefulWidget {
  final ScrollManager scrollManager;
  final Size excelSize;

  const ExcelGridBuilder({
    required this.scrollManager,
    required this.excelSize,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExcelGridBuilder();
}

class _ExcelGridBuilder extends State<ExcelGridBuilder> {
  final DecorationManager decorationManager = globalLocator<DecorationManager>();
  final GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();

  @override
  void initState() {
    widget.scrollManager.addListener(_rebuildWidget);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollManager.removeListener(_rebuildWidget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: LayoutCellBuilder(
        maxColumnsCount: gridConfigManager.columnsCount,
        maxRowsCount: gridConfigManager.rowsCount,
        rowsScrollOffset: widget.scrollManager.offset.dy.toInt(),
        columnsScrollOffset: widget.scrollManager.offset.dx.toInt(),
        verticalCellTitleGenerator: gridConfigManager.verticalCellTitleGenerator,
        horizontalCellTitleGenerator: gridConfigManager.horizontalCellTitleGenerator,
        calculateRowHeight: decorationManager.getRowHeight,
        calculateColumnWidth: decorationManager.getColumnWidth,
        narrowCellBuilder: _buildCellNarrow,
        cellBuilder: _buildCell,
        overlapCellBuilder: _buildOverlapCell,
        columnTitleCellBuilder: _buildColumnsTitleCell,
        rowTitleCellBuilder: _buildRowTitleCell,
        onGridSizeCalculated: (int rowsCount, int columnsCount) {
          widget.scrollManager.visibleColumnsCount = columnsCount;
          widget.scrollManager.visibleRowsCount = rowsCount;
        },
      ).build(widget.excelSize),
    );
  }

  void _rebuildWidget() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildCellNarrow() {
    return const CellNarrow();
  }

  Widget _buildCell(CellBuildData cellBuildData) {
    return ExcelCell(
      cellPosition: cellBuildData.cellPosition,
    );
  }

  Widget _buildColumnsTitleCell(TitleCellBuildData titleCellBuildData) {
    TitleCellTheme titleCellTheme = decorationManager.theme.titleCellTheme;
    ColumnTitleCellTheme columnTitleCellTheme = decorationManager.theme.columnTitleCellTheme;

    return CellTitle(
      titleConfig: TitleConfig(
        position: titleCellBuildData.gridPosition,
        direction: GridDirection.vertical,
      ),
      scrollManager: widget.scrollManager,
      width: decorationManager.getColumnWidth(titleCellBuildData.gridPosition.index),
      height: columnTitleCellTheme.height,
      borderSide: titleCellTheme.borderSide,
      backgroundColor: titleCellTheme.backgroundColor,
    );
  }

  Widget _buildRowTitleCell(TitleCellBuildData titleCellBuildData) {
    TitleCellTheme titleCellTheme = decorationManager.theme.titleCellTheme;
    RowTitleCellTheme rowTitleCellTheme = decorationManager.theme.rowTitleCellTheme;

    return CellTitle(
      titleConfig: TitleConfig(
        position: titleCellBuildData.gridPosition,
        direction: GridDirection.horizontal,
      ),
      scrollManager: widget.scrollManager,
      width: rowTitleCellTheme.width,
      height: decorationManager.getRowHeight(titleCellBuildData.gridPosition.index),
      borderSide: titleCellTheme.borderSide,
      backgroundColor: titleCellTheme.backgroundColor,
    );
  }

  Widget _buildOverlapCell(CellBuildData cellBuildData) {
    return CellEnd(
      width: decorationManager.getColumnWidth(cellBuildData.cellPosition.rowPosition.index),
      height: decorationManager.getRowHeight(cellBuildData.cellPosition.columnPosition.index),
      backgroundColor: const Color(0xFFF3F3F3),
    );
  }
}
