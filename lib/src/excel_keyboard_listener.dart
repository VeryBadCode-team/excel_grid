import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/dto/grid_position.dart';
import 'package:excel_grid/src/model/grid_config.dart';
import 'package:excel_grid/src/model/logging_action_dispatcher.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_events.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager_events.dart';
import 'package:excel_grid/src/ui/cells/values/cell_value.dart';
import 'package:excel_grid/src/utils/generators/csv_generator.dart';
import 'package:excel_grid/src/utils/generators/csv_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'model/logging_shortcut_manager.dart';

class SelectAllIntent extends Intent {}

class NewValueIntent extends Intent {
  const NewValueIntent();
}

class SelectAllAction extends Action<SelectAllIntent> {
  @override
  Object? invoke(SelectAllIntent intent) {
    SelectionController selectionController = globalLocator<SelectionController>();
    selectionController.handleEvent(SelectAllEvent());
    return null;
  }
}

class NewValueAction extends Action<NewValueIntent> {
  @override
  Object? invoke(NewValueIntent intent) {
    print(intent);
    SelectionController selectionController = globalLocator<SelectionController>();
    SelectionState selectionState = selectionController.state;
    if (selectionState is CellEditingState) {
      return null;
    }
    if (selectionState is SingleSelectedState) {
      // selectionController.handleEvent(
      //     KeyPressedEvent(cellPosition: selectionState.cellPosition, keyValue: intent.logicalKey.keyLabel,));
    }
    if (selectionState is MultiSelectedState) {
      // selectionController
      //     .handleEvent(KeyPressedEvent(cellPosition: selectionState.from, keyValue: intent.logicalKey.keyLabel,));
    }

    return null;
  }
}

abstract class MoveIntent extends Intent {
  Offset get moveOffset;
}

class MoveUpIntent extends MoveIntent {
  @override
  Offset get moveOffset => const Offset(0, -1);
}

class MoveDownIntent extends MoveIntent {
  @override
  Offset get moveOffset => const Offset(0, 1);
}

class MoveLeftIntent extends MoveIntent {
  @override
  Offset get moveOffset => const Offset(-1, 0);
}

class MoveRightIntent extends MoveIntent {
  @override
  Offset get moveOffset => const Offset(1, 0);
}

class MoveSelectionUpIntent extends MoveUpIntent {
  @override
  Offset get moveOffset => const Offset(0, -1);
}

class MoveSelectionDownIntent extends MoveUpIntent {
  @override
  Offset get moveOffset => const Offset(0, 1);
}

class MoveSelectionLeftIntent extends MoveUpIntent {
  @override
  Offset get moveOffset => const Offset(-1, 0);
}

class MoveSelectionRightIntent extends MoveUpIntent {
  @override
  Offset get moveOffset => const Offset(1, 0);
}

class MoveAction extends Action<MoveIntent> {
  @override
  bool consumesKey(Intent intent) {
    SelectionController selectionController = globalLocator<SelectionController>();
    SelectionState selectionState = selectionController.state;
    if (selectionState is CellEditingState) {
      print('consumes key: false');
      return false;
    }
    print('consumes key: true');
    return true;
  }

  @override
  void invoke(MoveIntent intent) {
    SelectionController selectionController = globalLocator<SelectionController>();
    CellPosition? movedCellPosition = calcMovedCell(intent);
    if (movedCellPosition != null) {
      selectionController.handleEvent(SingleCellSelectEvent(movedCellPosition));
    }
  }

  CellPosition? calcMovedCell(MoveIntent intent) {
    GridConfig gridConfig = globalLocator<GridConfig>();
    SelectionController selectionController = globalLocator<SelectionController>();
    SelectionState selectionState = selectionController.state;
    if (selectionState is CellEditingState) {
      return null;
    }
    CellPosition currentCell = selectionCell;
    int newX = currentCell.horizontalPosition.index + intent.moveOffset.dx.toInt();
    int newY = currentCell.verticalPosition.index + intent.moveOffset.dy.toInt();
    if (newX < 1 || newY < 1 || newX > gridConfig.columnsCount || newY > gridConfig.rowsCount) {
      return null;
    }
    CellPosition newCellPosition = CellPosition(
      verticalPosition: gridConfig.generateCellVertical(newY),
      horizontalPosition: gridConfig.generateCellHorizontal(newX),
    );
    return newCellPosition;
  }

  CellPosition get selectionCell {
    SelectionController selectionController = globalLocator<SelectionController>();
    return selectionController.state.focusedCell;
  }
}

class MoveSelectionAction extends MoveAction {
  @override
  void invoke(MoveIntent intent) {
    SelectionController selectionController = globalLocator<SelectionController>();
    CellPosition? movedCellPosition = calcMovedCell(intent);
    if (movedCellPosition != null) {
      selectionController.state = MultiSelectedEndState(
        from: selectionController.state.focusedCell,
        to: movedCellPosition,
      );
      selectionController.notifyShouldUpdate();
    }
  }

  @override
  CellPosition get selectionCell {
    SelectionController selectionController = globalLocator<SelectionController>();
    SelectionState state = selectionController.state;
    if (state is MultiSelectedState) {
      return state.to;
    }
    return selectionController.state.focusedCell;
  }
}

class CellFocusIntent extends Intent {}

class CellFocusAction extends Action<CellFocusIntent> {
  @override
  void invoke(CellFocusIntent intent) {
    SelectionController selectionController = globalLocator<SelectionController>();
    SelectionState selectionState = selectionController.state;
    if (selectionState is! CellEditingState) {
      selectionController.handleEvent(CellEditingEvent(selectionState.focusedCell));
    } else {
      selectionController.handleEvent(SingleCellSelectEvent(selectionState.focusedCell));
    }
  }
}

class CopyIntent extends Intent {}

class CopyAction extends Action<CopyIntent> {
  @override
  void invoke(CopyIntent intent) {
    SelectionController selectionController = globalLocator<SelectionController>();
    StorageManager storageManager = globalLocator<StorageManager>();
    CsvGenerator selectionCsvGenerator = CsvGenerator.fromCells(
      selectedCells: selectionController.state.selectedCellsByRows,
      storageManager: storageManager,
    );
    String selectedText = selectionCsvGenerator.generateString(seperator: '\t');
    Clipboard.setData(ClipboardData(text: selectedText));
  }
}

class DeleteIntent extends Intent {}

class DeleteAction extends Action<DeleteIntent> {
  @override
  void invoke(DeleteIntent intent) {
    SelectionController selectionController = globalLocator<SelectionController>();
    StorageManager storageManager = globalLocator<StorageManager>();
    storageManager.handleEvent(ClearSelectedEvent(cells: selectionController.state.selectedCellsMerged));
  }
}

class CutIntent extends Intent {}

class CutAction extends Action<CutIntent> {
  @override
  void invoke(CutIntent intent) {
    CopyAction copyAction = CopyAction();
    copyAction.invoke(CopyIntent());

    DeleteAction deleteAction = DeleteAction();
    deleteAction.invoke(DeleteIntent());
  }
}

class PasteIntent extends Intent {}

class PasteAction extends Action<PasteIntent> {
  @override
  Future<void> invoke(PasteIntent intent) async {
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      SelectionController selectionController = globalLocator<SelectionController>();
      StorageManager storageManager = globalLocator<StorageManager>();
      GridConfig gridConfig = globalLocator<GridConfig>();
      String clipboardValue = clipboardData.text!;
      List<List<dynamic>> lines = CsvParser.fromCsv(clipboardValue, seperator: '\t');
      List<CellPositionValue> cellValues = List<CellPositionValue>.empty(growable: true);
      CellPosition currentCell = selectionController.state.focusedCell;
      for (int y = 0; y < lines.length; y++) {
        GridPosition positionY = gridConfig.generateCellVertical(currentCell.verticalPosition.index + y);
        List<dynamic> words = lines[y];
        for (int x = 0; x < words.length; x++) {
          GridPosition positionX = gridConfig.generateCellHorizontal(currentCell.horizontalPosition.index + x);
          cellValues.add(
            CellPositionValue(
              cellPosition: CellPosition(
                verticalPosition: positionY,
                horizontalPosition: positionX,
              ),
              value: CellValue.assign(words[x]),
            ),
          );
        }
      }
      CellPosition firstSelectedPosition = cellValues.first.cellPosition;
      CellPosition lastSelectedPosition = cellValues.last.cellPosition;
      selectionController.handleEvent(MultiSelectEvent(fromPosition: firstSelectedPosition, toPosition: lastSelectedPosition));
      storageManager.handleEvent(MultiCellEditedEvent(cellValues: cellValues));
    }
  }
}

class ExcelKeyboardListener extends StatefulWidget {
  final Widget child;
  final FocusNode gridFocusNode;

  const ExcelKeyboardListener({
    required this.gridFocusNode,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExcelKeyboardListener();
}

class _ExcelKeyboardListener extends State<ExcelKeyboardListener> {
  Set<LogicalKeyboardKey> keysPressed = <LogicalKeyboardKey>{};

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      manager: LoggingShortcutManager(),
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA): SelectAllIntent(),

        ///
        LogicalKeySet(LogicalKeyboardKey.arrowUp): MoveUpIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): MoveDownIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): MoveLeftIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): MoveRightIntent(),

        ///
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowUp): MoveSelectionUpIntent(),
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowDown): MoveSelectionDownIntent(),
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowLeft): MoveSelectionLeftIntent(),
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowRight): MoveSelectionRightIntent(),

        ///
        LogicalKeySet(LogicalKeyboardKey.enter): CellFocusIntent(),
        LogicalKeySet(LogicalKeyboardKey.delete): DeleteIntent(),
        LogicalKeySet(LogicalKeyboardKey.copy): CopyIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC): CopyIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyX): CutIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyV): PasteIntent(),
      },
      child: Actions(
        dispatcher: LoggingActionDispatcher(),
        actions: <Type, Action<Intent>>{
          SelectAllIntent: SelectAllAction(),
          MoveIntent: MoveAction(),
          MoveUpIntent: MoveAction(),
          MoveDownIntent: MoveAction(),
          MoveLeftIntent: MoveAction(),
          MoveRightIntent: MoveAction(),
          MoveSelectionUpIntent: MoveSelectionAction(),
          MoveSelectionDownIntent: MoveSelectionAction(),
          MoveSelectionLeftIntent: MoveSelectionAction(),
          MoveSelectionRightIntent: MoveSelectionAction(),
          CellFocusIntent: CellFocusAction(),
          CopyIntent: CopyAction(),
          DeleteIntent: DeleteAction(),
          CutIntent: CutAction(),
          PasteIntent: PasteAction(),
        },
        child: Focus(
          focusNode: widget.gridFocusNode,
          autofocus: true,
          onKey: (FocusNode node, RawKeyEvent event) {
            if (keysPressed.isEmpty && event.character != null) {
              final SelectionController selectionController = globalLocator<SelectionController>();
              SelectionState selectionState = selectionController.state;
              if (selectionState is! CellEditingState) {
                if (selectionState is SingleSelectedState) {
                  selectionController.handleEvent(
                      KeyPressedEvent(cellPosition: selectionState.cellPosition, keyValue: event.character!));
                }
                if (selectionState is MultiSelectedState) {
                  selectionController
                      .handleEvent(KeyPressedEvent(cellPosition: selectionState.from, keyValue: event.character!));
                }
              }
            }

            if (event is RawKeyDownEvent) {
              keysPressed.add(event.logicalKey);
            } else {
              keysPressed.remove(event.logicalKey);
            }
            return KeyEventResult.ignored;
          },
          child: widget.child,
        ),
      ),
    );
  }
}
