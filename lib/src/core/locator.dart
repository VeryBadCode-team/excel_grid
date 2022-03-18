import 'package:excel_grid/src/manager/autofill_manager/autofill_manager.dart';
import 'package:excel_grid/src/manager/decoration_manager/decoration_manager.dart';
import 'package:excel_grid/src/manager/grid_config_manager/grid_config_manager.dart';
import 'package:excel_grid/src/manager/scroll_manager/scroll_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:get_it/get_it.dart';

final GetIt globalLocator = GetIt.I;

Future<void> initLocator() async {
  globalLocator.registerLazySingleton<SelectionManager>(() => SelectionManager());
  globalLocator.registerLazySingleton<DecorationManager>(() => DecorationManager());
  globalLocator.registerLazySingleton<StorageManager>(() => StorageManager());
  globalLocator.registerLazySingleton<AutofillManager>(() => AutofillManager());
  globalLocator.registerLazySingleton<ScrollManager>(() => ScrollManager());
  globalLocator.registerLazySingleton<GridConfigManager>(() => GridConfigManager());
}
