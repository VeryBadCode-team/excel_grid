import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/manager/decoration_manager/decoration_manager.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/scroll_manager/models/scroll_source.dart';
import 'package:excel_grid/src/manager/scroll_manager/scroll_manager.dart';
import 'package:excel_grid/src/manager/scroll_manager/states/scroll_state.dart';
import 'package:excel_grid/src/manager/scroll_manager/states/scrolled_state.dart';
import 'package:flutter/material.dart';

abstract class ScrollEvent {
  late final ScrollManager scrollManager;
  final ScrollSource scrollSource;
  final double verticalOffset;
  final double horizontalOffset;
  Offset previousOffset = const Offset(0, 0);

  ScrollEvent({
    required this.scrollSource,
    required this.verticalOffset,
    required this.horizontalOffset,
  });

  void execute(ScrollManager scrollManager) {
    previousOffset = scrollManager.offset;
    this.scrollManager = scrollManager;
    Offset scrollOffset = prepareScrollOffset();
    scrollOffset = _getLimitedOffset(scrollOffset);
    _scroll(scrollOffset);
    _setScrollState();

    scrollManager.notifyShouldUpdate();
  }

  Offset prepareScrollOffset();

  Offset _getLimitedOffset(Offset scrollOffset) {
    GridConfigManager gridConfigManager = globalLocator<GridConfigManager>();
    DecorationManager decorationManager = globalLocator<DecorationManager>();
    final double translatedX = _cutToRange(
      offset: scrollOffset.dx,
      visibleItemsCount: scrollManager.visibleColumnsCount,
      allItemsCount: gridConfigManager.columnsCount,
      additionalItems: decorationManager.theme.horizontalMarginCellsCount,
    );

    final double translatedY = _cutToRange(
      offset: scrollOffset.dy,
      visibleItemsCount: scrollManager.visibleRowsCount,
      allItemsCount: gridConfigManager.rowsCount,
      additionalItems: decorationManager.theme.verticalMarginCellsCount,
    );
    return Offset(
      translatedX,
      translatedY,
    );
  }

  double _cutToRange({
    required double offset,
    required int visibleItemsCount,
    required int allItemsCount,
    required int additionalItems,
  }) {
    if (offset < 0) {
      return 0;
    }
    if (offset + visibleItemsCount >= allItemsCount + additionalItems ) {
      return (allItemsCount + additionalItems - visibleItemsCount).toDouble();
    }
    return offset;
  }

  void _scroll(Offset offset) {
    scrollManager.offset = offset;
  }

  void _setScrollState() {
    Offset scrollDelta = Offset(
      previousOffset.dx - scrollManager.offset.dx,
      previousOffset.dy - scrollManager.offset.dy,
    );
    ScrollState scrollState = _getScrolledState(scrollManager.offset, scrollDelta);
    scrollManager.state = scrollState;
  }

  ScrollState _getScrolledState(Offset newOffset, Offset scrollDelta) {
    bool scrolledVertically = scrollDelta.dy != 0;
    bool scrolledHorizontally = scrollDelta.dx != 0;

    if (scrolledVertically && scrolledHorizontally) {
      return TwoDirectionScrolledState(
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