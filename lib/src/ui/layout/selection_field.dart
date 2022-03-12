import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/model/selection_controller/selection_controller.dart';
import 'package:flutter/cupertino.dart';

class SelectionField extends StatefulWidget {
  const SelectionField({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionField();
}

class _SelectionField extends State<SelectionField> {
  final SelectionController selectionController = globalLocator<SelectionController>();

  @override
  void initState() {
    selectionController.addListener(() {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 30,
      child: Text(selectionController.state.toString()),
    );
  }
}