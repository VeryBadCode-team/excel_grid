import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/excel_grid_builder.dart';
import 'package:excel_grid/src/excel_keyboard_listener.dart';
import 'package:excel_grid/src/manager/decoration_manager/decoration_manager.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/scroll_manager/scroll_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/editing_cell_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/single_selected_state.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/models/excel_shortcuts/keyboard_shortcuts_config.dart';
import 'package:excel_grid/src/models/grid_data/grid_data.dart';
import 'package:excel_grid/src/shared/cell_title_generator/cell_title_generator.dart';
import 'package:excel_grid/src/ui/layout/grid_layout.dart';
import 'package:excel_grid/src/widgets/scroll_detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExcelConfigWidget extends StatefulWidget {
  final int maxRows;
  final int maxColumns;
  final CellTitleGenerator horizontalCellTitleGenerator;
  final CellTitleGenerator verticalCellTitleGenerator;
  final GridData gridData;
  final BoxConstraints constraints;
  final ExcelGridTheme theme;
  final KeyboardShortcutsConfig keyboardShortcutsConfig;

  const ExcelConfigWidget({
    required this.maxRows,
    required this.maxColumns,
    required this.horizontalCellTitleGenerator,
    required this.verticalCellTitleGenerator,
    required this.gridData,
    required this.constraints,
    required this.theme,
    required this.keyboardShortcutsConfig,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExcelConfigWidget();
}

class _ExcelConfigWidget extends State<ExcelConfigWidget> {
  final DecorationManager decorationManager = globalLocator<DecorationManager>();
  final ScrollManager scrollManager = globalLocator<ScrollManager>();
  final SelectionManager selectionManager = globalLocator<SelectionManager>();
  final StorageManager storageManager = globalLocator<StorageManager>();
  final GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    decorationManager.theme = widget.theme;
    _initProvidersData();
    _updatescrollManager();
    scrollManager.addListener(_onViewScrolled);
    selectionManager.addListener(_onSelectionChanged);

    super.initState();
  }

  @override
  void dispose() {
    scrollManager.removeListener(_onViewScrolled);
    selectionManager.removeListener(_onSelectionChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ExcelConfigWidget oldWidget) {
    _updatescrollManager();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollDetector(
      scrollManager: scrollManager,
      child: ExcelKeyboardListener(
        keyboardShortcutsConfig: widget.keyboardShortcutsConfig,
        gridFocusNode: focusNode,
        child: GridLayout(
          scrollManager: scrollManager,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return ExcelGridBuilder(
                excelSize: Size(constraints.maxWidth, constraints.maxHeight),
                scrollManager: scrollManager,
              );
            },
          ),
        ),
      ),
    );
  }

  void _initProvidersData() {
    storageManager.init(widget.gridData);
    gridConfigManager.init(
      rowsCount: widget.maxRows,
      columnsCount: widget.maxColumns,
      horizontalCellTitleGenerator: widget.horizontalCellTitleGenerator,
      verticalCellTitleGenerator: widget.verticalCellTitleGenerator,
    );
  }

  void _updatescrollManager() {
    scrollManager.onWindowSizeChanged(
      maxWidth: widget.constraints.maxWidth,
      maxHeight: widget.constraints.maxHeight,
    );
    scrollManager.contentWidth = decorationManager.getContentWidth();
    scrollManager.contentHeight = decorationManager.getContentHeight();
  }

  void _onViewScrolled() {
    SelectionState state = selectionManager.state;
    if (state is EditingCellState) {
      selectionManager.state = SingleCellSelectedState(state.cellPosition);
    }
  }

  void _onSelectionChanged() {
    focusNode.requestFocus();
  }
}
