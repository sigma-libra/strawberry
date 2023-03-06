// start day
// end day



import 'package:shared_preferences/shared_preferences.dart';
import 'package:strawberry/period/model/period_constants.dart';

class Stats {
  late int cycleLength;
  late int periodLength;

  Stats({
    required this.cycleLength,
    required this.periodLength
  });

  Stats.avgStats(SharedPreferences configs) {
    cycleLength = configs.getInt(AVERAGE_CYCLE_KEY) ?? DEFAULT_AVERAGE_CYCLE_LENGTH;
    periodLength = configs.getInt(AVERAGE_PERIOD_KEY) ?? DEFAULT_AVERAGE_PERIOD_LENGTH;
  }
}
