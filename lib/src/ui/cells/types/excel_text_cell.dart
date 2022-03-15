import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager_events.dart';
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
  final SelectionController selectionController = globalLocator<SelectionController>();

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
            SelectionState state = selectionController.state;
            if (state is CellEditingState) {
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
    storageManager.handleEvent(SingleCellEditedEvent(
      cellPosition: widget.cellPosition,
      value: textEditingController.text,
    ));
  }

  String? _getInitialValue() {
    SelectionState selectionState = selectionController.state;
    if (selectionState is CellEditingKeyPressedState) {
      return selectionState.keyValue;
    }
    return widget.value?.asString;
  }
}
