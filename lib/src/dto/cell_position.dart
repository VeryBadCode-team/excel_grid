import 'package:equatable/equatable.dart';
import 'package:excel_grid/src/dto/grid_position.dart';

class CellPosition extends Equatable {
  final GridPosition verticalPosition;
  final GridPosition horizontalPosition;

  const CellPosition({
    required this.verticalPosition,
    required this.horizontalPosition,
  });

  @override
  List<Object> get props => <Object>[verticalPosition.hashCode, horizontalPosition.hashCode];

  @override
  String toString() {
    return '${horizontalPosition.key}${verticalPosition.key}';
  }

  CellPosition copyWith({
    GridPosition? verticalPosition,
    GridPosition? horizontalPosition,
  }) {
    return CellPosition(
      verticalPosition: verticalPosition ?? this.verticalPosition,
      horizontalPosition: horizontalPosition ?? this.horizontalPosition,
    );
  }
}
