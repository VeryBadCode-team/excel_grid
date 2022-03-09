import 'package:excel_grid/src/core/theme/cell_theme/cell_theme.dart';
import 'package:excel_grid/src/core/theme/cell_theme/cell_theme_material.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/core/theme/horizontal_title_cell_theme/horizontal_title_cell_theme.dart';
import 'package:excel_grid/src/core/theme/horizontal_title_cell_theme/horizontal_title_cell_theme_material.dart';
import 'package:excel_grid/src/core/theme/selection_theme/selection_theme.dart';
import 'package:excel_grid/src/core/theme/selection_theme/selection_theme_material.dart';
import 'package:excel_grid/src/core/theme/vertical_title_cell_theme/vertical_title_cell_theme.dart';
import 'package:excel_grid/src/core/theme/vertical_title_cell_theme/vertical_title_cell_theme_material.dart';

class ExcelGridThemeMaterial extends ExcelGridTheme {
  const ExcelGridThemeMaterial({
    HorizontalTitleCellTheme horizontalTitleCellTheme = const HorizontalTitleCellThemeMaterial(),
    VerticalTitleCellTheme verticalTitleCellTheme = const VerticalTitleCellThemeMaterial(),
    SelectionTheme selectionTheme = const SelectionThemeMaterial(),
    CellTheme cellTheme = const CellThemeMaterial(),
  }) : super(
          horizontalTitleCellTheme: horizontalTitleCellTheme,
          verticalTitleCellTheme: verticalTitleCellTheme,
          selectionTheme: selectionTheme,
          cellTheme: cellTheme,
        );
}
