import 'package:excel_grid/src/manager/scroll_manager/events/scroll_mouse_event.dart';
import 'package:excel_grid/src/manager/scroll_manager/scroll_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScrollDetector extends StatelessWidget {
  final ScrollManager scrollManager;
  final Widget child;

  const ScrollDetector({
    required this.scrollManager,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (PointerSignalEvent pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          scrollManager.handleEvent(MouseScrollEvent(
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
