import 'package:excel_grid/src/model/excel_scroll_controller/excel_scroll_controller.dart';
import 'package:excel_grid/src/model/grid_config.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:get_it/get_it.dart';

final GetIt globalLocator = GetIt.I;

Future<void> initLocator() async {
  globalLocator.registerLazySingleton<SelectionController>(() => SelectionController());
  globalLocator.registerLazySingleton<ExcelScrollController>(() => ExcelScrollController());
  globalLocator.registerLazySingleton<GridConfig>(() => GridConfig());
}
