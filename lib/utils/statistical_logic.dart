import 'dart:math';

class StatisticalLogic {
  static Map<String, double> calculateStats(List<double> data) {
    if (data.isEmpty) return {};

    data.sort();
    double sum = data.reduce((a, b) => a + b);
    double mean = sum / data.length;
    double variance =
        data.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / data.length;
    double stdDev = sqrt(variance);

    double median;
    if (data.length % 2 == 0) {
      median = (data[data.length ~/ 2 - 1] + data[data.length ~/ 2]) / 2;
    } else {
      median = data[data.length ~/ 2];
    }

    return {
      'count': data.length.toDouble(),
      'sum': sum,
      'mean': mean,
      'median': median,
      'stdDev': stdDev,
      'variance': variance,
      'min': data.first,
      'max': data.last,
    };
  }
}
