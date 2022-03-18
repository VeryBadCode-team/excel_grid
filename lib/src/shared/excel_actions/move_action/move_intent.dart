import 'package:flutter/material.dart';

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
