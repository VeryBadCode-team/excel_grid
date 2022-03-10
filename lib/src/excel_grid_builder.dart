import 'package:excel_grid/src/dto/grid_position.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/excel_scroll_controller.dart';
import 'package:excel_grid/src/ui/cells/cell_builder.dart';
import 'package:excel_grid/src/ui/cells/cell_end.dart';
import 'package:excel_grid/src/ui/cells/cell_narrow.dart';
import 'package:excel_grid/src/ui/cells/cell_title.dart';
import 'package:excel_grid/src/ui/layout/grid_layout.dart';
import 'package:excel_grid/src/utils/cell_title_generator/cell_title_generator.dart';
import 'package:excel_grid/src/widgets/scroll_detector.dart';
import 'package:flutter/cupertino.dart';

class ExcelGridBuilder extends StatefulWidget {
  final int maxRows;
  final int maxColumns;
  final int visibleHorizontalCellCount;
  final int visibleVerticalCellCount;
  final CellTitleGenerator horizontalCellTitleGenerator;
  final CellTitleGenerator verticalCellTitleGenerator;

  const ExcelGridBuilder({
    required this.visibleHorizontalCellCount,
    required this.visibleVerticalCellCount,
    required this.maxRows,
    required this.maxColumns,
    required this.horizontalCellTitleGenerator,
    required this.verticalCellTitleGenerator,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExcelGridBuilder();
}

class _ExcelGridBuilder extends State<ExcelGridBuilder> {
  late final ExcelScrollController scrollController;

  @override
  void initState() {
    scrollController = ExcelScrollController(
      maxRows: widget.maxRows,
      maxColumns: widget.maxColumns,
      visibleRows: widget.visibleVerticalCellCount - 5,
      visibleColumns: widget.visibleHorizontalCellCount - 4,
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.contentWidth = _calcContentWidth();
    scrollController.contentHeight = _calcContentHeight();

    return ScrollDetector(
      scrollController: scrollController,
      child: GridLayout(
        verticalCellCount: widget.visibleVerticalCellCount,
        horizontalCellCount: widget.visibleHorizontalCellCount,
        scrollController: scrollController,
        child: _buildExcelGrid(),
      ),
    );
  }

  double _calcContentWidth() {
    int marginCellsCount = 4;
    double cellsWidth = InheritedExcelTheme.of(context).theme.cellTheme.width * (widget.maxColumns + marginCellsCount);
    double contentWidth = cellsWidth;
    return contentWidth;
  }

  double _calcContentHeight() {
    int marginCellsCount = 5;
    double cellsHeight = InheritedExcelTheme.of(context).theme.cellTheme.height * (widget.maxRows + marginCellsCount);
    double contentHeight = cellsHeight;
    return contentHeight;
  }

  Widget _buildExcelGrid() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: widget.visibleVerticalCellCount + 5,
      itemBuilder: (_, int rowIndex) => _buildGridRow(rowIndex),
    );
  }

  Widget _buildGridRow(int rowIndex) {
    int verticalScrollOffsetValue = scrollController.offset.dy.round();
    int calculatedRowIndex = rowIndex + verticalScrollOffsetValue;
    String rowName = widget.verticalCellTitleGenerator.getTitle(calculatedRowIndex);
    GridPosition rowGridPosition = GridPosition(
      index: calculatedRowIndex,
      key: rowName,
    );

    return SizedBox(
      height: rowIndex == 0
          ? InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.height
          : InheritedExcelTheme.of(context).theme.cellTheme.height,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget.visibleHorizontalCellCount + 3,
        itemBuilder: (_, int columnIndex) => _buildCell(
          rowGridPosition: rowGridPosition,
          rowIndex: rowIndex,
          columnIndex: columnIndex,
        ),
      ),
    );
  }

  Widget _buildCell({required GridPosition rowGridPosition, required int rowIndex, required int columnIndex}) {
    bool firstColumn = columnIndex == 0;
    bool firstRow = rowIndex == 0;

    int horizontalScrollOffsetValue = scrollController.offset.dx.round();
    int calculatedColumnIndex = columnIndex + horizontalScrollOffsetValue;
    String columnName = widget.horizontalCellTitleGenerator.getTitle(calculatedColumnIndex);
    GridPosition columnGridPosition = GridPosition(
      index: calculatedColumnIndex,
      key: columnName,
    );

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

    if (firstRow && firstColumn) {
      return _buildCellNarrow();
    }
    if (firstRow) {
      return _buildVerticalTitleCell(columnGridPosition);
    }
    if (firstColumn) {
      return _buildHorizontalTitleCell(rowGridPosition);
    }

    return _buildContentCell(
      verticalGridPosition: rowGridPosition,
      horizontalGridPosition: columnGridPosition,
    );
  }

  Widget _buildCellNarrow() {
    return const CellNarrow();
  }

  Widget _buildVerticalTitleCell(GridPosition verticalGridPosition) {
    return CellTitle(
      titleConfig: TitleConfig(
        position: verticalGridPosition,
        direction: GridDirection.vertical,
      ),
      scrollController: scrollController,
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
      scrollController: scrollController,
      width: InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.width,
      height: InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.width,
      borderSide: InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.borderSide,
      backgroundColor: InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.backgroundColor,
    );
  }

  Widget _buildContentCell({required GridPosition horizontalGridPosition, required GridPosition verticalGridPosition}) {
    return const CellBuilder();
  }
}
