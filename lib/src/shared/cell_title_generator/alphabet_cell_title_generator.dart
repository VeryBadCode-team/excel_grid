import 'package:excel_grid/src/shared/cell_title_generator/cell_title_generator.dart';

class AlphabetCellTitleGenerator extends CellTitleGenerator {
  const AlphabetCellTitleGenerator() : super();

  @override
  String getTitle(int index) {
   return num2alpha(index - 1);
  }

  String num2alpha(int index) {
    String result = '';
    for(int i = index; i >= 0; i = i ~/ 26 - 1) {
      result = '${String.fromCharCode(i%26 + 0x41)}$result';
    }
    return result;
  }
}
