import 'package:excel_grid/src/dto/grid_position.dart';
import 'package:excel_grid/src/inherited_excel_theme.dart';
import 'package:excel_grid/src/model/excel_scroll_controller.dart';
import 'package:flutter/material.dart';

enum GridDirection {
  vertical,
  horizontal,
}

class TitleConfig {
  final GridPosition position;
  final GridDirection direction;

  TitleConfig({
    required this.position,
    required this.direction,
  });
}

class CellTitle extends StatefulWidget {
  final double width;
  final double height;
  final BorderSide borderSide;
  final Color backgroundColor;
  final ExcelScrollController scrollController;
  final TitleConfig titleConfig;

  const CellTitle({
    required this.width,
    required this.height,
    required this.borderSide,
    required this.backgroundColor,
    required this.titleConfig,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CellTitle();
}

class _CellTitle extends State<CellTitle> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: Border(
          bottom: widget.borderSide,
          right: widget.borderSide,
        ),
      ),
      child: Center(
        child: Text(
          widget.titleConfig.position.key,
          textAlign: TextAlign.center,
          style: InheritedExcelTheme.of(context).theme.verticalTitleCellTheme.textStyle,
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    return widget.backgroundColor;
  }
}
