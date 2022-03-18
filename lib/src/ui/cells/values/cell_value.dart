import 'package:excel_grid/src/manager/autofill_manager/model/auto_filler/auto_filler.dart';
import 'package:excel_grid/src/manager/autofill_manager/model/auto_filler/date_time_auto_filler.dart';
import 'package:excel_grid/src/manager/autofill_manager/model/auto_filler/linear_regression_auto_filler.dart';
import 'package:excel_grid/src/manager/autofill_manager/model/auto_filler/repeat_selectrion_auto_filler.dart';
import 'package:flutter/material.dart';

abstract class CellValue {
  String get asString;

  AutoFiller get autoFiller;

  static CellValue assign(dynamic value) {
    List<CellValueBuilder> cellValueBuilders = <CellValueBuilder>[
      TextCellValueBuilder(),
      NumberCellValueBuilder(),
      DateTimeCellValueBuilder(),
    ];

    cellValueBuilders.sort((CellValueBuilder a, CellValueBuilder b) => a.priority.compareTo(b.priority));

    List<CellValue> matchingCellValues = List<CellValue>.empty(growable: true);
    for( CellValueBuilder cellValueBuilder in cellValueBuilders ) {
      CellValue? cellValue = cellValueBuilder.tryParse(value);
      if( cellValue != null ) {
        matchingCellValues.add(cellValue);
      }
    }
    return matchingCellValues.last;
  }


}

abstract class CellValueBuilder {
  CellValue? tryParse(String value);

  int get priority;
}

class TextCellValueBuilder extends CellValueBuilder {
  @override
  int get priority => 0;

  @override
  CellValue? tryParse(dynamic value) {
    return TextCellValue(value: '$value');
  }
}

class TextCellValue extends CellValue {
  final String value;

  TextCellValue({
    required this.value,
  });

  @override
  String get asString => value;

  @override
  AutoFiller get autoFiller => RepeatSelectionAutoFiller();
}

class NumberCellValueBuilder extends CellValueBuilder {
  @override
  int get priority => 1;

  @override
  CellValue? tryParse(dynamic value) {
    try {
      double numberValue = double.parse(value);
      return NumberCellValue(
        value: numberValue,
      );
    } catch(_) {
      return null;
    }
  }
}

class NumberCellValue extends CellValue {
  final num value;

  NumberCellValue({
    required this.value,
  });

  @override
  String get asString => value.toString();

  @override
  AutoFiller get autoFiller => LinearRegressionAutoFiller();
}

class DateTimeCellValueBuilder extends CellValueBuilder {
  @override
  int get priority => 2;

  @override
  CellValue? tryParse(dynamic value) {
    print(value);
    try {
      DateTime dateTimeValue = DateTime.parse(value);
      print('success: $dateTimeValue');
      return DateTimeCellValue(
        value: dateTimeValue,
      );
    } catch(e) {
      print('error parsing $value');
      return null;
    }
  }
}


class DateTimeCellValue extends CellValue {
  final DateTime value;

  DateTimeCellValue({
    required this.value,
  });

  @override
  String get asString => value.toString();

  @override
  AutoFiller get autoFiller => DateTimeAutoFiller();
}
