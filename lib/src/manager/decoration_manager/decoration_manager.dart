import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/scroll_manager/scroll_manager.dart';
import 'package:flutter/cupertino.dart';

class DecorationManager extends ChangeNotifier {
  final GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
  final ScrollManager scrollManager = globalLocator<ScrollManager>();
  
  late final ExcelGridTheme theme;
  
  void init({required ExcelGridTheme theme}) {
    this.theme = theme;
  }

  double getContentWidth() {
    double cellsWidth = theme.cellTheme.width * (gridConfigManager.columnsCount + theme.horizontalMarginCellsCount);
    double contentWidth = cellsWidth;
    return contentWidth;
  }

  double getContentHeight() {
    double cellsHeight = theme.cellTheme.height * (gridConfigManager.rowsCount + theme.verticalMarginCellsCount);
    double contentHeight = cellsHeight;
    return contentHeight;
  }

  double getColumnWidth(int columnIndex) {
    if (columnIndex == 0) {
      return theme.rowTitleCellTheme.width;
    }
    return theme.cellTheme.width;
  }

  double getRowHeight(int rowIndex) {
    if (rowIndex == 0) {
      return theme.columnTitleCellTheme.height;
    }
    return theme.cellTheme.height;
  }
}
