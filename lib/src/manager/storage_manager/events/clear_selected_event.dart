import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/storage_manager/events/storage_event.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';

class ClearSelectedEvent extends StorageEvent {
  final List<CellPosition> cells;

  ClearSelectedEvent({
    required this.cells,
  });

  @override
  void invoke(StorageManager storageManager) {
    for(CellPosition cellPosition in cells ) {
      storageManager.updateCell(cellPosition, null);
    }
    storageManager.notifyShouldUpdate();
  }
}

