import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/scroll_manager/events/scroll_scrollbar_event.dart';
import 'package:excel_grid/src/manager/scroll_manager/models/scroll_source.dart';
import 'package:excel_grid/src/manager/scroll_manager/scroll_manager.dart';
import 'package:excel_grid/src/manager/scroll_manager/states/scroll_state.dart';
import 'package:excel_grid/src/manager/scroll_manager/states/scrolled_state.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/scroll_thumb.dart';
import 'package:flutter/material.dart';

class VerticalScrollbar extends StatefulWidget {
  final double thumbSize;
  final double barMaxScrollExtent;
  final BoxConstraints constraints;

  const VerticalScrollbar({
    required this.thumbSize,
    required this.barMaxScrollExtent,
    required this.constraints,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VerticalScrollbar();
}

class _VerticalScrollbar extends State<VerticalScrollbar> {
  final ScrollManager scrollManager = globalLocator<ScrollManager>();
  final GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();

  /// Counts offset for scroll thumb in Vertical axis
  late double barOffset;

  double get barMaxScrollExtent => widget.barMaxScrollExtent - widget.thumbSize;

  double get barMinScrollExtent => 0.0;

  double get verticalStep => gridConfigManager.rowsCount / widget.constraints.maxHeight;

  @override
  void initState() {
    super.initState();
    barOffset = 0.0;

    scrollManager.addListener(() {
      if (mounted) {
        ScrollState scrollState = scrollManager.state;
        if (scrollState is VerticalScrolledState && scrollState.scrollSource != ScrollSource.scrollbar) {
          setState(() {
            _updateBarOffset(scrollManager.offset.dy / verticalStep);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _onDragUpdate,
      child: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: barOffset),
        child: ScrollThumb(
          width: 12.0,
          height: widget.thumbSize,
          margin: const EdgeInsets.symmetric(horizontal: 2),
        ),
      ),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    double newBarOffset = barOffset + details.delta.dy;

    _updateBarOffset(newBarOffset);

    double scrollPosition = barOffset * verticalStep;
    scrollManager.handleEvent(
      ScrollbarScrollEvent(
        horizontalOffset: scrollManager.offset.dx,
        verticalOffset: scrollPosition,
      ),
    );
    setState(() {});
  }

  void _updateBarOffset(double offset) {
    barOffset = offset;
    if (barOffset < barMinScrollExtent) {
      barOffset = barMinScrollExtent;
    }
    if (barOffset > barMaxScrollExtent) {
      barOffset = barMaxScrollExtent;
    }
  }
}
