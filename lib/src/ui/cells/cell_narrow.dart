import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:flutter/cupertino.dart';

class CellNarrow extends StatelessWidget {
  const CellNarrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

}