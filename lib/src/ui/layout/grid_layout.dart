import 'package:excel_grid/src/model/excel_scroll_controller.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/horizontal_scrollbar/horizontal_scrollbar_container.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/vertical_scrollbar/vertical_scrollbar_container.dart';
import 'package:flutter/material.dart';

class GridLayout extends StatelessWidget {
  final Widget child;
  final ExcelScrollController scrollController;
  final int horizontalCellCount;
  final int verticalCellCount;

  const GridLayout({
    required this.child,
    required this.scrollController,
    required this.horizontalCellCount,
    required this.verticalCellCount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: const <Widget>[
            // SelectionPreview(),
          ],
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: Expanded(
                  child: Container(
                    color: Colors.black12,
                    child: child,
                  ),
                ),
              ),
              VerticalScrollbarContainer(
                scrollController: scrollController,
                maxRows: scrollController.maxRows,
              )
            ],
          ),
        ),
        HorizontalScrollbarContainer(
          scrollController: scrollController,
          maxColumns: scrollController.maxColumns,
        ),
      ],
    );
  }
}
