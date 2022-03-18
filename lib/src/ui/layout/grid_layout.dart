import 'package:excel_grid/src/manager/scroll_manager/scroll_manager.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/horizontal_scrollbar/horizontal_scrollbar_container.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/vertical_scrollbar/vertical_scrollbar_container.dart';
import 'package:flutter/material.dart';

class GridLayout extends StatelessWidget {
  final Widget child;
  final ScrollManager scrollManager;

  const GridLayout({
    required this.child,
    required this.scrollManager,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: Expanded(
                  child: Container(
                    color: const Color(0xFFF3F3F3),
                    child: child,
                  ),
                ),
              ),
              VerticalScrollbarContainer(
                scrollManager: scrollManager,
              )
            ],
          ),
        ),
        HorizontalScrollbarContainer(
          scrollManager: scrollManager,
        ),
      ],
    );
  }
}
