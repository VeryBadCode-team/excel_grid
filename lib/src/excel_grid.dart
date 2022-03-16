import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme_material.dart';
import 'package:excel_grid/src/excel_grid_builder.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/grid_data.dart';
import 'package:excel_grid/src/ui/layout/selection_field.dart';
import 'package:excel_grid/src/utils/cell_title_generator/alphabet_cell_title_generator.dart';
import 'package:excel_grid/src/utils/cell_title_generator/cell_title_generator.dart';
import 'package:excel_grid/src/utils/cell_title_generator/numeric_cell_title_generator.dart';
import 'package:flutter/cupertino.dart';

class ExcelGrid extends StatefulWidget {
  final int maxRows;
  final int maxColumns;
  final GridData gridData;
  final CellTitleGenerator horizontalCellTitleGenerator;
  final CellTitleGenerator verticalCellTitleGenerator;
  final ExcelGridTheme theme;

  const ExcelGrid({
    required this.gridData,
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
        child: Column(
          children: <Widget>[
            Row(
              children: const <Widget>[
                SelectionField(),
              ],
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return ExcelGridBuilder(
                    maxRows: widget.maxRows,
                    maxColumns: widget.maxColumns,
                    gridData: widget.gridData,
                    horizontalCellTitleGenerator: widget.horizontalCellTitleGenerator,
                    verticalCellTitleGenerator: widget.verticalCellTitleGenerator,
                    constraints: constraints,
                    theme: widget.theme,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
