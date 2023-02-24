// start day
// end day



import 'package:strawberry/period/model/period_constants.dart';

class Stats {
  late int cycleLength;
  late int periodLength;

  Stats({
    required this.cycleLength,
    required this.periodLength
  });

  Stats.avgStats() {
    cycleLength = averageCycleLength;
    periodLength = averagePeriodLength;
  }
}
