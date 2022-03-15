import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/model/grid_data.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager_events.dart';
import 'package:excel_grid/src/ui/cells/values/cell_value.dart';
import 'package:flutter/cupertino.dart';

class CellPositionValue {
  final CellPosition cellPosition;
  final CellValue? value;

  CellPositionValue({required this.cellPosition, required this.value,});

  @override
  String toString() {
    return 'CellPositionValue{cellPosition: $cellPosition, value: ${value?.asString}';
  }
}

class StorageManager extends ChangeNotifier {
  Map<String, Map<String, CellValue>> data = <String, Map<String, CellValue>>{};

  void init(GridData initialData) {
    data = initialData.data;
    notifyListeners();
  }

  CellValue? getCellData(CellPosition cellPosition) {
    return data[cellPosition.verticalPosition.key]?[cellPosition.horizontalPosition.key];
  }

  List<CellPositionValue> getCellsData(List<CellPosition> cellsPosition) {
    List<CellPositionValue> result = List<CellPositionValue>.empty(growable: true);
    for( CellPosition cellPosition in cellsPosition ) {
      result.add(CellPositionValue(cellPosition: cellPosition, value: getCellData(cellPosition)));
    }
    return result;
  }

  void updateCell(CellPosition cellPosition, CellValue? value) {
    if(data[cellPosition.verticalPosition.key] == null) {
      data[cellPosition.verticalPosition.key] = <String, CellValue>{};
    }
    if( value == null ) {
      data[cellPosition.verticalPosition.key]!.remove(cellPosition.horizontalPosition.key);
    } else {
      data[cellPosition.verticalPosition.key]![cellPosition.horizontalPosition.key] = value;
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