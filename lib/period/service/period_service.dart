import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strawberry/period/model/day_type.dart';
import 'package:strawberry/period/model/period.dart';
import 'package:strawberry/period/model/period_constants.dart';
import 'package:strawberry/period/model/stats.dart';
import 'package:strawberry/utils/date_time_utils.dart';

class PeriodService {
  SharedPreferences configs;

  PeriodService(this.configs);

  List<Period> getSortedPeriods(List<DateTime> dates) {
    dates.sort();
    final List<Period> periods = List.empty(growable: true);
    for (DateTime day in dates) {
      Period? periodWithDay =
          periods.firstWhereOrNull((period) => period.includeInPeriod(day));
      if (periodWithDay == null) {
        periods.add(Period(startDay: day, endDay: day));
      }
    }
    return periods;
  }

  /// Fetch the predicted period days and their type for the future
  Map<DateTime, DateType> getPredictedPeriods(
      int numberOfCycles, List<DateTime> pastDays, DateTime currentDay) {
    final List<Period> pastPeriods = getSortedPeriods(pastDays);
    if (pastPeriods.isEmpty) {
      return {};
    }
    Stats stats = getStats();

    Duration cycleDuration = Duration(days: stats.cycleLength);
    Duration periodDuration = Duration(days: stats.periodLength);

    Period lastPeriod = pastPeriods.last;

    Map<DateTime, DateType> dates = {};

    Map<DateTime, DateType> currentPeriodDates =
        _getCurrentPeriodDates(lastPeriod, periodDuration);

    dates.addAll(currentPeriodDates);

    Map<DateTime, DateType> futurePeriodDates = _getFuturePeriodDates(
        lastPeriod, numberOfCycles, cycleDuration, periodDuration);

    dates.addAll(futurePeriodDates);

    return dates;
  }

  Map<DateTime, DateType> _getCurrentPeriodDates(
      Period lastPeriod, Duration periodDuration) {
    int lastPeriodDaysLeft = periodDuration.inDays -
        (lastPeriod.endDay.difference(lastPeriod.startDay).inDays);

    Map<DateTime, DateType> dates = {};
    for (int left = 1; left < lastPeriodDaysLeft; left++) {
      DateTime dateInCurrentPeriod =
          lastPeriod.endDay.add(Duration(days: left));
      dates[dateInCurrentPeriod] = DateType.IN_CURRENT_PERIOD;
    }
    return dates;
  }

  Map<DateTime, DateType> _getFuturePeriodDates(Period initialPeriod,
      int numberOfCycles, Duration cycleDuration, Duration periodDuration) {
    Map<DateTime, DateType> futurePeriodDates = {};
    Period lastPeriod = initialPeriod;
    bool markedNextStart = false;

    for (int cycle = 0; cycle < numberOfCycles; cycle++) {
      DateTime startOfNextPeriod = lastPeriod.startDay.add(cycleDuration);
      DateTime endOfNextPeriod = startOfNextPeriod.add(periodDuration);
      Period nextPeriod =
          Period(startDay: startOfNextPeriod, endDay: endOfNextPeriod);
      List<DateTime> datesInPeriod = nextPeriod.getDatesInPeriod();

      for (DateTime date in datesInPeriod) {
        if (!markedNextStart) {
          futurePeriodDates[date] = DateType.START_OF_NEXT_PERIOD;
          markedNextStart = true;
        } else {
          futurePeriodDates[date] = DateType.PERIOD;
        }
      }
      lastPeriod = nextPeriod;
    }
    return futurePeriodDates;
  }

  Stats getStats() => Stats(
      cycleLength:
          configs.getInt(AVERAGE_CYCLE_KEY) ?? DEFAULT_AVERAGE_CYCLE_LENGTH,
      periodLength:
          configs.getInt(AVERAGE_PERIOD_KEY) ?? DEFAULT_AVERAGE_PERIOD_LENGTH);

  void calculateStatsFromPeriods(List<DateTime> dates) {
    List<Period> periods = getSortedPeriods(dates);
    bool useManualStats =
        configs.getBool(USE_MANUAL_AVERAGES_KEY) ?? DEFAULT_MANUAL_AVERAGES;
    if (periods.length > 2 && !useManualStats) {
      final List<int> cycleLengths = List.empty(growable: true);
      final List<int> periodLengths = List.empty(growable: true);

      for (int i = 0; i < periods.length - 1; i++) {
        Period lastPeriod = periods[i];
        Period nextPeriod = periods[i + 1];
        int cycleLength = DateTimeUtils.getNumberOfDatesBetween(
            lastPeriod.startDay, nextPeriod.startDay);
        int previousPeriodLength = DateTimeUtils.getNumberOfDatesBetween(
            lastPeriod.startDay, lastPeriod.endDay);
        cycleLengths.add(cycleLength);
        periodLengths.add(previousPeriodLength);
      }
      int averageCycle = cycleLengths.average.round();
      int averagePeriod = periodLengths.average.round();
      configs.setInt(AVERAGE_CYCLE_KEY, averageCycle);
      configs.setInt(AVERAGE_PERIOD_KEY, averagePeriod);
    }
  }
}
