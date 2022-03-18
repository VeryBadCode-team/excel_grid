import 'package:excel_grid/src/models/excel_shortcuts/excel_shortcuts.dart';
import 'package:excel_grid/src/models/excel_shortcuts/keyboard_shortcuts_list.dart';

class KeyboardShortcutsConfig {
  final List<ExcelActionKeyboardShortcut> shortcuts;

  const KeyboardShortcutsConfig._(this.shortcuts);

  const KeyboardShortcutsConfig.defaultConfig()
      : shortcuts = const <ExcelActionKeyboardShortcut>[
          SelectAllKeyboardShortcut(),
          NavigationKeyboardShortcut(),
          NavigationSelectionKeyboardShortcut(),
          FocusedCellEditKeyboardShortcut(),
          CopySelectionKeyboardShortcut(),
          DeleteSelectionKeyboardShortcut(),
          CutSelectionKeyboardShortcut(),
          PasteKeyboardShortcut(),
        ];

  const KeyboardShortcutsConfig.customConfig({required this.shortcuts});

  const KeyboardShortcutsConfig.disabled() : shortcuts = const <ExcelActionKeyboardShortcut>[];
}
