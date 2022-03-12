import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager.dart';

abstract class StorageEvent {
  void execute(StorageManager storageManager);
}

class FieldEditedEvent extends StorageEvent {
  final CellPosition cellPosition;
  final dynamic value;

  FieldEditedEvent({
    required this.cellPosition,
    required this.value,
  });

  @override
  void execute(StorageManager storageManager) {
    if(storageManager.data[cellPosition.verticalPosition.key] == null) {
      storageManager.data[cellPosition.verticalPosition.key] = <String, dynamic>{};
    }
    storageManager.data[cellPosition.verticalPosition.key]![cellPosition.horizontalPosition.key] = value;
    storageManager.notifyShouldUpdate();
  }


}
