import 'package:excel_grid/src/shared/enums/append_border.dart';
import 'package:flutter/material.dart';

class CustomBorder {
  static Border fromAppendBorder({required Set<AppendBorder> visibleBorders, required BorderSide borderSide, BorderSide? defaultBorder}) {
    return Border(
      top: visibleBorders.contains(AppendBorder.top) ? borderSide : defaultBorder ?? BorderSide.none,
      bottom: visibleBorders.contains(AppendBorder.bottom) ? borderSide : defaultBorder ?? BorderSide.none,
      left: visibleBorders.contains(AppendBorder.left) ? borderSide : defaultBorder ?? BorderSide.none,
      right: visibleBorders.contains(AppendBorder.right) ? borderSide : defaultBorder ?? BorderSide.none,
    );
  }
}
