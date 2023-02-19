import 'package:collection/collection.dart';
import 'package:strawberry/period/period.dart';
import 'package:strawberry/period/stats.dart';

class PeriodService {

  /// Fetch the predicted period days for the future
  /// and whether they are part of the next period.
  Map<DateTime, bool> getPredictedPeriods(
      int numberOfCycles, List<DateTime> pastDays, DateTime currentDay) {
    final List<Period> pastPeriods = getSortedPeriods(pastDays);
    if (pastPeriods.isEmpty) {
      return {};
    }
    Stats stats = getStats(pastPeriods);
    Map<DateTime, bool> dates = {};

    Duration cycleDuration = Duration(days: stats.cycleLength);
    Duration periodDuration = Duration(days: stats.periodLength);

    Period lastPeriod = pastPeriods.last;
    int lastPeriodDaysLeft = periodDuration.inDays -
        (lastPeriod.endDay.difference(lastPeriod.startDay).inDays);
    /*if(lastPeriod.isInPeriod(currentDay)) {
      lastPeriodDaysLeft += 1;
    }*/

    for (int left = 1; left < lastPeriodDaysLeft; left++) {
      DateTime dateInCurrentPeriod =
          lastPeriod.endDay.add(Duration(days: left));
      dates[dateInCurrentPeriod] = false;
    }

    for (int cycle = 0; cycle < numberOfCycles; cycle++) {
      Period period = Period(
          startDay: lastPeriod.startDay.add(cycleDuration),
          endDay: lastPeriod.startDay.add(cycleDuration).add(periodDuration));
      List<DateTime> datesInPeriod = period.getDatesInPeriod();
      for (int date = 0; date < datesInPeriod.length; date++) {
        if (cycle == 0 && date == 0) {
          dates[datesInPeriod[date]] = true;
        } else {
          dates[datesInPeriod[date]] = false;
        }
      }
      lastPeriod = period;
    }
    return dates;
  }

  List<Period> getSortedPeriods(List<DateTime> dates) {
    dates.sort();
    final List<Period> periods = List.empty(growable: true);
    for (DateTime day in dates) {
      Period? newPeriod =
          periods.firstWhereOrNull((period) => period.addToEndOfPeriod(day));
      if (newPeriod == null) {
        periods.add(Period(startDay: day, endDay: day));
      }
    }
    return periods;
  }

  Stats getStats(List<Period> periods) {
    if (periods.length < 2) {
      return Stats.avgStats();
    }

    final List<int> cycleLengths = List.empty(growable: true);
    final List<int> periodLengths = List.empty(growable: true);
    for (int i = 0; i < periods.length - 1; i++) {
      Period previousPeriod = periods[i];
      Period nextPeriod = periods[i + 1];
      int cycleLength = _getNumberOfDaysBetweenDates(
          previousPeriod.startDay, nextPeriod.startDay);
      int previousPeriodLength = _getNumberOfDaysBetweenDates(
          previousPeriod.startDay, previousPeriod.endDay);
      cycleLengths.add(cycleLength);
      periodLengths.add(previousPeriodLength);
    }
    Stats stats = Stats(
        cycleLength: cycleLengths.average.round(),
        periodLength: periodLengths.average.round());
    return stats;
  }

  int _getNumberOfDaysBetweenDates(DateTime startDay, DateTime endDay) {
    int daysBetween = endDay.difference(startDay).inDays.abs();
    return daysBetween; //in order to count the start day
  }
}
