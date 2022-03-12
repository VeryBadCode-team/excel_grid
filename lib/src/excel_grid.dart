import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme_material.dart';
import 'package:excel_grid/src/excel_grid_builder.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/utils/cell_title_generator/alphabet_cell_title_generator.dart';
import 'package:excel_grid/src/utils/cell_title_generator/cell_title_generator.dart';
import 'package:excel_grid/src/utils/cell_title_generator/numeric_cell_title_generator.dart';
import 'package:flutter/cupertino.dart';

class ExcelGrid extends StatefulWidget {
  final int maxRows;
  final int maxColumns;
  final CellTitleGenerator horizontalCellTitleGenerator;
  final CellTitleGenerator verticalCellTitleGenerator;
  final ExcelGridTheme theme;

  const ExcelGrid({
    this.maxRows = 100,
    this.maxColumns = 20,
    this.horizontalCellTitleGenerator = const AlphabetCellTitleGenerator(),
    this.verticalCellTitleGenerator = const NumericCellTitleGenerator(),
    this.theme = const ExcelGridThemeMaterial(),
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExcelGrid();
}

class _ExcelGrid extends State<ExcelGrid> {
  @override
  void initState() {
    initLocator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return InheritedExcelTheme(
      theme: widget.theme,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            int horizontalCellCount = _calcCellCount(
              constraints.maxWidth,
              InheritedExcelTheme.of(context).theme.cellTheme.width,
            );
            int verticalCellCount = _calcCellCount(
              constraints.maxHeight,
              InheritedExcelTheme.of(context).theme.cellTheme.height,
            );
            return ExcelGridBuilder(
              maxRows: widget.maxRows,
              maxColumns: widget.maxColumns,
              visibleVerticalCellCount: verticalCellCount,
              visibleHorizontalCellCount: horizontalCellCount,
              horizontalCellTitleGenerator: widget.horizontalCellTitleGenerator,
              verticalCellTitleGenerator: widget.verticalCellTitleGenerator,
            );
          },
        ),
      ),
    );
  }

  int _calcCellCount(double width, double cellSize) {
    double screenWidth = width;
    int cellCount = (screenWidth / cellSize).round();
    return cellCount + 1;
  }
}
