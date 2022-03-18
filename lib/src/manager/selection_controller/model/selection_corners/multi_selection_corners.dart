import 'package:excel_grid/src/models/dto/cell_position.dart';
import 'package:excel_grid/src/manager/selection_controller/model/selection_corners/selection_corners.dart';

class MultiSelectionCorners extends SelectionCorners {
  final CellPosition from;
  final CellPosition to;
  final bool oppositeVerticalSelection;
  final bool oppositeHorizontalSelection;

  MultiSelectionCorners({
    required this.from,
    required this.to,
    required this.oppositeVerticalSelection,
    required this.oppositeHorizontalSelection,
  });

  @override
  CellPosition get leftBottom {
    if (oppositeVerticalSelection && oppositeHorizontalSelection) {
      return from.copyWith(rowPosition: to.rowPosition);
    } else if (!oppositeVerticalSelection && !oppositeHorizontalSelection) {
      return from.copyWith(columnPosition: to.columnPosition);
    } else if (oppositeHorizontalSelection) {
      return to;
    }
    return from;
  }

  @override
  CellPosition get leftTop {
    if (oppositeVerticalSelection && oppositeHorizontalSelection) {
      return to;
    } else if (!oppositeVerticalSelection && !oppositeHorizontalSelection) {
      return from;
    } else if (oppositeHorizontalSelection) {
      return from.copyWith(rowPosition: to.rowPosition);
    }
    return from.copyWith(columnPosition: to.columnPosition);
  }

  @override
  CellPosition get rightBottom {
    if (oppositeVerticalSelection && oppositeHorizontalSelection) {
      return from;
    } else if (!oppositeVerticalSelection && !oppositeHorizontalSelection) {
      return to;
    } else if (oppositeVerticalSelection) {
      return from.copyWith(rowPosition: to.rowPosition);
    }
    return from.copyWith(columnPosition: to.columnPosition);
  }

  @override
  CellPosition get rightTop {
    if (oppositeVerticalSelection && oppositeHorizontalSelection) {
      return from.copyWith(columnPosition: to.columnPosition);
    } else if (!oppositeVerticalSelection && !oppositeHorizontalSelection) {
      return from.copyWith(rowPosition: to.rowPosition);
    } else if (oppositeHorizontalSelection) {
      return from;
    }
    return to;
  }
}