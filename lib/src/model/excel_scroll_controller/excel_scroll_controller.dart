import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_events.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_states.dart';
import 'package:flutter/material.dart';

class ExcelScrollController extends ChangeNotifier {

  ScrollState state = DefaultScrollState();

  Offset offset = const Offset(0, 0);

  double contentWidth = 0;
  double contentHeight = 0;

  int visibleColumnsCount = 0;
  int visibleRowsCount = 0;

  double? _verticalViewport;
  double? _horizontalViewport;

  ExcelScrollController();

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
