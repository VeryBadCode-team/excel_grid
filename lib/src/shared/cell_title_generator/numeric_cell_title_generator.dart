import 'package:excel_grid/src/shared/cell_title_generator/cell_title_generator.dart';

class NumericCellTitleGenerator extends CellTitleGenerator {
  const NumericCellTitleGenerator() : super();

  @override
  String getTitle(int index) {
   return '$index';
  }
}