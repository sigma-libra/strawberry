import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';
import 'package:strawberry/period/database_constants.dart';
import 'package:strawberry/period/period.dart';
import 'package:strawberry/period/period_constants.dart';
import 'package:strawberry/period/period_day.dart';
import 'package:path/path.dart';
import 'package:strawberry/period/stats.dart';

class PeriodService {

  List<DateTime> getPredictedPeriods(int monthsInFuture, List<DateTime> pastDays) {
    final List<Period> pastPeriods = getPeriods(pastDays);
    if(pastPeriods.isEmpty) {
      return List.empty();
    }
    Stats stats = getStats(pastPeriods);
    List<DateTime> dates = List.empty(growable: true);

    Period lastPeriod = pastPeriods.last;
    Duration cycleDuration = Duration(days: stats.cycleLength);
    Duration periodDuration = Duration(days: stats.periodLength);
    for(int month = 0; month < monthsInFuture; month++) {
      Period period = Period(startDay: lastPeriod.startDay.add(cycleDuration), endDay: lastPeriod.startDay.add(cycleDuration).add(periodDuration));
      List<DateTime> daysInPeriod = period.getDatesInPeriod();
      dates.addAll(daysInPeriod);
      lastPeriod = period;
    }
    return dates;
  }

  List<Period> getPeriods(List<DateTime> dates) {
    dates.sort();
    final List<Period> periods = List.empty(growable: true);
    for (DateTime day in dates) {
      Period? newPeriod = periods.firstWhereOrNull((period) => period.addToEndOfPeriod(day));
      if(newPeriod == null) {
        periods.add(Period(startDay: day, endDay: day));
      }
    }
    return periods;
  }

  Stats getStats(List<Period> periods) {

    if(periods.length < 2) {
      return Stats.avgStats();
    }

    final List<int> cycleLengths = List.empty(growable: true);
    final List<int> periodLengths = List.empty(growable: true);
    int i = 0;
    while(i < periods.length - 1) {
      cycleLengths.add(periods[i].startDay.difference(periods[i + 1].startDay).inDays.abs() + 1);
      periodLengths.add(periods[i].startDay.difference(periods[i].endDay).inDays.abs() + 1);
      i++;
    }
    periodLengths.add(periods[i].startDay.difference(periods[i].endDay).inDays.abs() + 1);
    Stats stats = Stats(cycleLength: cycleLengths.average.round(), periodLength: periodLengths.average.round());
    return stats;
  }
}
