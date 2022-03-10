import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:flutter/material.dart';

class InheritedExcelTheme extends InheritedWidget {
  final ExcelGridTheme theme;

  /// Creates [InheritedWidget] from a provided [types.User] class
  const InheritedExcelTheme({
    required this.theme,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);
  

  static InheritedExcelTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedExcelTheme>()!;
  }

  @override
  bool updateShouldNotify(InheritedExcelTheme oldWidget) =>
      theme.hashCode != oldWidget.theme.hashCode;
}