import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/models/dto/grid_position.dart';
import 'package:excel_grid/src/shared/cell_title_generator/cell_title_generator.dart';
import 'package:flutter/material.dart';

class CellBuildData {
  final CellPosition cellPosition;

  CellBuildData({
    required this.cellPosition,
  });
}

class TitleCellBuildData {
  final GridPosition gridPosition;

  TitleCellBuildData({
    required this.gridPosition,
  });
}

class LayoutCellBuilder {
  final int columnsScrollOffset;
  final int rowsScrollOffset;
  final int maxRowsCount;
  final int maxColumnsCount;
  final double Function(int rowIndex) calculateRowHeight;
  final double Function(int columnIndex) calculateColumnWidth;
  final void Function(int rowsCount, int columnsCount) onGridSizeCalculated;
  final CellTitleGenerator verticalCellTitleGenerator;
  final CellTitleGenerator horizontalCellTitleGenerator;
  final Widget Function(CellBuildData cellBuildData) cellBuilder;
  final Widget Function() narrowCellBuilder;
  final Widget Function(CellBuildData cellBuildData) overlapCellBuilder;
  final Widget Function(TitleCellBuildData titleCellBuildData) columnTitleCellBuilder;
  final Widget Function(TitleCellBuildData titleCellBuildData) rowTitleCellBuilder;

  LayoutCellBuilder({
    required this.maxRowsCount,
    required this.maxColumnsCount,
    required this.columnsScrollOffset,
    required this.rowsScrollOffset,
    required this.calculateRowHeight,
    required this.calculateColumnWidth,
    required this.onGridSizeCalculated,
    required this.verticalCellTitleGenerator,
    required this.horizontalCellTitleGenerator,
    required this.cellBuilder,
    required this.overlapCellBuilder,
    required this.narrowCellBuilder,
    required this.columnTitleCellBuilder,
    required this.rowTitleCellBuilder,
  });

  final Map<int, double> columnsSizes = <int, double>{};
  final Map<int, double> rowsSizes = <int, double>{};


  List<Positioned> build(Size size) {
    final List<Positioned> cells = List<Positioned>.empty(growable: true);

    int rowsCount = _getVisibleRowsCount(size.height);
    int columnsCount = _getVisibleColumnsCount(size.width);

    onGridSizeCalculated(rowsCount, columnsCount);

    double currentWidthOffset = 0;
    double currentHeightOffset = 0;

    for (int y = 0; y < rowsCount; y++) {
      currentWidthOffset = 0;
      for (int x = 0; x < columnsCount; x++) {
        int calculatedVerticalIndex = rowsScrollOffset + y;
        int calculatedHorizontalIndex = columnsScrollOffset + x;

        String verticalCellName = verticalCellTitleGenerator.getTitle(calculatedVerticalIndex);
        String horizontalCellName = horizontalCellTitleGenerator.getTitle(calculatedHorizontalIndex);

        CellPosition cellPosition = CellPosition(
          columnPosition: GridPosition(index: calculatedVerticalIndex, key: verticalCellName),
          rowPosition: GridPosition(index: calculatedHorizontalIndex, key: horizontalCellName),
        );

        Widget widget = _buildCell(
          y: y,
          x: x,
          cellPosition: cellPosition,
        );

        cells.add(
          Positioned(
            // key: Key('$x-$y'),
            top: currentHeightOffset,
            left: currentWidthOffset,
            child: widget,
          ),
        );
        currentWidthOffset += columnsSizes[x]!;
      }
      currentHeightOffset += rowsSizes[y]!;
    }
    return cells;
  }

  int _getVisibleColumnsCount(double horizontalViewport) {
    double _horizontalViewport = horizontalViewport;
    int columnIndex = columnsScrollOffset;
    int columnCount = 0;
    while (_horizontalViewport > 0) {
      double columnWidth = calculateColumnWidth(columnCount == 0 ? 0 : columnIndex);
      columnsSizes[columnCount] = columnWidth;
      _horizontalViewport -= columnWidth;
      columnCount += 1;
      columnIndex += 1;
    }
    return columnCount;
  }

  int _getVisibleRowsCount(double verticalViewport) {
    double _verticalViewport = verticalViewport;
    int rowIndex = rowsScrollOffset;
    int rowCount = 0;
    while (_verticalViewport > 0) {
      double rowHeight = calculateRowHeight(rowCount == 0 ? 0 : rowIndex);
      rowsSizes[rowCount] = rowHeight;
      _verticalViewport -= rowHeight;
      rowCount += 1;
      rowIndex += 1;
    }
    return rowCount;
  }

  Widget _buildCell({
    required int x,
    required int y,
    required CellPosition cellPosition,
  }) {
    if (cellPosition.rowPosition.index > maxColumnsCount || cellPosition.columnPosition.index > maxRowsCount) {
      return overlapCellBuilder(CellBuildData(cellPosition: cellPosition));
    } else if (y == 0 && x == 0) {
      return narrowCellBuilder();
    } else if (x == 0) {
      return rowTitleCellBuilder(TitleCellBuildData(gridPosition: cellPosition.columnPosition));
    } else if (y == 0) {
      return columnTitleCellBuilder(TitleCellBuildData(gridPosition: cellPosition.rowPosition));
    } else {
      return cellBuilder(CellBuildData(cellPosition: cellPosition));
    }
  }
}
