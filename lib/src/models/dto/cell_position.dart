import 'package:equatable/equatable.dart';
import 'package:excel_grid/src/models/dto/grid_position.dart';

class CellPosition extends Equatable {
  final GridPosition columnPosition;
  final GridPosition rowPosition;

  const CellPosition({
    required this.columnPosition,
    required this.rowPosition,
  });

  @override
  List<Object> get props => <Object>[columnPosition.hashCode, rowPosition.hashCode];

  @override
  String toString() {
    return '${rowPosition.key}${columnPosition.key}';
  }

  CellPosition copyWith({
    GridPosition? columnPosition,
    GridPosition? rowPosition,
  }) {
    return CellPosition(
      columnPosition: columnPosition ?? this.columnPosition,
      rowPosition: rowPosition ?? this.rowPosition,
    );
  }
}
