import 'package:excel_grid/src/shared/excel_actions/copy_selection_action/copy_selection_action.dart';
import 'package:excel_grid/src/shared/excel_actions/copy_selection_action/copy_selection_intent.dart';
import 'package:excel_grid/src/shared/excel_actions/cut_selection_action/cut_selection_intent.dart';
import 'package:excel_grid/src/shared/excel_actions/delete_selection_action/delete_selection_action.dart';
import 'package:excel_grid/src/shared/excel_actions/delete_selection_action/delete_selection_intent.dart';
import 'package:flutter/material.dart';

class CutSelectionAction extends Action<CutSelectionIntent> {
  @override
  void invoke(CutSelectionIntent intent) {
    CopySelectionAction copyAction = CopySelectionAction();
    copyAction.invoke(CopySelectionIntent());

    DeleteSelectionAction deleteAction = DeleteSelectionAction();
    deleteAction.invoke(DeleteSelectionIntent());
  }
}
