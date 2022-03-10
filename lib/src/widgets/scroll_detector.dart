import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_events.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScrollDetector extends StatelessWidget {
  final ExcelScrollController scrollController;
  final Widget child;

  const ScrollDetector({
    required this.scrollController,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (PointerSignalEvent pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          scrollController.handleEvent(MouseScrolledEvent(
            horizontalOffset: _parseOffset(pointerSignal.scrollDelta.dx),
            verticalOffset: _parseOffset(pointerSignal.scrollDelta.dy),
          ));
        }
      },
      child: child,
    );
  }

  double _parseOffset(double value) {
    if (value == 0) {
      return 0;
    }
    int scrollDelta = (value.abs() / 53).round();
    if (value < 0) {
      scrollDelta *= -1;
    }
    return scrollDelta.toDouble();
  }
}
