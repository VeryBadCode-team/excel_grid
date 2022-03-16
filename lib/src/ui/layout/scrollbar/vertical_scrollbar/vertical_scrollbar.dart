import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_events.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_states.dart';
import 'package:excel_grid/src/model/grid_config.dart';
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
  final ExcelScrollController scrollController = globalLocator<ExcelScrollController>();
  final GridConfig gridConfig = globalLocator<GridConfig>();

  /// Counts offset for scroll thumb in Vertical axis
  late double barOffset;

  double get barMaxScrollExtent => widget.barMaxScrollExtent - widget.thumbSize;

  double get barMinScrollExtent => 0.0;

  double get verticalStep => gridConfig.rowsCount / widget.constraints.maxHeight;

  @override
  void initState() {
    super.initState();
    barOffset = 0.0;

    scrollController.addListener(() {
      if (mounted) {
        ScrollState scrollState = scrollController.state;
        if (scrollState is VerticalScrolledState && scrollState.scrollSource != ScrollSource.scrollbar) {
          setState(() {
            _updateBarOffset(scrollController.offset.dy / verticalStep);
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
    scrollController.handleEvent(
      ScrollbarScrolledEvent(
        horizontalOffset: scrollController.offset.dx,
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
