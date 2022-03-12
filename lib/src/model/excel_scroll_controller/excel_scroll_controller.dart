import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_events.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/scroll_controller_states.dart';
import 'package:flutter/material.dart';

class ExcelScrollController extends ChangeNotifier {
  late int visibleRows;
  late int visibleColumns;

  ScrollState state = DefaultScrollState();

  Offset offset = const Offset(0, 0);

  double contentWidth = 0;
  double contentHeight = 0;

  double? _verticalViewport;
  double? _horizontalViewport;

  double? _verticalStep;
  double? _horizontalStep;

  ExcelScrollController();

  double get verticalViewport {
    assert(_verticalViewport != null, 'Vertical viewport is not initialized');
    return _verticalViewport!;
  }

  double get horizontalViewport {
    assert(_horizontalViewport != null, 'Horizontal viewport is not initialized');
    return _horizontalViewport!;
  }

  double get verticalStep {
    assert(_verticalStep != null, 'Vertical step is not initialized');
    return _verticalStep!;
  }

  double get horizontalStep {
    assert(_horizontalStep != null, 'Vertical step is not initialized');
    return _horizontalStep!;
  }

  void handleEvent(ScrollEvent event) {
    event.execute(this);
  }

  void init({
    required int visibleRows,
    required int visibleColumns,
  }) {
    this.visibleRows = visibleRows;
    this.visibleColumns = visibleColumns;
  }

  void setVerticalViewport(int rowsCount, double maxScrollOffset) {
    if (maxScrollOffset != _verticalViewport) {
      _verticalViewport = maxScrollOffset;
      _verticalStep = rowsCount / maxScrollOffset;
    }
  }

  void setHorizontalViewport(int columnsCount, double maxScrollOffset) {
    if (maxScrollOffset != _horizontalViewport) {
      _horizontalViewport = maxScrollOffset;
      _horizontalStep = columnsCount / maxScrollOffset;
    }
  }

  void notifyShouldUpdate() {
    notifyListeners();
  }
}
