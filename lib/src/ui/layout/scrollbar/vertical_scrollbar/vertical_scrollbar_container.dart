import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_events.dart';
import 'package:excel_grid/src/model/grid_config.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/scrollbar_button.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/vertical_scrollbar/vertical_scrollbar.dart';
import 'package:excel_grid/src/utils/custom_border.dart';
import 'package:excel_grid/src/utils/enums/append_border.dart';
import 'package:excel_grid/src/utils/scroll_utils.dart';
import 'package:flutter/material.dart';

class VerticalScrollbarContainer extends StatelessWidget {
  final ExcelScrollController scrollController;

  const VerticalScrollbarContainer({
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: CustomBorder.fromAppendBorder(
          borderSide: InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.borderSide,
          visibleBorders: <AppendBorder>{
            AppendBorder.left,
          },
        ),
      ),
      width: 13,
      child: Column(
        children: <Widget>[
          _buildHorizontalCellTitleMock(context),
          Expanded(
            child: LayoutBuilder(
              builder: (_, BoxConstraints constraints) => _buildScrollbarArea(constraints),
            ),
          ),
          ScrollbarButton(
            visibleBorders: const <AppendBorder>{AppendBorder.top},
            child: const Icon(
              Icons.arrow_drop_up,
              size: 13,
            ),
            onTap: () {
              scrollController.handleEvent(
                ButtonScrolledEvent(
                  horizontalOffset:  0,
                  verticalOffset: -1,
                ),
              );
            },
          ),
          ScrollbarButton(
            visibleBorders: const <AppendBorder>{AppendBorder.top},
            child: const Icon(
              Icons.arrow_drop_down,
              size: 13,
            ),
            onTap: () {
              scrollController.handleEvent(
                ButtonScrolledEvent(
                  horizontalOffset:  0,
                  verticalOffset: 1,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCellTitleMock(BuildContext context) {
    double height = InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.height;
    Color backgroundColor = InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.backgroundColor;
    BorderSide cellBorderSide = InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.borderSide;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: CustomBorder.fromAppendBorder(
          borderSide: cellBorderSide,
          visibleBorders: <AppendBorder>{
            AppendBorder.right,
          },
        ),
      ),
    );
  }

  Widget _buildScrollbarArea(BoxConstraints constraints) {
    GridConfig gridConfig = globalLocator<GridConfig>();
    scrollController.setVerticalViewport(gridConfig.rowsCount, constraints.maxHeight);

    return Column(
      children: <Widget>[
        VerticalScrollbar(
          scrollController: scrollController,
          thumbSize: ScrollUtils.calcThumbSize(
            contentSize: scrollController.contentHeight,
            viewportSize: scrollController.verticalViewport,
          ),
          barMaxScrollExtent: constraints.maxHeight,
        ),
      ],
    );
  }
}
