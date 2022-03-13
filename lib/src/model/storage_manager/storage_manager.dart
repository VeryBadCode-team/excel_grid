import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/model/grid_data.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager_events.dart';
import 'package:flutter/cupertino.dart';

class CellValue {
  final CellPosition cellPosition;
  final String? value;

  CellValue({required this.cellPosition, required this.value,});


}

class StorageManager extends ChangeNotifier {
  Map<String, Map<String, dynamic>> data = <String, Map<String, dynamic>>{};

  void init(GridData initialData) {
    data = initialData.data;
    notifyListeners();
  }

  dynamic getDataOnPosition(CellPosition cellPosition) {
    return data[cellPosition.verticalPosition.key]?[cellPosition.horizontalPosition.key];
  }

  void updateCell(CellPosition cellPosition, String? value) {
    if(data[cellPosition.verticalPosition.key] == null) {
      data[cellPosition.verticalPosition.key] = <String, dynamic>{};
    }
    if( value == null ) {
      data[cellPosition.verticalPosition.key]!.remove(cellPosition.horizontalPosition.key);
    } else {
      data[cellPosition.verticalPosition.key]![cellPosition.horizontalPosition.key] = value;
    }
  }

  void updateCellsValues(List<CellValue> cellValues) {
    for( CellValue cellValue in cellValues ) {

    }
  }

  void handleEvent(StorageEvent storageEvent) {
    print('Handle event $storageEvent');
    storageEvent.execute(this);
  }

  void notifyShouldUpdate() {
    notifyListeners();
  }
}