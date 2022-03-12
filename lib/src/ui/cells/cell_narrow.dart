import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_events.dart';
import 'package:flutter/cupertino.dart';

class CellNarrow extends StatelessWidget {

  const CellNarrow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SelectionController selectionController = globalLocator<SelectionController>();
    return GestureDetector(
      onTap: () {
        selectionController.handleEvent(SelectAllEvent());
      },
      child: Container(
        width: InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.width,
        height: InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.height,
        decoration: BoxDecoration(
          color: InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.backgroundColor,
          border: Border(
            right: BorderSide(
              width: 4,
              color: InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.borderSide.color,
            ),
            bottom: BorderSide(
              width: 4,
              color: InheritedExcelTheme.of(context).theme.horizontalTitleCellTheme.borderSide.color,
            ),
          ),
        ),
      ),
    );
  }
}
