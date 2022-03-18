import 'package:flutter/material.dart';

class LoggingActionDispatcher extends ActionDispatcher {
  @override
  void invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);
  }
}
