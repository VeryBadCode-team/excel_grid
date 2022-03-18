import 'package:excel_grid/src/core/theme/cell_theme/cell_theme.dart';
import 'package:excel_grid/src/core/theme/column_title_cell_theme/column_title_cell_theme.dart';
import 'package:excel_grid/src/core/theme/row_title_cell_theme/row_title_cell_theme.dart';
import 'package:excel_grid/src/core/theme/selection_theme/selection_theme.dart';
import 'package:excel_grid/src/core/theme/title_cell_theme/title_cell_theme.dart';

class ExcelGridTheme {
  final int verticalMarginCellsCount;
  final int horizontalMarginCellsCount;
  final TitleCellTheme titleCellTheme;
  final RowTitleCellTheme rowTitleCellTheme;
  final ColumnTitleCellTheme columnTitleCellTheme;
  final SelectionTheme selectionTheme;
  final CellTheme cellTheme;

  const ExcelGridTheme({
    required this.verticalMarginCellsCount,
    required this.titleCellTheme,
    required this.horizontalMarginCellsCount,
    required this.rowTitleCellTheme,
    required this.columnTitleCellTheme,
    required this.selectionTheme,
    required this.cellTheme,
  });
}
