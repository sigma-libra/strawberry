// start day
// end day



import 'package:strawberry/period/stats.dart';

class Period {
  DateTime startDay;
  DateTime endDay;

  Period({
    required this.startDay,
    required this.endDay
  });

  bool addToEndOfPeriod(DateTime day) {
    Duration oneDay = const Duration(days: 1);
    if(startDay.difference(day) < oneDay || endDay.difference(day) < oneDay || (startDay.isBefore(day) && endDay.isAfter(day))) {
      return true;
    }
    if(endDay.difference(day).inDays < 3) {
      endDay = day;
      return true;
    }
    return false;
  }

  List<Period> getPredictedPeriods(int monthsInFuture, Stats stats) {
    List<Period> periods = List.empty(growable: true);
    DateTime startDay = DateTime.now();
    Duration periodDuration = Duration(days: stats.periodLength);
    Duration cycleDuration = Duration(days: stats.cycleLength);
    for(int month = 0; month < monthsInFuture; month++) {
      Period period = Period(startDay: startDay, endDay: startDay.add(periodDuration));
      periods.add(period);
      startDay = startDay.add(cycleDuration);
    }
    return periods;
  }
}
