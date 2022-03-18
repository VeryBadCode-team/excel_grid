import 'package:excel_grid/src/manager/logging_action_dispatcher.dart';
import 'package:excel_grid/src/manager/logging_shortcut_manager.dart';
import 'package:excel_grid/src/models/excel_shortcuts/excel_shortcuts.dart';
import 'package:excel_grid/src/models/excel_shortcuts/keyboard_shortcuts_config.dart';
import 'package:excel_grid/src/shared/excel_actions/character_cell_activate_action/character_cell_activate_action.dart';
import 'package:excel_grid/src/shared/excel_actions/character_cell_activate_action/character_cell_activate_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ExcelKeyboardListener extends StatefulWidget {
  final Widget child;
  final FocusNode gridFocusNode;
  final KeyboardShortcutsConfig keyboardShortcutsConfig;

  const ExcelKeyboardListener({
    required this.keyboardShortcutsConfig,
    required this.gridFocusNode,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExcelKeyboardListener();

  static _ExcelKeyboardListener of(BuildContext context) {
    final _ExcelKeyboardListener? result = context.findAncestorStateOfType<_ExcelKeyboardListener>();
    if (result != null) {
      return result;
    }
    throw Exception('Cannot get _ExcelKeyboardListener state');
  }
}

class _ExcelKeyboardListener extends State<ExcelKeyboardListener> {
  Set<LogicalKeyboardKey> keysPressed = <LogicalKeyboardKey>{};

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      manager: LoggingShortcutManager(),
      shortcuts: shortcuts,
      child: Actions(
        dispatcher: LoggingActionDispatcher(),
        actions: actions,
        child: Focus(
          focusNode: widget.gridFocusNode,
          autofocus: true,
          onKey: _onKeyPressed,
          child: widget.child,
        ),
      ),
    );
  }

  Map<LogicalKeySet, Intent> get shortcuts {
    Map<LogicalKeySet, Intent> _shortcuts = <LogicalKeySet, Intent>{};
    List<Map<LogicalKeySet, Intent>> shortcutsList =
        widget.keyboardShortcutsConfig.shortcuts.map((ExcelActionKeyboardShortcut e) => e.shortcuts).toList();
    for (Map<LogicalKeySet, Intent> e in shortcutsList) {
      _shortcuts.addAll(e);
    }
    return _shortcuts;
  }

  Map<Type, Action<Intent>> get actions {
    Map<Type, Action<Intent>> _actions = <Type, Action<Intent>>{};
    List<Map<Type, Action<Intent>>> actionsList =
        widget.keyboardShortcutsConfig.shortcuts.map((ExcelActionKeyboardShortcut e) => e.actions).toList();
    for (Map<Type, Action<Intent>> e in actionsList) {
      _actions.addAll(e);
    }
    return _actions;
  }

  KeyEventResult _onKeyPressed(FocusNode node, RawKeyEvent event) {
    if (keysPressed.isEmpty && event.character != null) {
      CharacterCellActivateIntent characterCellActivateIntent =
          CharacterCellActivateIntent(keyCharacterValue: event.character);
      CharacterCellActivateAction characterCellActivateAction = CharacterCellActivateAction();
      characterCellActivateAction.invoke(characterCellActivateIntent);
    }

    if (event is RawKeyDownEvent) {
      keysPressed.add(event.logicalKey);
    } else {
      keysPressed.remove(event.logicalKey);
    }
    return KeyEventResult.ignored;
  }
}
