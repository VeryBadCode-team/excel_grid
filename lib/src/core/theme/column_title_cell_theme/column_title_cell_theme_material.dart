import 'package:excel_grid/src/core/theme/column_title_cell_theme/column_title_cell_theme.dart';
import 'package:excel_grid/src/core/theme/material_excel_sizes.dart';

class ColumnTitleCellThemeMaterial extends ColumnTitleCellTheme {
  const ColumnTitleCellThemeMaterial({
    double height = MaterialExcelSizes.columnTitleCellHeight,
  }) : super(
          height: height,
        );
}
