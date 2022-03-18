import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/core/theme/title_cell_theme/title_cell_theme.dart';
import 'package:excel_grid/src/manager/decoration_manager/decoration_manager.dart';
import 'package:excel_grid/src/manager/scroll_manager/events/scroll_button_event.dart';
import 'package:excel_grid/src/manager/scroll_manager/scroll_manager.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/horizontal_scrollbar/horizontal_scrollbar.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/scrollbar_button.dart';
import 'package:excel_grid/src/models/custom_border.dart';
import 'package:excel_grid/src/shared/enums/append_border.dart';
import 'package:excel_grid/src/shared/utils/scroll_utils.dart';
import 'package:flutter/material.dart';

class HorizontalScrollbarContainer extends StatelessWidget {
  final ScrollManager scrollManager;

  const HorizontalScrollbarContainer({
    required this.scrollManager,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TitleCellTheme titleCellTheme = globalLocator<DecorationManager>().theme.titleCellTheme;
    return Container(
      height: 13,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          titleCellTheme.borderSide,
        ),
      ),
      child: Row(
        children: <Widget>[
          _buildVerticalCellTitleMock(context),
          Expanded(
            child: LayoutBuilder(
              builder: (_, BoxConstraints constraints) => _buildScrollbarArea(constraints),
            ),
          ),
          ScrollbarButton(
            visibleBorders: const <AppendBorder>{AppendBorder.left},
            child: const Icon(
              Icons.arrow_left,
              size: 13,
            ),
            onTap: () {
              scrollManager.handleEvent(
                ButtonScrollEvent(
                  horizontalOffset: -1,
                  verticalOffset: 0,
                ),
              );
            },
          ),
          ScrollbarButton(
            visibleBorders: const <AppendBorder>{AppendBorder.left},
            child: const Icon(
              Icons.arrow_right,
              size: 13,
            ),
            onTap: () {
              scrollManager.handleEvent(
                ButtonScrollEvent(
                  horizontalOffset: 1,
                  verticalOffset: 0,
                ),
              );
            },
          ),
          const ScrollbarButton(
            visibleBorders: <AppendBorder>{AppendBorder.left},
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalCellTitleMock(BuildContext context) {
    ExcelGridTheme theme = globalLocator<DecorationManager>().theme;

    double width = theme.rowTitleCellTheme.width;
    Color backgroundColor = theme.titleCellTheme.backgroundColor;
    BorderSide cellBorderSide = theme.titleCellTheme.borderSide;

    return Container(
      width: width,
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
    return Row(
      children: <Widget>[
        HorizontalScrollbar(
          constraints: constraints,
          thumbSize: ScrollUtils.calcThumbSize(
            contentSize: scrollManager.contentWidth,
            viewportSize: constraints.maxWidth,
          ),
          barMaxScrollExtent: constraints.maxWidth,
        ),
      ],
    );
  }
}
