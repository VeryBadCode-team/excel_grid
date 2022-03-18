import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme_material.dart';
import 'package:excel_grid/src/excel_config_widget.dart';
import 'package:excel_grid/src/models/excel_shortcuts/keyboard_shortcuts_config.dart';
import 'package:excel_grid/src/models/grid_data/grid_data.dart';
import 'package:excel_grid/src/ui/layout/selection_field.dart';
import 'package:excel_grid/src/shared/cell_title_generator/alphabet_cell_title_generator.dart';
import 'package:excel_grid/src/shared/cell_title_generator/cell_title_generator.dart';
import 'package:excel_grid/src/shared/cell_title_generator/numeric_cell_title_generator.dart';
import 'package:flutter/cupertino.dart';

class ExcelGrid extends StatefulWidget {
  final int maxRows;
  final int maxColumns;
  final GridData gridData;
  final CellTitleGenerator horizontalCellTitleGenerator;
  final CellTitleGenerator verticalCellTitleGenerator;
  final KeyboardShortcutsConfig keyboardShortcutsConfig;
  final ExcelGridTheme theme;

  const ExcelGrid({
    required this.gridData,
    this.maxRows = 100,
    this.maxColumns = 20,
    this.horizontalCellTitleGenerator = const AlphabetCellTitleGenerator(),
    this.verticalCellTitleGenerator = const NumericCellTitleGenerator(),
    this.theme = const ExcelGridThemeMaterial(),
    this.keyboardShortcutsConfig = const KeyboardShortcutsConfig.defaultConfig(),
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
    return SizedBox(
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
                return ExcelConfigWidget(
                  maxRows: widget.maxRows,
                  maxColumns: widget.maxColumns,
                  keyboardShortcutsConfig: widget.keyboardShortcutsConfig,
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
    );
  }
}
