import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/title_cell_theme/title_cell_theme.dart';
import 'package:excel_grid/src/manager/decoration_manager/decoration_manager.dart';
import 'package:excel_grid/src/models/custom_border.dart';
import 'package:excel_grid/src/shared/enums/append_border.dart';
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
    TitleCellTheme titleCellTheme = globalLocator<DecorationManager>().theme.titleCellTheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: titleCellTheme.backgroundColor,
          border: CustomBorder.fromAppendBorder(
            visibleBorders: visibleBorders,
            borderSide: titleCellTheme.borderSide,
          ),
        ),
        child: child,
      ),
    );
  }
}
