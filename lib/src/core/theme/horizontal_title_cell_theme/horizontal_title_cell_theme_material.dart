import 'package:excel_grid/src/core/theme/horizontal_title_cell_theme/horizontal_title_cell_theme.dart';
import 'package:excel_grid/src/core/theme/material_excel_palette.dart';
import 'package:excel_grid/src/core/theme/material_excel_sizes.dart';
import 'package:flutter/material.dart';

class HorizontalTitleCellThemeMaterial extends HorizontalTitleCellTheme {
  const HorizontalTitleCellThemeMaterial({
    double width = MaterialExcelSizes.horizontalTitleCellWidth,
    double height = MaterialExcelSizes.horizontalTitleCellHeight,
    Color backgroundColor = MaterialExcelPalette.gray4_100,
    TextStyle textStyle = const TextStyle(
      color: MaterialExcelPalette.gray1_100,
      fontSize: 12,
    ),
    BorderSide borderSide = const BorderSide(
      color: MaterialExcelPalette.gray2_100,
      width: 0.25,
    ),
  }) : super(
          width: width,
          height: height,
          backgroundColor: backgroundColor,
          textStyle: textStyle,
          borderSide: borderSide,
        );
}
