import 'package:excel_grid/src/core/theme/material_excel_palette.dart';
import 'package:excel_grid/src/core/theme/selection_theme/selection_theme.dart';
import 'package:flutter/cupertino.dart';

class SelectionThemeMaterial extends SelectionTheme {

  const SelectionThemeMaterial({
    BorderSide primaryBorderSide = const BorderSide(
      width: 1.5,
      color: MaterialExcelPalette.blue1_100,
    ),
    BorderSide secondaryBorderSide = const BorderSide(
      width: 0.5,
      color: MaterialExcelPalette.blue1_100,
    ),
    Color backgroundColor = MaterialExcelPalette.blue1_10,
    Color selectorColor = MaterialExcelPalette.blue1_100,
  }) : super(
          primaryBorderSide: primaryBorderSide,
          secondaryBorderSide: secondaryBorderSide,
          backgroundColor: backgroundColor,
          selectorColor: selectorColor,
        );
}
