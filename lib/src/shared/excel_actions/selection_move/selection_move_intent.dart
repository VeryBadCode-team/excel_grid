import 'package:excel_grid/src/shared/excel_actions/move_action/move_intent.dart';
import 'package:flutter/material.dart';

class SelectionMoveUpIntent extends MoveUpIntent {
  @override
  Offset get moveOffset => const Offset(0, -1);
}

class SelectionMoveDownIntent extends MoveUpIntent {
  @override
  Offset get moveOffset => const Offset(0, 1);
}

class SelectionMoveLeftIntent extends MoveUpIntent {
  @override
  Offset get moveOffset => const Offset(-1, 0);
}

class SelectionMoveRightIntent extends MoveUpIntent {
  @override
  Offset get moveOffset => const Offset(1, 0);
}