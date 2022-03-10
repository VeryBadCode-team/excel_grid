import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/utils/custom_border.dart';
import 'package:excel_grid/src/utils/enums/append_border.dart';
import 'package:flutter/material.dart';

class ScrollbarButton extends StatelessWidget {
  final double size;
  final Widget? child;
  final Set<AppendBorder> visibleBorders;
  final GestureTapCallback? onTap;

  const ScrollbarButton({
    required this.visibleBorders,
    this.child,
    this.onTap,
    this.size = 13,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.backgroundColor,
          border: CustomBorder.fromAppendBorder(
            visibleBorders: visibleBorders,
            borderSide: InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.borderSide,
          ),
        ),
        child: child,
      ),
    );
  }
}
