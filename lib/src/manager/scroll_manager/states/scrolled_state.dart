
import 'package:excel_grid/src/manager/scroll_manager/models/scroll_source.dart';
import 'package:excel_grid/src/manager/scroll_manager/states/scroll_state.dart';
import 'package:flutter/material.dart';

abstract class ScrolledState extends ScrollState {
  final ScrollSource scrollSource;
  final Offset currentOffset;
  final Offset scrollDelta;

  ScrolledState({
    required this.scrollSource,
    required this.currentOffset,
    required this.scrollDelta,
  });
}

class VerticalScrolledState extends ScrolledState {
  VerticalScrolledState(
      {required ScrollSource scrollSource, required Offset currentOffset, required Offset scrollDelta})
      : super(scrollSource: scrollSource, currentOffset: currentOffset, scrollDelta: scrollDelta);
}

class HorizontalScrolledState extends ScrolledState {
  HorizontalScrolledState(
      {required ScrollSource scrollSource, required Offset currentOffset, required Offset scrollDelta})
      : super(scrollSource: scrollSource, currentOffset: currentOffset, scrollDelta: scrollDelta);
}

class TwoDirectionScrolledState extends ScrolledState {
  TwoDirectionScrolledState({required ScrollSource scrollSource, required Offset currentOffset, required Offset scrollDelta})
      : super(scrollSource: scrollSource, currentOffset: currentOffset, scrollDelta: scrollDelta);
}
