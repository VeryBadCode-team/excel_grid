import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/storage_manager/events/storage_event.dart';
import 'package:excel_grid/src/models/grid_data/grid_data.dart';
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
    return data[cellPosition.columnPosition.key]?[cellPosition.rowPosition.key];
  }

  List<CellPositionValue> getCellsData(List<CellPosition> cellsPosition) {
    List<CellPositionValue> result = List<CellPositionValue>.empty(growable: true);
    for( CellPosition cellPosition in cellsPosition ) {
      result.add(CellPositionValue(cellPosition: cellPosition, value: getCellData(cellPosition)));
    }
    return result;
  }

  void updateCell(CellPosition cellPosition, CellValue? value) {
    if(data[cellPosition.columnPosition.key] == null) {
      data[cellPosition.columnPosition.key] = <String, CellValue>{};
    }
    if( value == null ) {
      data[cellPosition.columnPosition.key]!.remove(cellPosition.rowPosition.key);
    } else {
      data[cellPosition.columnPosition.key]![cellPosition.rowPosition.key] = value;
    }
  }

  void handleEvent(StorageEvent storageEvent) {
    storageEvent.invoke(this);
  }

  void notifyShouldUpdate() {
    notifyListeners();
  }
}