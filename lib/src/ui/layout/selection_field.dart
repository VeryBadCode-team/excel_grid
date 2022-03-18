import 'package:excel_grid/src/core/locator.dart';
import 'package:excel_grid/src/manager/selection_controller/selection_manager.dart';
import 'package:flutter/cupertino.dart';

class SelectionField extends StatefulWidget {
  const SelectionField({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionField();
}

class _SelectionField extends State<SelectionField> {
  final SelectionManager selectionManager = globalLocator<SelectionManager>();

  @override
  void initState() {
    selectionManager.addListener(_rebuildWidget);
    super.initState();
  }

  @override
  void dispose() {
    selectionManager.removeListener(_rebuildWidget);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 30,
      child: Text(selectionManager.state.toString()),
    );
  }

  void _rebuildWidget() {
    if (mounted) {
      setState(() {});
    }
  }
}
