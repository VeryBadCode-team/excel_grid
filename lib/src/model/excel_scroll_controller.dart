import 'package:flutter/material.dart';

abstract class ScrollState {}

class DefaultScrollState extends ScrollState {}

class MouseScrollState extends ScrollState {}

class ScrollbarScrollState extends ScrollState {}

class ExcelScrollController extends ChangeNotifier {
  ScrollState state = DefaultScrollState();
  final int maxRows;
  final int maxColumns;

  final int visibleRows;
  final int visibleColumns;

  double contentWidth = 0;
  double contentHeight = 0;

  double verticalViewport = 0;
  double horizontalViewport = 0;

  Offset offsetStep = const Offset(0, 0);

  Offset offset = const Offset(0, 0);

  ExcelScrollController({
    required this.maxRows,
    required this.maxColumns,
    required this.visibleRows,
    required this.visibleColumns,
  });

  void updateMaxVerticalScrollOffset(double newMaxScrollOffset) {
    if (newMaxScrollOffset != verticalViewport) {
      verticalViewport = newMaxScrollOffset;
      offsetStep = Offset(offsetStep.dx, maxRows / newMaxScrollOffset);
    }
  }

  void updateMaxHorizontalScrollOffset(double newMaxScrollOffset) {
    if (newMaxScrollOffset != horizontalViewport) {
      horizontalViewport = newMaxScrollOffset;
      offsetStep = Offset(maxColumns / newMaxScrollOffset, offsetStep.dy);
    }
  }

  void scrollBy(Offset distance) {
    Offset scrollOffset = offset.translate(
      distance.dx,
      distance.dy,
    );

    offset = Offset(
      _parseHorizontalOffset(scrollOffset.dx),
      _parseVerticalOffset(scrollOffset.dy),
    );
    notifyListeners();
  }

  double _parseVerticalOffset(double value) {
    print('$value $maxRows');
    if (value < 0) {
      return 0;
    }
    if (value + visibleRows > maxRows) {
      return (maxRows - visibleRows).toDouble();
    }
    return value;
  }

  double _parseHorizontalOffset(double value) {
    if (value < 0) {
      return 0;
    }
    if (value + visibleColumns > maxColumns) {
      return (maxColumns - visibleColumns).toDouble();
    }
    return value;
  }

  void jump(Offset position) {
    offset = position;
    notifyListeners();
  }
}
