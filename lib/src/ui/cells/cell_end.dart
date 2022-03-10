import 'package:excel_grid/src/dto/grid_position.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/excel_scroll_controller.dart';
import 'package:flutter/material.dart';

class CellEnd extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;

  const CellEnd({
    required this.width,
    required this.height,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
    );
  }
}
