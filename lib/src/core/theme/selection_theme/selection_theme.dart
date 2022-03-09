import 'package:flutter/cupertino.dart';

class SelectionTheme {
  final BorderSide primaryBorderSide;
  final BorderSide secondaryBorderSide;
  final Color backgroundColor;
  final Color selectorColor;

  const SelectionTheme({
    required this.primaryBorderSide,
    required this.secondaryBorderSide,
    required this.backgroundColor,
    required this.selectorColor,
  });
}
