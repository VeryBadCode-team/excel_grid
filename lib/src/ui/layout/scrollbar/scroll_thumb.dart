import 'package:flutter/cupertino.dart';

class ScrollThumb extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsets margin;

  const ScrollThumb({
    required this.width,
    required this.height,
    required this.margin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: const Color(0xFFDADCE0),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
