import 'package:excel_grid/excel_grid.dart';
import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/excel_keyboard_listener.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/decoration_manager/decoration_manager.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/grid_config.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/ui/cells/cell_builder.dart';
import 'package:excel_grid/src/ui/layout/grid_layout.dart';
import 'package:excel_grid/src/utils/cell_title_generator/cell_title_generator.dart';
import 'package:excel_grid/src/widgets/scroll_detector.dart';
import 'package:flutter/cupertino.dart';

class ExcelGridBuilder extends StatefulWidget {
  final int maxRows;
  final int maxColumns;
  final CellTitleGenerator horizontalCellTitleGenerator;
  final CellTitleGenerator verticalCellTitleGenerator;
  final GridData gridData;
  final BoxConstraints constraints;
  final ExcelGridTheme theme;

  const ExcelGridBuilder({
    required this.maxRows,
    required this.maxColumns,
    required this.horizontalCellTitleGenerator,
    required this.verticalCellTitleGenerator,
    required this.gridData,
    required this.constraints,
    required this.theme,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExcelGridBuilder();
}

class _ExcelGridBuilder extends State<ExcelGridBuilder> {
  final DecorationManager decorationManager = globalLocator<DecorationManager>();
  final ExcelScrollController scrollController = globalLocator<ExcelScrollController>();
  final SelectionController selectionController = globalLocator<SelectionController>();
  final StorageManager storageManager = globalLocator<StorageManager>();
  final GridConfig gridConfig = globalLocator<GridConfig>();
  final FocusNode focusNode = FocusNode();

  // final List<KeyboardAction> keyboardActions = <KeyboardAction>[
  //
  // ]

  @override
  void initState() {
    decorationManager.theme = widget.theme;
    gridConfig.init(
      rowsCount: widget.maxRows,
      columnsCount: widget.maxColumns,
      horizontalCellTitleGenerator: widget.horizontalCellTitleGenerator,
      verticalCellTitleGenerator: widget.verticalCellTitleGenerator,
    );

    _configureScrollController();
    scrollController.addListener(() {
      SelectionState state = selectionController.state;
      if (state is CellEditingState) {
        selectionController.state = SingleSelectedState(state.cellPosition);
      }
    });



    selectionController.addListener(() {
      focusNode.requestFocus();
    });

    storageManager.init(widget.gridData);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ExcelGridBuilder oldWidget) {
    _configureScrollController();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollDetector(
      scrollController: scrollController,
      child: ExcelKeyboardListener(
        gridFocusNode: focusNode,
        child: GridLayout(
          scrollController: scrollController,
          child: _buildExcelGrid(),
        ),
      ),
    );
  }

  void _configureScrollController() {
    scrollController.onWindowSizeChanged(
      maxWidth: widget.constraints.maxWidth,
      maxHeight: widget.constraints.maxHeight,
    );
    scrollController.contentWidth = decorationManager.getContentWidth();
    scrollController.contentHeight = decorationManager.getContentHeight();

    scrollController.visibleColumnsCount = decorationManager.getVisibleColumnsCount();
    scrollController.visibleRowsCount = decorationManager.getVisibleRowsCount();
  }

  Widget _buildExcelGrid() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: scrollController.visibleRowsCount,
      itemBuilder: (_, int rowIndex) => _buildGridRow(rowIndex),
    );
  }

  Widget _buildGridRow(int rowIndex) {
    return SizedBox(
      height: rowIndex == 0
          ? InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.height
          : InheritedExcelTheme.of(context).theme.cellTheme.height,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: scrollController.visibleColumnsCount,
        itemBuilder: (_, int columnIndex) => CellBuilder(
          scrollController: scrollController,
          maxRows: widget.maxRows,
          maxColumns: widget.maxColumns,
          columnIndex: columnIndex,
          rowIndex: rowIndex,
        ),
      ),
    );
  }
}
