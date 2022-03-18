import 'package:flutter/material.dart';

abstract class ExcelActionKeyboardShortcut {
  Map<Type, Action<Intent>> get actions;
  Map<LogicalKeySet, Intent> get shortcuts;
  
  const ExcelActionKeyboardShortcut();
}