import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_states.dart';
import 'package:flutter/material.dart';

abstract class ScrollEvent {
  void execute(ExcelScrollController scrollController);
}

abstract class ScrolledEvent extends ScrollEvent {
  late final ExcelScrollController scrollController;
  final ScrollSource scrollSource;
  final double verticalOffset;
  final double horizontalOffset;
  Offset previousOffset = const Offset(0, 0);

  ScrolledEvent({
    required this.scrollSource,
    required this.verticalOffset,
    required this.horizontalOffset,
  });

  @override
  void execute(ExcelScrollController scrollController) {
    previousOffset = scrollController.offset;
    this.scrollController = scrollController;
    Offset scrollOffset = prepareScrollOffset();
    scrollOffset = _getLimitedOffset(scrollOffset);
    _scroll(scrollOffset);
    _setScrollState();

    scrollController.notifyShouldUpdate();
  }

  Offset prepareScrollOffset();

  Offset _getLimitedOffset(Offset scrollOffset) {
    final double translatedX = _cutToRange(
      value: scrollOffset.dx,
      viewportItemsCount: scrollController.visibleColumns,
      allItemsCount: scrollController.columnsCount,
    );

    final double translatedY = _cutToRange(
      value: scrollOffset.dy,
      viewportItemsCount: scrollController.visibleRows,
      allItemsCount: scrollController.rowsCount,
    );
    return Offset(
      translatedX,
      translatedY,
    );
  }

  double _cutToRange({
    required double value,
    required int viewportItemsCount,
    required int allItemsCount,
  }) {
    if (value < 0) {
      return 0;
    }
    if (value + viewportItemsCount > allItemsCount) {
      return (allItemsCount - viewportItemsCount).toDouble();
    }
    return value;
  }

  void _scroll(Offset offset) {
    scrollController.offset = offset;
  }

  void _setScrollState() {
    Offset scrollDelta = Offset(
      previousOffset.dx - scrollController.offset.dx,
      previousOffset.dy - scrollController.offset.dy,
    );
    ScrollState scrollState = _getScrolledState(scrollController.offset, scrollDelta);
    scrollController.state = scrollState;
  }

  ScrollState _getScrolledState(Offset newOffset, Offset scrollDelta) {
    bool scrolledVertically = scrollDelta.dy != 0;
    bool scrolledHorizontally = scrollDelta.dx != 0;

    if (scrolledVertically && scrolledHorizontally) {
      return DoubleScrolledState(
        currentOffset: newOffset,
        scrollDelta: scrollDelta,
        scrollSource: ScrollSource.mouse,
      );
    }

    if (scrolledHorizontally) {
      return HorizontalScrolledState(
        currentOffset: newOffset,
        scrollDelta: scrollDelta,
        scrollSource: ScrollSource.mouse,
      );
    }

    return VerticalScrolledState(
      currentOffset: newOffset,
      scrollDelta: scrollDelta,
      scrollSource: ScrollSource.mouse,
    );
  }
}

class MouseScrolledEvent extends ScrolledEvent {
  MouseScrolledEvent({
    required double verticalOffset,
    required double horizontalOffset,
  }) : super(
          verticalOffset: verticalOffset,
          horizontalOffset: horizontalOffset,
          scrollSource: ScrollSource.mouse,
        );

  @override
  Offset prepareScrollOffset() {
    Offset scrollOffset = scrollController.offset.translate(
      horizontalOffset,
      verticalOffset,
    );
    return scrollOffset;
  }
}

class ButtonScrolledEvent extends ScrolledEvent {
  ButtonScrolledEvent({
    required double verticalOffset,
    required double horizontalOffset,
  }) : super(
    verticalOffset: verticalOffset,
    horizontalOffset: horizontalOffset,
    scrollSource: ScrollSource.mouse,
  );

  @override
  Offset prepareScrollOffset() {
    Offset scrollOffset = scrollController.offset.translate(
      horizontalOffset,
      verticalOffset,
    );
    return scrollOffset;
  }
}

class ScrollbarScrolledEvent extends ScrolledEvent {
  ScrollbarScrolledEvent({
    required double verticalOffset,
    required double horizontalOffset,
  }) : super(
          verticalOffset: verticalOffset,
          horizontalOffset: horizontalOffset,
          scrollSource: ScrollSource.mouse,
        );

  @override
  Offset prepareScrollOffset() {
    Offset scrollOffset = Offset(horizontalOffset, verticalOffset);
    return scrollOffset;
  }
}

abstract class DraggedEvent extends ScrollEvent {}
