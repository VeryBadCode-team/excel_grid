import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_events.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/horizontal_scrollbar/hotizontal_scrollbar.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/scrollbar_button.dart';
import 'package:excel_grid/src/utils/custom_border.dart';
import 'package:excel_grid/src/utils/enums/append_border.dart';
import 'package:excel_grid/src/utils/scroll_utils.dart';
import 'package:flutter/material.dart';

class HorizontalScrollbarContainer extends StatelessWidget {
  final ExcelScrollController scrollController;

  const HorizontalScrollbarContainer({
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 13,
      width: double.infinity,
      decoration: BoxDecoration(
        border: CustomBorder.fromAppendBorder(
          borderSide: InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.borderSide,
          visibleBorders: <AppendBorder>{
            AppendBorder.left,
          },
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
              scrollController.handleEvent(
                ButtonScrolledEvent(
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
              scrollController.handleEvent(
                ButtonScrolledEvent(
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
    double width = InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.width;
    Color backgroundColor = InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.backgroundColor;
    BorderSide cellBorderSide = InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.borderSide;

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
            contentSize: scrollController.contentWidth,
            viewportSize: constraints.maxWidth,
          ),
          barMaxScrollExtent: constraints.maxWidth,
        ),
      ],
    );
  }
}
