import 'dart:core';
import 'dart:math';

class LinearTrend {
  /// Periodic growth (a > 0) or loss (a < 0) rate
  final num a;

  /// Baseline period state
  final num b;

  LinearTrend({
    required this.a,
    required this.b,
  });

  factory LinearTrend.train(List<num> trainData) {
    int trainDataLength = trainData.length;
    num tAvg = ((1 + trainDataLength) / 2);
    num yAvg = (trainData.reduce((a, b) => a + b)) / trainDataLength;
    num aNominator = 0;
    num aDenominator = 0;
    for( int t = 1; t <= trainDataLength; t++) {
      num y = trainData[t - 1];
      aNominator += (t - tAvg) * (y - yAvg);
      aDenominator += pow((t - tAvg), 2);
    }
    num a = aNominator / aDenominator;
    num b = yAvg - a * tAvg;

    return LinearTrend(
      a: a,
      b: b,
    );
  }

  num getValue(int index) {
    return a * index + b;
  }
}
