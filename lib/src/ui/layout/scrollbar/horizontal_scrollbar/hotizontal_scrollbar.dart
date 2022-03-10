import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_events.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_states.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/scroll_thumb.dart';
import 'package:flutter/material.dart';

class HorizontalScrollbar extends StatefulWidget {
  final ExcelScrollController scrollController;
  final double thumbSize;
  final double barMaxScrollExtent;

  const HorizontalScrollbar({
    required this.scrollController,
    required this.thumbSize,
    required this.barMaxScrollExtent,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HorizontalScrollbar();
}

class _HorizontalScrollbar extends State<HorizontalScrollbar> {
  /// Counts offset for scroll thumb in Vertical axis
  late double barOffset;

  double get barMaxScrollExtent => widget.barMaxScrollExtent - widget.thumbSize;

  double get barMinScrollExtent => 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (mounted) {
        ScrollState scrollState = widget.scrollController.state;
        if (scrollState is HorizontalScrolledState && scrollState.scrollSource != ScrollSource.scrollbar) {
          setState(() {
            _updateBarOffset(widget.scrollController.offset.dx / widget.scrollController.horizontalStep);
          });
        }
      }
    });
    barOffset = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: barOffset),
        child: ScrollThumb(
          width: widget.thumbSize,
          height: 12,
          margin: const EdgeInsets.symmetric(vertical: 2),
        ),
      ),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    double newBarOffset = barOffset + details.delta.dx;
    _updateBarOffset(newBarOffset);

    double scrollPosition = barOffset * widget.scrollController.horizontalStep;
    widget.scrollController.handleEvent(
      ScrollbarScrolledEvent(
        horizontalOffset: scrollPosition,
        verticalOffset: widget.scrollController.offset.dy,
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
