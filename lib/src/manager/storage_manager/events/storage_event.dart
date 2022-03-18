import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';

abstract class StorageEvent {
  void invoke(StorageManager storageManager);
}
