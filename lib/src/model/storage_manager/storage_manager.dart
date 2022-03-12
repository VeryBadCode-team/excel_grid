import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/model/grid_data.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager_events.dart';
import 'package:flutter/cupertino.dart';

class StorageManager extends ChangeNotifier {
  Map<String, Map<String, dynamic>> data = <String, Map<String, dynamic>>{};

  void init(GridData initialData) {
    data = initialData.data;
    notifyListeners();
  }

  dynamic getDataOnPosition(CellPosition cellPosition) {
    return data[cellPosition.verticalPosition.key]?[cellPosition.horizontalPosition.key];
  }

  void handleEvent(StorageEvent storageEvent) {
    print('Handle event $storageEvent');
    storageEvent.execute(this);
  }

  void notifyShouldUpdate() {
    notifyListeners();
  }
}