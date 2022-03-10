import 'package:flutter/material.dart';

class CellTheme {
  final double width;
  final double height;
  final Color backgroundColor;
  final BorderSide borderSide;
  final double cellPadding;

  const CellTheme({
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.borderSide,
    required this.cellPadding,
  });
}
