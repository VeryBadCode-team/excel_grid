import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/manager/decoration_manager/decoration_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/events/select_all_event.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:flutter/cupertino.dart';

class CellNarrow extends StatelessWidget {

  const CellNarrow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DecorationManager decorationManager = globalLocator<DecorationManager>();
    SelectionManager selectionManager = globalLocator<SelectionManager>();
    return GestureDetector(
      onTap: () {
        selectionManager.handleEvent(SelectAllEvent());
      },
      child: Container(
        width: decorationManager.theme.rowTitleCellTheme.width,
        height: decorationManager.theme.columnTitleCellTheme.height,
        decoration: BoxDecoration(
          color: decorationManager.theme.titleCellTheme.backgroundColor,
          border: Border(
            right: BorderSide(
              width: 4,
              color: decorationManager.theme.titleCellTheme.borderSide.color,
            ),
            bottom: BorderSide(
              width: 4,
              color: decorationManager.theme.titleCellTheme.borderSide.color,
            ),
          ),
        ),
      ),
    );
  }
}
