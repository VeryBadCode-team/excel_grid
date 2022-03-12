import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/utils/enums/append_border.dart';
import 'package:flutter/material.dart';

class CellContainer extends StatelessWidget {
  final bool readOnly;
  final Widget child;
  final double width;
  final double height;
  final bool hasFocus;
  final bool isEditing;
  final bool isSelectedCell;
  final bool isStartSelectionCell;
  final bool isEndSelectionCell;
  final double cellPadding;
  final ExcelGridTheme theme;
  final Set<AppendBorder> multiSelectionBorder;

  const CellContainer({
    required this.readOnly,
    required this.width,
    required this.height,
    required this.hasFocus,
    required this.isEditing,
    required this.isSelectedCell,
    required this.cellPadding,
    required this.child,
    required this.theme,
    required this.isStartSelectionCell,
    required this.isEndSelectionCell,
    required this.multiSelectionBorder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: _boxDecoration(),
      child: Padding(
        // New - Customisable cellPadding
        padding: EdgeInsets.symmetric(
          horizontal: cellPadding,
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: height,
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(),
          child: child,
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    if (isEditing) {
      return BoxDecoration(
        color: theme.cellTheme.backgroundColor,
        border: Border.fromBorderSide(theme.selectionTheme.primaryBorderSide),
      );
    } else if (isStartSelectionCell) {
      return BoxDecoration(
        color: theme.selectionTheme.backgroundColor,
        border: Border.fromBorderSide(theme.selectionTheme.primaryBorderSide),
      );
    } else if (isEndSelectionCell) {
      return BoxDecoration(
        color: theme.selectionTheme.backgroundColor,
        border: Border.fromBorderSide(theme.selectionTheme.secondaryBorderSide),
      );
    } else if (isSelectedCell) {
      return BoxDecoration(
        color: theme.selectionTheme.backgroundColor,
        border: Border(
          top: multiSelectionBorder.contains(AppendBorder.top)
              ? theme.selectionTheme.primaryBorderSide
              : theme.selectionTheme.primaryBorderSide.copyWith(
                  color: Colors.transparent,
                ),
          bottom: multiSelectionBorder.contains(AppendBorder.bottom)
              ? theme.selectionTheme.primaryBorderSide
              : theme.cellTheme.borderSide,
          left: multiSelectionBorder.contains(AppendBorder.left)
              ? theme.selectionTheme.primaryBorderSide
              : theme.selectionTheme.primaryBorderSide.copyWith(
                  color: Colors.transparent,
                ),
          right: multiSelectionBorder.contains(AppendBorder.right)
              ? theme.selectionTheme.primaryBorderSide
              : theme.cellTheme.borderSide,
        ),
      );
    } else {
      return BoxDecoration(
        color: Colors.white,
        border: Border(
          top: theme.selectionTheme.primaryBorderSide.copyWith(
            color: Colors.transparent,
          ),
          left: theme.selectionTheme.primaryBorderSide.copyWith(
            color: Colors.transparent,
          ),
          right: theme.cellTheme.borderSide,
          bottom: theme.cellTheme.borderSide,
        ),
      );
    }
  }
}
