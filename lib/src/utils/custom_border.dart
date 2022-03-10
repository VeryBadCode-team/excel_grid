import 'package:excel_grid/src/utils/enums/append_border.dart';
import 'package:flutter/material.dart';

class CustomBorder {
  static Border fromAppendBorder({required Set<AppendBorder> visibleBorders, required BorderSide borderSide}) {
    return Border(
      top: visibleBorders.contains(AppendBorder.top) ? borderSide : BorderSide.none,
      bottom: visibleBorders.contains(AppendBorder.bottom) ? borderSide : BorderSide.none,
      left: visibleBorders.contains(AppendBorder.left) ? borderSide : BorderSide.none,
      right: visibleBorders.contains(AppendBorder.right) ? borderSide : BorderSide.none,
    );
  }
}
