import 'package:excel_grid/excel_grid.dart';
import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/excel_keyboard_listener.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/grid_config.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_events.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/ui/cells/cell_builder.dart';
import 'package:excel_grid/src/ui/layout/grid_layout.dart';
import 'package:excel_grid/src/utils/cell_title_generator/cell_title_generator.dart';
import 'package:excel_grid/src/widgets/scroll_detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ExcelGridBuilder extends StatefulWidget {
  final int maxRows;
  final int maxColumns;
  final int visibleHorizontalCellCount;
  final int visibleVerticalCellCount;
  final CellTitleGenerator horizontalCellTitleGenerator;
  final CellTitleGenerator verticalCellTitleGenerator;
  final GridData gridData;

  const ExcelGridBuilder({
    required this.visibleHorizontalCellCount,
    required this.visibleVerticalCellCount,
    required this.maxRows,
    required this.maxColumns,
    required this.horizontalCellTitleGenerator,
    required this.verticalCellTitleGenerator,
    required this.gridData,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExcelGridBuilder();
}

class _ExcelGridBuilder extends State<ExcelGridBuilder> {
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
    scrollController
      ..init(
        visibleRows: widget.visibleVerticalCellCount - 5,
        visibleColumns: widget.visibleHorizontalCellCount - 4,
      )
      ..addListener(() {
        SelectionState state = selectionController.state;
        if (state is CellEditingState) {
          selectionController.state = SingleSelectedState(state.cellPosition);
        }
      });

    gridConfig.init(
      rowsCount: widget.maxRows,
      columnsCount: widget.maxColumns,
      horizontalCellTitleGenerator: widget.horizontalCellTitleGenerator,
      verticalCellTitleGenerator: widget.verticalCellTitleGenerator,
    );

    selectionController.addListener(() {
        focusNode.requestFocus();
    });

    storageManager.init(widget.gridData);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrollController.contentWidth = _calcContentWidth();
    scrollController.contentHeight = _calcContentHeight();

    return  ScrollDetector(
        scrollController: scrollController,
        child: ExcelKeyboardListener(
          gridFocusNode: focusNode,
          child: GridLayout(
          verticalCellCount: widget.visibleVerticalCellCount,
          horizontalCellCount: widget.visibleHorizontalCellCount,
          scrollController: scrollController,
          child: _buildExcelGrid(),
        ),
      ),
    );
  }

  void _handleKeyEvent(RawKeyEvent event) {
    print(event);
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        SelectionState selectionState = selectionController.state;
        if (selectionState is! CellEditingState) {
          if (selectionState is SingleSelectedState) {
            selectionController.handleEvent(CellEditingEvent(selectionState.cellPosition));
          }
          if (selectionState is MultiSelectedState) {
            selectionController.handleEvent(CellEditingEvent(selectionState.from));
          }
        } else {
          CellEditingState state = selectionController.state as CellEditingState;
          selectionController.handleEvent(SingleCellSelectEvent(state.cellPosition));
        }
      } else {
        SelectionState selectionState = selectionController.state;
        if (selectionState is! CellEditingState) {
          if (selectionState is SingleSelectedState) {
            selectionController.handleEvent(
                KeyPressedEvent(cellPosition: selectionState.cellPosition, keyValue: event.logicalKey.keyLabel));
          }
          if (selectionState is MultiSelectedState) {
            selectionController
                .handleEvent(KeyPressedEvent(cellPosition: selectionState.from, keyValue: event.logicalKey.keyLabel));
          }
        }
      }
    }
    // if(event.logicalKey == LogicalKeyboardKey.enter) {
    //   SelectionState selectionState = selectionController.state;
    //   if( selectionState is! CellEditingState ) {
    //     if( selectionState is SingleSelectedState) {
    //       selectionController.handleEvent(CellEditingEvent(selectionState.cellPosition));
    //     }
    //     if( selectionState is MultiSelectedState) {
    //       selectionController.handleEvent(CellEditingEvent(selectionState.from));
    //     }
    //   }
    // }
  }

  double _calcContentWidth() {
    int marginCellsCount = 4;
    double cellsWidth = InheritedExcelTheme.of(context).theme.cellTheme.width * (widget.maxColumns + marginCellsCount);
    double contentWidth = cellsWidth;
    return contentWidth;
  }

  double _calcContentHeight() {
    int marginCellsCount = 5;
    double cellsHeight = InheritedExcelTheme.of(context).theme.cellTheme.height * (widget.maxRows + marginCellsCount);
    double contentHeight = cellsHeight;
    return contentHeight;
  }

  Widget _buildExcelGrid() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: widget.visibleVerticalCellCount + 5,
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
        itemCount: widget.visibleHorizontalCellCount + 3,
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
