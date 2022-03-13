import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager.dart';

abstract class StorageEvent {
  void execute(StorageManager storageManager);
}

class SingleCellEditedEvent extends StorageEvent {
  final CellPosition cellPosition;
  final dynamic value;

  SingleCellEditedEvent({
    required this.cellPosition,
    required this.value,
  });

  @override
  void execute(StorageManager storageManager) {
    storageManager.updateCell(cellPosition, value);
    storageManager.notifyShouldUpdate();
  }
}

class MultiCellEditedEvent extends StorageEvent {
  final List<CellValue> cellValues;

  MultiCellEditedEvent({
    required this.cellValues,
  });

  @override
  void execute(StorageManager storageManager) {
    for(CellValue cellValue in cellValues ) {
      storageManager.updateCell(cellValue.cellPosition, cellValue.value);
    }
    storageManager.notifyShouldUpdate();
  }
}

class ClearSelectedEvent extends StorageEvent {
  final List<CellPosition> cells;

  ClearSelectedEvent({
    required this.cells,
  });

  @override
  void execute(StorageManager storageManager) {
    for(CellPosition cellPosition in cells ) {
      storageManager.updateCell(cellPosition, null);
    }
    storageManager.notifyShouldUpdate();
  }
}

