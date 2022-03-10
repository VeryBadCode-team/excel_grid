import 'package:excel_grid/src/core/theme/excel_grid_theme/excel_grid_theme.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/ui/cells/cell_container.dart';
import 'package:excel_grid/src/ui/cells/types/excel_text_cell.dart';
import 'package:flutter/cupertino.dart';

class CellBuilder extends StatelessWidget {
  const CellBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExcelGridTheme theme = InheritedExcelTheme.of(context).theme;
    return CellContainer(
      height: theme.cellTheme.height,
      width: theme.cellTheme.width,
      cellPadding: theme.cellTheme.cellPadding,
      theme: theme,
      isEditing: false,
      isSelectedCell: false,
      readOnly: false,
      hasFocus: false,
      isStartSelectionCell: false,
      isEndSelectionCell: false,
      child: const ExcelTextCell(),
    );
  }
}