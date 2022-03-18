import 'package:excel_grid/src/core/theme/cell_theme/cell_theme.dart';
import 'package:excel_grid/src/core/theme/cell_theme/cell_theme_material.dart';
import 'package:excel_grid/src/core/theme/column_title_cell_theme/column_title_cell_theme.dart';
import 'package:excel_grid/src/core/theme/column_title_cell_theme/column_title_cell_theme_material.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/core/theme/row_title_cell_theme/row_title_cell_theme.dart';
import 'package:excel_grid/src/core/theme/row_title_cell_theme/row_title_cell_theme_material.dart';
import 'package:excel_grid/src/core/theme/selection_theme/selection_theme.dart';
import 'package:excel_grid/src/core/theme/selection_theme/selection_theme_material.dart';
import 'package:excel_grid/src/core/theme/title_cell_theme/title_cell_theme.dart';
import 'package:excel_grid/src/core/theme/title_cell_theme/title_cell_theme_material.dart';

class ExcelGridThemeMaterial extends ExcelGridTheme {
  const ExcelGridThemeMaterial({
    int verticalMarginCellsCount = 3,
    int horizontalMarginCellsCount = 3,
    TitleCellTheme titleCellTheme = const TitleCellThemeMaterial(),
    RowTitleCellTheme rowTitleCellTheme = const RowTitleCellThemeMaterial(),
    ColumnTitleCellTheme columnTitleCellTheme = const ColumnTitleCellThemeMaterial(),
    SelectionTheme selectionTheme = const SelectionThemeMaterial(),
    CellTheme cellTheme = const CellThemeMaterial(),
  }) : super(
          verticalMarginCellsCount: verticalMarginCellsCount,
          horizontalMarginCellsCount: horizontalMarginCellsCount,
          titleCellTheme: titleCellTheme,
          rowTitleCellTheme: rowTitleCellTheme,
          columnTitleCellTheme: columnTitleCellTheme,
          selectionTheme: selectionTheme,
          cellTheme: cellTheme,
        );
}
