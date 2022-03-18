import 'package:excel_grid/src/manager/scroll_manager/events/scroll_event.dart';
import 'package:excel_grid/src/manager/scroll_manager/states/initial_scroll_state.dart';
import 'package:excel_grid/src/manager/scroll_manager/states/scroll_state.dart';
import 'package:flutter/material.dart';

class ScrollManager extends ChangeNotifier {

  ScrollState state = InitialScrollState();

  Offset offset = const Offset(0, 0);

  double contentWidth = 0;
  double contentHeight = 0;

  int visibleColumnsCount = 0;
  int visibleRowsCount = 0;

  double? _verticalViewport;
  double? _horizontalViewport;

  double get verticalViewport {
    assert(_verticalViewport != null, 'Vertical viewport is not initialized');
    return _verticalViewport!;
  }

  double get horizontalViewport {
    assert(_horizontalViewport != null, 'Horizontal viewport is not initialized');
    return _horizontalViewport!;
  }

  void handleEvent(ScrollEvent event) {
    event.execute(this);
  }

  void onWindowSizeChanged({
    required double maxWidth,
    required double maxHeight,
  }) {
    _verticalViewport = maxHeight;
    _horizontalViewport = maxWidth;
  }

  void notifyShouldUpdate() {
    notifyListeners();
  }
}
