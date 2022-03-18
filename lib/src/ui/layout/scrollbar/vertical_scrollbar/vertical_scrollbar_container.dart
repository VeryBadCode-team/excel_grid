import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/core/theme/title_cell_theme/title_cell_theme.dart';
import 'package:excel_grid/src/manager/decoration_manager/decoration_manager.dart';
import 'package:excel_grid/src/manager/scroll_manager/events/scroll_button_event.dart';
import 'package:excel_grid/src/manager/scroll_manager/scroll_manager.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/scrollbar_button.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/vertical_scrollbar/vertical_scrollbar.dart';
import 'package:excel_grid/src/models/custom_border.dart';
import 'package:excel_grid/src/shared/enums/append_border.dart';
import 'package:excel_grid/src/shared/utils/scroll_utils.dart';
import 'package:flutter/material.dart';

class VerticalScrollbarContainer extends StatelessWidget {
  final ScrollManager scrollManager;

  const VerticalScrollbarContainer({
    required this.scrollManager,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TitleCellTheme titleCellTheme = globalLocator<DecorationManager>().theme.titleCellTheme;

    return Container(
      width: 13,
      height: double.infinity,
      decoration: BoxDecoration(
        border: CustomBorder.fromAppendBorder(
          borderSide: titleCellTheme.borderSide,
          visibleBorders: <AppendBorder>{
            AppendBorder.left,
          },
        ),
      ),
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
              scrollManager.handleEvent(
                ButtonScrollEvent(
                  horizontalOffset: 0,
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
              scrollManager.handleEvent(
                ButtonScrollEvent(
                  horizontalOffset: 0,
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
    ExcelGridTheme theme = globalLocator<DecorationManager>().theme;
    double height = theme.columnTitleCellTheme.height;
    Color backgroundColor = theme.titleCellTheme.backgroundColor;
    BorderSide cellBorderSide = theme.titleCellTheme.borderSide;

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
    return Column(
      children: <Widget>[
        VerticalScrollbar(
            constraints: constraints,
            thumbSize: ScrollUtils.calcThumbSize(
              contentSize: scrollManager.contentHeight,
              viewportSize: constraints.maxHeight,
            ),
            barMaxScrollExtent: constraints.maxHeight,
          ),

      ],
    );
  }
}
