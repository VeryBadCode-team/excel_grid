import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/dto/grid_position.dart';
import 'package:excel_grid/src/model/grid_config.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';

abstract class SelectionEvent {
  void execute(SelectionController selectionController);
}

class SingleCellSelectEvent extends SelectionEvent {
  final CellPosition cellPosition;

  SingleCellSelectEvent(this.cellPosition);

  @override
  void execute(SelectionController selectionController) {
    selectionController.state = SingleSelectedState(cellPosition);
    selectionController.notifyShouldUpdate();
  }
}

class MultiCellSelectStartEvent extends SelectionEvent {
  final CellPosition fromPosition;

  MultiCellSelectStartEvent({
    required this.fromPosition,
  });

  @override
  void execute(SelectionController selectionController) {
    selectionController.state = MultiSelectedOngoingState(
      from: fromPosition,
      to: fromPosition,
    );
    selectionController.notifyShouldUpdate();
  }
}

class MultiCellSelectUpdateEvent extends SelectionEvent {
  final CellPosition toPosition;

  MultiCellSelectUpdateEvent(this.toPosition);

  @override
  void execute(SelectionController selectionController) {
    selectionController.state = MultiSelectedOngoingState(
      from: (selectionController.state as MultiSelectedOngoingState).from,
      to: toPosition,
    );

    selectionController.notifyShouldUpdate();
  }
}

class MultiCellSelectEndEvent extends SelectionEvent {
  MultiCellSelectEndEvent();

  @override
  void execute(SelectionController selectionController) {
    selectionController.state = MultiSelectedEndState(
      from: (selectionController.state as MultiSelectedOngoingState).from,
      to: (selectionController.state as MultiSelectedOngoingState).to,
    );
    selectionController.notifyShouldUpdate();
  }
}

class SelectRowEvent extends MultiCellSelectEndEvent {
  final GridPosition rowPosition;

  SelectRowEvent(this.rowPosition) : super();

  @override
  void execute(SelectionController selectionController) {
    GridConfig gridConfig = globalLocator<GridConfig>();
    selectionController.state = RowSelectedState(
      from: CellPosition(
        horizontalPosition: GridPosition(
          key: gridConfig.horizontalCellTitleGenerator.getTitle(1),
          index: 1,
        ),
        verticalPosition: rowPosition,
      ),
      to: CellPosition(
        horizontalPosition: GridPosition(
          key: gridConfig.horizontalCellTitleGenerator.getTitle(gridConfig.columnsCount),
          index: gridConfig.columnsCount,
        ),
        verticalPosition: rowPosition,
      ),
    );
    selectionController.notifyShouldUpdate();
  }
}

class SelectMulitRowStartEvent extends MultiCellSelectEndEvent {
  final GridPosition fromPosition;
  final GridPosition toPosition;

  SelectMulitRowStartEvent({
    required this.fromPosition,
  })  : toPosition = fromPosition,
        super();

  @override
  void execute(SelectionController selectionController) {
    GridConfig gridConfig = globalLocator<GridConfig>();
    selectionController.state = RowSelectOngoingState(
      from: CellPosition(
        horizontalPosition: GridPosition(
          key: gridConfig.horizontalCellTitleGenerator.getTitle(1),
          index: 1,
        ),
        verticalPosition: fromPosition,
      ),
      to: CellPosition(
        horizontalPosition: GridPosition(
          key: gridConfig.horizontalCellTitleGenerator.getTitle(gridConfig.columnsCount),
          index: gridConfig.columnsCount,
        ),
        verticalPosition: toPosition,
      ),
    );
    selectionController.notifyShouldUpdate();
  }
}

class SelectMulitRowUpdateEvent extends MultiCellSelectEndEvent {
  final GridPosition toPosition;

  SelectMulitRowUpdateEvent(this.toPosition) : super();

  @override
  void execute(SelectionController selectionController) {
    GridConfig gridConfig = globalLocator<GridConfig>();
    selectionController.state = RowSelectOngoingState(
      from: (selectionController.state as RowSelectOngoingState).from,
      to: CellPosition(
        horizontalPosition: GridPosition(
          key: gridConfig.horizontalCellTitleGenerator.getTitle(gridConfig.columnsCount),
          index: gridConfig.columnsCount,
        ),
        verticalPosition: toPosition,
      ),
    );
    selectionController.notifyShouldUpdate();
  }
}

class SelectMulitRowEndEvent extends SelectionEvent {
  SelectMulitRowEndEvent();

  @override
  void execute(SelectionController selectionController) {
    selectionController.state = RowSelectEndState(
      from: (selectionController.state as RowSelectOngoingState).from,
      to: (selectionController.state as RowSelectOngoingState).to,
    );
    selectionController.notifyShouldUpdate();
  }
}

class SelectColumnEvent extends MultiCellSelectEndEvent {
  final GridPosition columnPosition;

  SelectColumnEvent(this.columnPosition) : super();

  @override
  void execute(SelectionController selectionController) {
    GridConfig gridConfig = globalLocator<GridConfig>();
    selectionController.state = ColumnSelectedState(
      from: CellPosition(
        horizontalPosition: columnPosition,
        verticalPosition: GridPosition(
          key: gridConfig.verticalCellTitleGenerator.getTitle(1),
          index: 1,
        ),
      ),
      to: CellPosition(
        horizontalPosition: columnPosition,
        verticalPosition: GridPosition(
          key: gridConfig.verticalCellTitleGenerator.getTitle(gridConfig.rowsCount),
          index: gridConfig.rowsCount,
        ),
      ),
    );
    selectionController.notifyShouldUpdate();
  }
}

class SelectMulitColumnStartEvent extends MultiCellSelectEndEvent {
  final GridPosition fromPosition;
  final GridPosition toPosition;

  SelectMulitColumnStartEvent({
    required this.fromPosition,
  })  : toPosition = fromPosition,
        super();

  @override
  void execute(SelectionController selectionController) {
    GridConfig gridConfig = globalLocator<GridConfig>();
    selectionController.state = ColumnSelectOngoingState(
      from: CellPosition(
        horizontalPosition: fromPosition,
        verticalPosition: GridPosition(
          key: gridConfig.verticalCellTitleGenerator.getTitle(1),
          index: 1,
        ),
      ),
      to: CellPosition(
        horizontalPosition: toPosition,
        verticalPosition: GridPosition(
          key: gridConfig.verticalCellTitleGenerator.getTitle(gridConfig.rowsCount),
          index: gridConfig.columnsCount,
        ),
      ),
    );
    selectionController.notifyShouldUpdate();
  }
}

class SelectMulitColumnUpdateEvent extends MultiCellSelectEndEvent {
  final GridPosition toPosition;

  SelectMulitColumnUpdateEvent(this.toPosition) : super();

  @override
  void execute(SelectionController selectionController) {
    GridConfig gridConfig = globalLocator<GridConfig>();
    selectionController.state = ColumnSelectOngoingState(
      from: (selectionController.state as ColumnSelectOngoingState).from,
      to: CellPosition(
        horizontalPosition: toPosition,
        verticalPosition: GridPosition(
          key: gridConfig.verticalCellTitleGenerator.getTitle(gridConfig.rowsCount),
          index: gridConfig.rowsCount,
        ),
      ),
    );
    selectionController.notifyShouldUpdate();
  }
}

class SelectMulitColumnEndEvent extends SelectionEvent {
  SelectMulitColumnEndEvent();

  @override
  void execute(SelectionController selectionController) {
    selectionController.state = ColumnSelectEndState(
      from: (selectionController.state as ColumnSelectOngoingState).from,
      to: (selectionController.state as ColumnSelectOngoingState).to,
    );
    selectionController.notifyShouldUpdate();
  }
}

class SelectAllEvent extends MultiCellSelectEndEvent {
  @override
  void execute(SelectionController selectionController) {
    GridConfig gridConfig = globalLocator<GridConfig>();
    selectionController.state = SelectedAllState(
      from: CellPosition(
        horizontalPosition: GridPosition(
          key: gridConfig.horizontalCellTitleGenerator.getTitle(1),
          index: 1,
        ),
        verticalPosition: GridPosition(
          key: gridConfig.verticalCellTitleGenerator.getTitle(1),
          index: 1,
        ),
      ),
      to: CellPosition(
        horizontalPosition: GridPosition(
          key: gridConfig.horizontalCellTitleGenerator.getTitle(gridConfig.columnsCount),
          index: gridConfig.columnsCount,
        ),
        verticalPosition: GridPosition(
          key: gridConfig.verticalCellTitleGenerator.getTitle(gridConfig.rowsCount),
          index: gridConfig.rowsCount,
        ),
      ),
    );
    selectionController.notifyShouldUpdate();
  }
}

class CellEditingEvent extends SingleCellSelectEvent {
  CellEditingEvent(CellPosition cellPosition) : super(cellPosition);

  @override
  void execute(SelectionController selectionController) {
    selectionController.state = CellEditingState(cellPosition);
    selectionController.notifyShouldUpdate();
  }
}
