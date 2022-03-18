import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:excel_grid/src/manager/selection_controller/states/editing_cell_state.dart';
import 'package:excel_grid/src/manager/selection_controller/states/selection_state.dart';
import 'package:excel_grid/src/manager/storage_manager/events/edit_single_cell_event.dart';
import 'package:excel_grid/src/manager/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/ui/cells/values/cell_value.dart';
import 'package:flutter/material.dart';

class ExcelTextCell extends StatefulWidget {
  final CellPosition cellPosition;
  final CellValue? value;
  final bool editing;
  final double cellPadding;

  const ExcelTextCell({
    required this.cellPosition,
    required this.cellPadding,
    this.value,
    this.editing = false,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExcelTextCell();
}

class _ExcelTextCell extends State<ExcelTextCell> {
  final StorageManager storageManager = globalLocator<StorageManager>();
  final SelectionManager selectionManager = globalLocator<SelectionManager>();

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        _updateFieldValue();
      }
    });
    focusNode.requestFocus();
    textEditingController = TextEditingController(text: _getInitialValue());
    if (widget.editing) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.only(
          left: widget.cellPadding,
          right: widget.cellPadding,
          top: 2,
        ),
        child: EditableText(
          controller: textEditingController,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          onEditingComplete: () {
            SelectionState state = selectionManager.state;
            if (state is EditingCellState) {
              _updateFieldValue();
            }
          },
          backgroundCursorColor: Colors.red,
          focusNode: focusNode,
          cursorColor: Colors.green,
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: widget.cellPadding),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          widget.editing ? 'Editing' : widget.value?.asString ?? '',
          maxLines: 1,
          // textAlign: widget.value is NumberCellValue ? TextAlign.end : TextAlign.start,
          overflow: TextOverflow.fade,
          softWrap: false,
        ),
      ),
    );
  }

  void _updateFieldValue() {
    storageManager.handleEvent(EditSingleCellEvent(
      cellPosition: widget.cellPosition,
      value: textEditingController.text,
    ));
  }

  String? _getInitialValue() {
    SelectionState selectionState = selectionManager.state;
    if (selectionState is EditingCellAfterKeyPressedState) {
      return selectionState.keyCharacterValue;
    }
    return widget.value?.asString;
  }
}
