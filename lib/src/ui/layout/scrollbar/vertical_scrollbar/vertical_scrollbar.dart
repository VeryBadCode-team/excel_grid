import 'package:excel_grid/src/model/excel_scroll_controller.dart';
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
        if (widget.scrollController.state is MouseScrollState) {
          setState(() {
            _updateBarOffset(widget.scrollController.offset.dy / widget.scrollController.offsetStep.dy);
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

    double scrollPosition = barOffset * widget.scrollController.offsetStep.dy;
    widget.scrollController.state = ScrollbarScrollState();
    widget.scrollController.jump(Offset(widget.scrollController.offset.dx, scrollPosition));
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