import 'package:excel_grid/src/manager/storage_manager/events/storage_event.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';

class EditMultipleCellsEvent extends StorageEvent {
  final List<CellPositionValue> cellValues;

  EditMultipleCellsEvent({
    required this.cellValues,
  });

  @override
  void invoke(StorageManager storageManager) {
    for(CellPositionValue cellValue in cellValues ) {
      storageManager.updateCell(cellValue.cellPosition, cellValue.value);
    }
    storageManager.notifyShouldUpdate();
  }
}