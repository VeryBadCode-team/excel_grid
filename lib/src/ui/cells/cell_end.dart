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
