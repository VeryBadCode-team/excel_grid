import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_events.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_states.dart';
import 'package:excel_grid/src/ui/layout/scrollbar/scroll_thumb.dart';
import 'package:flutter/material.dart';

class VerticalScrollbar extends StatefulWidget {
  final ExcelScrollController scrollController;
  final double thumbSize;
  final double barMaxScrollExtent;

  const VerticalScrollbar({
    required this.scrollController,
    required this.thumbSize,
    required this.barMaxScrollExtent,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VerticalScrollbar();
}

class _VerticalScrollbar extends State<VerticalScrollbar> {
  /// Counts offset for scroll thumb in Vertical axis
  late double barOffset;

  double get barMaxScrollExtent => widget.barMaxScrollExtent - widget.thumbSize;

  double get barMinScrollExtent => 0.0;

  @override
  void initState() {
    super.initState();
    barOffset = 0.0;

    widget.scrollController.addListener(() {
      if (mounted) {
        ScrollState scrollState = widget.scrollController.state;
        if (scrollState is VerticalScrolledState && scrollState.scrollSource != ScrollSource.scrollbar) {
          setState(() {
            _updateBarOffset(widget.scrollController.offset.dy / widget.scrollController.verticalStep);
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

    double scrollPosition = barOffset * widget.scrollController.verticalStep;
    widget.scrollController.handleEvent(
      ScrollbarScrolledEvent(
        horizontalOffset: widget.scrollController.offset.dx,
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
