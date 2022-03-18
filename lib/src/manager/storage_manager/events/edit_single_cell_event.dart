import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/storage_manager/events/storage_event.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/ui/cells/values/cell_value.dart';

class EditSingleCellEvent extends StorageEvent {
  final CellPosition cellPosition;
  final dynamic value;

  EditSingleCellEvent({
    required this.cellPosition,
    required this.value,
  });

  @override
  void invoke(StorageManager storageManager) {
    storageManager.updateCell(cellPosition, value != null ? CellValue.assign(value) : null);
    storageManager.notifyShouldUpdate();
  }
}
