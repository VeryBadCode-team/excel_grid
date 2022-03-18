import 'package:excel_grid/src/core/theme/material_excel_sizes.dart';
import 'package:excel_grid/src/core/theme/row_title_cell_theme/row_title_cell_theme.dart';

class RowTitleCellThemeMaterial extends RowTitleCellTheme {
  const RowTitleCellThemeMaterial({
    double width = MaterialExcelSizes.rowTitleCellWidth,
  }) : super(
          width: width,
        );
}
