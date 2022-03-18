import 'package:excel_grid/src/models/excel_shortcuts/excel_shortcuts.dart';
import 'package:excel_grid/src/shared/excel_actions/copy_selection_action/copy_selection_action.dart';
import 'package:excel_grid/src/shared/excel_actions/copy_selection_action/copy_selection_intent.dart';
import 'package:excel_grid/src/shared/excel_actions/cut_selection_action/cut_selection_action.dart';
import 'package:excel_grid/src/shared/excel_actions/cut_selection_action/cut_selection_intent.dart';
import 'package:excel_grid/src/shared/excel_actions/delete_selection_action/delete_selection_action.dart';
import 'package:excel_grid/src/shared/excel_actions/delete_selection_action/delete_selection_intent.dart';
import 'package:excel_grid/src/shared/excel_actions/focused_cell_edit_action/focused_cell_edit_action.dart';
import 'package:excel_grid/src/shared/excel_actions/focused_cell_edit_action/focused_cell_edit_intent.dart';
import 'package:excel_grid/src/shared/excel_actions/move_action/move_action.dart';
import 'package:excel_grid/src/shared/excel_actions/move_action/move_intent.dart';
import 'package:excel_grid/src/shared/excel_actions/paste_action/paste_action.dart';
import 'package:excel_grid/src/shared/excel_actions/paste_action/paste_intent.dart';
import 'package:excel_grid/src/shared/excel_actions/select_all_action/select_all_action.dart';
import 'package:excel_grid/src/shared/excel_actions/select_all_action/select_all_intent.dart';
import 'package:excel_grid/src/shared/excel_actions/selection_move/selection_move_action.dart';
import 'package:excel_grid/src/shared/excel_actions/selection_move/selection_move_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectAllKeyboardShortcut extends ExcelActionKeyboardShortcut {
  const SelectAllKeyboardShortcut() : super();

  @override
  Map<LogicalKeySet, Intent> get shortcuts => <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA): SelectAllIntent(),
      };

  @override
  Map<Type, Action<Intent>> get actions => <Type, Action<Intent>>{
        SelectAllIntent: SelectAllAction(),
      };
}

class NavigationKeyboardShortcut extends ExcelActionKeyboardShortcut {
  const NavigationKeyboardShortcut() : super();

  @override
  Map<LogicalKeySet, Intent> get shortcuts => <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.arrowUp): MoveUpIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): MoveDownIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): MoveLeftIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): MoveRightIntent(),
        LogicalKeySet(LogicalKeyboardKey.tab): MoveRightIntent(),
      };

  @override
  Map<Type, Action<Intent>> get actions => <Type, Action<Intent>>{
        MoveIntent: MoveAction(),
        MoveUpIntent: MoveAction(),
        MoveDownIntent: MoveAction(),
        MoveLeftIntent: MoveAction(),
        MoveRightIntent: MoveAction(),
      };
}

class NavigationSelectionKeyboardShortcut extends ExcelActionKeyboardShortcut {
  const NavigationSelectionKeyboardShortcut() : super();

  @override
  Map<LogicalKeySet, Intent> get shortcuts => <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowUp): SelectionMoveUpIntent(),
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowDown): SelectionMoveDownIntent(),
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowLeft): SelectionMoveLeftIntent(),
        LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowRight): SelectionMoveRightIntent(),
      };

  @override
  Map<Type, Action<Intent>> get actions => <Type, Action<Intent>>{
        SelectionMoveUpIntent: SelectionMoveAction(),
        SelectionMoveDownIntent: SelectionMoveAction(),
        SelectionMoveLeftIntent: SelectionMoveAction(),
        SelectionMoveRightIntent: SelectionMoveAction(),
      };
}

class FocusedCellEditKeyboardShortcut extends ExcelActionKeyboardShortcut {
  const FocusedCellEditKeyboardShortcut() : super();
  
  @override
  Map<LogicalKeySet, Intent> get shortcuts => <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.enter): FocusedCellEditIntent(),
      };

  @override
  Map<Type, Action<Intent>> get actions => <Type, Action<Intent>>{
        FocusedCellEditIntent: FocusedCellEditAction(),
      };
}

class CopySelectionKeyboardShortcut extends ExcelActionKeyboardShortcut {
  const CopySelectionKeyboardShortcut() : super();
  
  @override
  Map<LogicalKeySet, Intent> get shortcuts => <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.copy): CopySelectionIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC): CopySelectionIntent(),
      };

  @override
  Map<Type, Action<Intent>> get actions => <Type, Action<Intent>>{
        CopySelectionIntent: CopySelectionAction(),
      };
}

class DeleteSelectionKeyboardShortcut extends ExcelActionKeyboardShortcut {
  const DeleteSelectionKeyboardShortcut() : super();
  
  @override
  Map<LogicalKeySet, Intent> get shortcuts => <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.delete): DeleteSelectionIntent(),
      };

  @override
  Map<Type, Action<Intent>> get actions => <Type, Action<Intent>>{
        DeleteSelectionIntent: DeleteSelectionAction(),
      };
}

class CutSelectionKeyboardShortcut extends ExcelActionKeyboardShortcut {
  const CutSelectionKeyboardShortcut() : super();
  
  @override
  Map<LogicalKeySet, Intent> get shortcuts => <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyX): CutSelectionIntent(),
      };

  @override
  Map<Type, Action<Intent>> get actions => <Type, Action<Intent>>{
        CutSelectionIntent: CutSelectionAction(),
      };
}

class PasteKeyboardShortcut extends ExcelActionKeyboardShortcut {
  const PasteKeyboardShortcut() : super();
  
  @override
  Map<LogicalKeySet, Intent> get shortcuts => <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyV): PasteIntent(),
      };

  @override
  Map<Type, Action<Intent>> get actions => <Type, Action<Intent>>{
        PasteIntent: PasteAction(),
      };
}
