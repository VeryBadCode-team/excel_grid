import 'package:excel_grid/src/shared/math/linear_trend.dart';

void main() {
  LinearTrend linearTrend = LinearTrend.train([1647352800000,1647352920000]);
  print(DateTime.fromMillisecondsSinceEpoch(linearTrend.getValue(1).toInt()));
  print(DateTime.fromMillisecondsSinceEpoch(linearTrend.getValue(2).toInt()));
  print(DateTime.fromMillisecondsSinceEpoch(linearTrend.getValue(3).toInt()));
  print(DateTime.fromMillisecondsSinceEpoch(linearTrend.getValue(4).toInt()));
  print(DateTime.fromMillisecondsSinceEpoch(linearTrend.getValue(5).toInt()));
}
