import 'package:excel_grid/src/manager/scroll_manager/events/scroll_event.dart';
import 'package:excel_grid/src/manager/scroll_manager/models/scroll_source.dart';
import 'package:flutter/material.dart';

class MouseScrollEvent extends ScrollEvent {
  MouseScrollEvent({
    required double verticalOffset,
    required double horizontalOffset,
  }) : super(
    verticalOffset: verticalOffset,
    horizontalOffset: horizontalOffset,
    scrollSource: ScrollSource.mouse,
  );

  @override
  Offset prepareScrollOffset() {
    Offset scrollOffset = scrollManager.offset.translate(
      horizontalOffset,
      verticalOffset,
    );
    return scrollOffset;
  }
}