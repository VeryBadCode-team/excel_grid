import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/autofill_manager/autofill_manager.dart';
import 'package:excel_grid/src/manager/autofill_manager/events/autofill_selection_event.dart';
import 'package:excel_grid/src/models/custom_border.dart';
import 'package:excel_grid/src/shared/enums/append_border.dart';
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
                    autofillManager.handleEvent(StartAutofillSelectionEvent(cellPosition));
                  },
                  onPanEnd: (_) {
                    AutofillManager autofillManager = globalLocator<AutofillManager>();
                    autofillManager.handleEvent(FinishAutofillSelectionEvent());
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
    if (autofillBorder.isNotEmpty) {
      return BoxDecoration(
        color: Colors.white,
        border: CustomBorder.fromAppendBorder(
          visibleBorders: autofillBorder,
          borderSide: const BorderSide(width: 0.5, color: Colors.black),
          defaultBorder: theme.cellTheme.borderSide,
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
        border: CustomBorder.fromAppendBorder(
          visibleBorders: multiSelectionBorder,
          borderSide: theme.selectionTheme.primaryBorderSide.copyWith(width: 0.5),
          defaultBorder: theme.cellTheme.borderSide,
        ),
      );
    }

    return BoxDecoration(
      color: Colors.white,
      border: Border.fromBorderSide(theme.cellTheme.borderSide),
    );
  }
}
