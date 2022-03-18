import 'package:excel_grid/src/core/theme/cell_theme/cell_theme.dart';
import 'package:excel_grid/src/core/theme/material_excel_palette.dart';
import 'package:excel_grid/src/core/theme/material_excel_sizes.dart';
import 'package:flutter/material.dart';

class CellThemeMaterial extends CellTheme {
  const CellThemeMaterial({
    double width = MaterialExcelSizes.cellWidth,
    double height = MaterialExcelSizes.cellHeight,
    double cellPadding = 8,
    Color backgroundColor = Colors.transparent,
    BorderSide borderSide = const BorderSide(
      width: 0.2,
      color: MaterialExcelPalette.gray3_100,
    ),
  }) : super(
          width: width,
          height: height,
    cellPadding: cellPadding,
          backgroundColor: backgroundColor,
          borderSide: borderSide,
        );
}
