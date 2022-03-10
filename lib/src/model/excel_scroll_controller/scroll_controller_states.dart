import 'package:flutter/cupertino.dart';

enum ScrollSource {
  scrollbar,
  mouse,
  keyboard,
}

abstract class ScrollState {}

class DefaultScrollState extends ScrollState {}

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

class DoubleScrolledState extends ScrolledState {
  DoubleScrolledState({required ScrollSource scrollSource, required Offset currentOffset, required Offset scrollDelta})
      : super(scrollSource: scrollSource, currentOffset: currentOffset, scrollDelta: scrollDelta);
}
