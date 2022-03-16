import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/grid_config.dart';
import 'package:flutter/cupertino.dart';

class DecorationManager extends ChangeNotifier {
  final GridConfig gridConfig = globalLocator<GridConfig>();
  final ExcelScrollController scrollController = globalLocator<ExcelScrollController>();

  late ExcelGridTheme theme;

  double getContentWidth() {
    double cellsWidth = theme.cellTheme.width * (gridConfig.columnsCount + theme.horizontalMarginCellsCount);
    double contentWidth = cellsWidth;
    return contentWidth;
  }

  double getContentHeight() {
    double cellsHeight = theme.cellTheme.height * (gridConfig.rowsCount + theme.verticalMarginCellsCount);
    double contentHeight = cellsHeight;
    return contentHeight;
  }

  int getVisibleColumnsCount() {
    double horizontalViewport = scrollController.horizontalViewport;
    // int actualIndex = scrollController.offset.dx.toInt();
    int cellsCount = 0;
    while(horizontalViewport > 0 ) {
      horizontalViewport -= theme.cellTheme.width;
      cellsCount += 1;
    }
    return cellsCount;
  }

  int getVisibleRowsCount() {
    double verticalViewport = scrollController.verticalViewport;
    // int actualIndex = scrollController.offset.dx.toInt();
    int cellsCount = 0;
    while(verticalViewport > 0 ) {
      verticalViewport -= theme.cellTheme.height;
      cellsCount += 1;
    }
    return cellsCount;
  }
}