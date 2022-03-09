import 'package:excel_grid/src/core/theme/cell_theme/cell_theme.dart';
import 'package:excel_grid/src/core/theme/horizontal_title_cell_theme/horizontal_title_cell_theme.dart';
import 'package:excel_grid/src/core/theme/selection_theme/selection_theme.dart';
import 'package:excel_grid/src/core/theme/vertical_title_cell_theme/vertical_title_cell_theme.dart';

class ExcelGridTheme {
  final HorizontalTitleCellTheme horizontalTitleCellTheme;
  final VerticalTitleCellTheme verticalTitleCellTheme;
  final SelectionTheme selectionTheme;
  final CellTheme cellTheme;

  const ExcelGridTheme({
    required this.horizontalTitleCellTheme,
    required this.verticalTitleCellTheme,
    required this.selectionTheme,
    required this.cellTheme,
  });
}
