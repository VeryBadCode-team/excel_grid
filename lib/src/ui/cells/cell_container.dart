import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/model/autofill_manager/autofill_manager.dart';
import 'package:excel_grid/src/model/autofill_manager/autofill_manager_events.dart';
import 'package:excel_grid/src/utils/enums/append_border.dart';
import 'package:flutter/material.dart';

class CellContainer extends StatelessWidget {
  final bool readOnly;
  final Widget child;
  final double width;
  final double height;
  final bool hasFocus;
  final bool canAutofill;
  final bool isEditing;
  final bool isSelectedCell;
  final bool isStartSelectionCell;
  final bool isEndSelectionCell;
  final ExcelGridTheme theme;
  final Set<AppendBorder> multiSelectionBorder;
  final Set<AppendBorder> autofillBorder;
  final CellPosition cellPosition;

  const CellContainer({
    required this.cellPosition,
    required this.readOnly,
    required this.width,
    required this.height,
    required this.hasFocus,
    required this.isEditing,
    required this.isSelectedCell,
    required this.child,
    required this.canAutofill,
    required this.theme,
    required this.isStartSelectionCell,
    required this.isEndSelectionCell,
    required this.multiSelectionBorder,
    required this.autofillBorder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: _boxDecoration(),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              clipBehavior: Clip.hardEdge,
              height: height,
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(),
              child: child,
            ),
          ),
          if (canAutofill)
            Positioned(
              bottom: 0,
              right: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.cell,
                child: GestureDetector(
                  onPanStart: (_) {
                    AutofillManager autofillManager = globalLocator<AutofillManager>();
                    autofillManager.handleEvent(AutofillStarted(cellPosition));
                  },
                  onPanEnd: (_) {
                    AutofillManager autofillManager = globalLocator<AutofillManager>();
                    autofillManager.handleEvent(AutofillEnd());
                  },
                  child: Container(
                    height: 6,
                    width: 6,
                    color: theme.selectionTheme.primaryBorderSide.color,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    Border defaultBorder = Border(
      top: theme.selectionTheme.primaryBorderSide.copyWith(
        color: Colors.transparent,
      ),
      left: theme.selectionTheme.primaryBorderSide.copyWith(
        color: Colors.transparent,
      ),
      right: theme.cellTheme.borderSide,
      bottom: theme.cellTheme.borderSide,
    );
    if (autofillBorder.isNotEmpty) {
      return BoxDecoration(
        color: Colors.white,
        border: Border(
          top: autofillBorder.contains(AppendBorder.top)
              ? const BorderSide(width: 0.5, color: Colors.black)
              : defaultBorder.top,
          bottom: autofillBorder.contains(AppendBorder.bottom)
              ? const BorderSide(width: 0.5, color: Colors.black)
              : defaultBorder.bottom,
          left: autofillBorder.contains(AppendBorder.left)
              ? const BorderSide(width: 0.5, color: Colors.black)
              : defaultBorder.left,
          right: autofillBorder.contains(AppendBorder.right)
              ? const BorderSide(width: 0.5, color: Colors.black)
              : defaultBorder.right,
        ),
      );
    }
    if (isStartSelectionCell) {
      return BoxDecoration(
        color: theme.selectionTheme.backgroundColor,
        boxShadow: isEditing
            ? <BoxShadow>[
                const BoxShadow(
                  color: Color(0x3c404326),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(0, 0),
                ),
              ]
            : null,
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
                ? theme.selectionTheme.primaryBorderSide.copyWith(width: 0.5)
                : theme.selectionTheme.primaryBorderSide.copyWith(
                    color: Colors.transparent,
                  ),
            bottom: multiSelectionBorder.contains(AppendBorder.bottom)
                ? theme.selectionTheme.primaryBorderSide.copyWith(width: 0.5)
                : theme.cellTheme.borderSide,
            left: multiSelectionBorder.contains(AppendBorder.left)
                ? theme.selectionTheme.primaryBorderSide.copyWith(width: 0.5)
                : theme.selectionTheme.primaryBorderSide.copyWith(
                    color: Colors.transparent,
                  ),
            right: multiSelectionBorder.contains(AppendBorder.right)
                ? theme.selectionTheme.primaryBorderSide.copyWith(width: 0.5)
                : theme.cellTheme.borderSide),
      );
    }

    return BoxDecoration(
      color: Colors.white,
      border: defaultBorder,
    );
  }
}
