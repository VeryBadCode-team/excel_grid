import 'package:equatable/equatable.dart';

class GridPosition extends Equatable {
  final int index;
  final String key;

  const GridPosition({
    required this.key,
    required this.index,
  });

  @override
  List<Object> get props => <Object>[key, index];

  @override
  String toString() {
    return '$key$index';
  }
}
