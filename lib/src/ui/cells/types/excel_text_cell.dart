import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/dto/cell_position.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_events.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller_states.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager.dart';
import 'package:excel_grid/src/model/storage_manager/storage_manager_events.dart';
import 'package:flutter/material.dart';

class ExcelTextCell extends StatefulWidget {
  final CellPosition cellPosition;
  final String? value;
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
    textEditingController = TextEditingController(text: widget.value);
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
            if( state is CellEditingState ) {
              selectionController.handleEvent(SingleCellSelectEvent(state.cellPosition));
              _updateFieldValue();
            }
          },
          backgroundCursorColor: Colors.red,
          autofocus: true,
          focusNode: focusNode,
          cursorColor: Colors.green,
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.cellPadding),
      child: Text(widget.editing ? 'Editing' : widget.value ?? ''),
    );
  }

  void _updateFieldValue() {
    storageManager.handleEvent(FieldEditedEvent(
      cellPosition: widget.cellPosition,
      value: textEditingController.text,
    ));
  }
}
