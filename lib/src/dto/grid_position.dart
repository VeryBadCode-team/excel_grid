import 'package:equatable/equatable.dart';

class GridPosition extends Equatable {
  final String key;
  final int index;

  const GridPosition({
    required this.key,
    required this.index,
  });

  @override
  List<Object> get props => <Object>[key, index];
}
