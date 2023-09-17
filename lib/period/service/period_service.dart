import 'package:collection/collection.dart';
import 'package:strawberry/model/day_type.dart';
import 'package:strawberry/model/period.dart';
import 'package:strawberry/model/stats.dart';
import 'package:strawberry/settings/settings_service.dart';
import 'package:strawberry/utils/date_time_utils.dart';

class PeriodService {
  final SettingsService _settings;

  PeriodService(this._settings);

  bool getPeriodNotifications() {
    return _settings.getNotificationsFlag();
  }

  bool setCurrentPeriodNotifications() {
    return _settings.getCurrentNotificationsFlag();
  }

  List<Period> splitDaysIntoPeriods(List<DateTime> dates) {
    dates.sort();
    final List<Period> periods = List.empty(growable: true);
    for (DateTime day in dates) {
      Period? periodWithDay = periods.firstWhereOrNull((period) => period.belongsToPeriod(day));
      if (periodWithDay == null) {
        periods.add(Period(startDay: day, endDay: day));
      }
    }
    return periods;
  }

  /// Fetch the predicted period days and their type for the future
  Map<DateTime, DateType> getPredictedPeriods(int numberOfCycles, List<DateTime> pastDays, DateTime currentDay) {
    final List<Period> pastPeriods = splitDaysIntoPeriods(pastDays);
    if (pastPeriods.isEmpty) {
      return {};
    }
    Stats stats = getStats();

    Duration cycleDuration = Duration(days: stats.cycleLength);
    Duration periodDuration = Duration(days: stats.periodLength);

    Period lastPeriod = pastPeriods.last;
    Map<DateTime, DateType> predictedDates = {};

    Map<DateTime, DateType> predictedCurrentDates = _getCurrentPeriodDates(lastPeriod, periodDuration, currentDay);
    predictedDates.addAll(predictedCurrentDates);

    Map<DateTime, DateType> predictedFutureDates =
        _getFuturePeriodDates(lastPeriod, numberOfCycles, cycleDuration, periodDuration, currentDay);
    predictedDates.addAll(predictedFutureDates);

    return predictedDates;
  }

  Map<DateTime, DateType> _getCurrentPeriodDates(Period lastPeriod, Duration periodDuration, DateTime currentDay) {
    int lastPeriodDaysLeft = periodDuration.inDays - (lastPeriod.endDay.difference(lastPeriod.startDay).inDays);

    int pastDaysLeft = currentDay.difference(lastPeriod.endDay).inDays;

    int futureDaysLeft = lastPeriodDaysLeft - pastDaysLeft;

    Map<DateTime, DateType> dates = {};
    if (futureDaysLeft <= 0) {
      return dates;
    }
    for (int left = 0; left <= futureDaysLeft; left++) {
      DateTime dateInCurrentPeriod = currentDay.add(Duration(days: left));
      dates[dateInCurrentPeriod] = DateType.IN_CURRENT_PERIOD;
    }
    return dates;
  }

  Map<DateTime, DateType> _getFuturePeriodDates(
      Period lastPeriod, int numberOfCycles, Duration cycleDuration, Duration periodDuration, DateTime currentDay) {
    Map<DateTime, DateType> futurePeriodDates = {};

    DateTime startOfNextPeriod = lastPeriod.startDay.add(cycleDuration);

    // If next period is late (was expected in the past), shift start to today
    if (startOfNextPeriod.isBefore(currentDay)) {
      startOfNextPeriod = currentDay;
    }
    DateTime endOfNextPeriod = startOfNextPeriod.add(periodDuration);
    DateTime firstFuturePeriodStart = startOfNextPeriod;

    for (int cycle = 0; cycle < numberOfCycles; cycle++) {
      Period nextPeriod = Period(startDay: startOfNextPeriod, endDay: endOfNextPeriod);
      List<DateTime> datesInPeriod = nextPeriod.getDatesInPeriod();

      for (DateTime date in datesInPeriod) {
        futurePeriodDates[date] = DateType.PERIOD;
      }
      startOfNextPeriod = nextPeriod.startDay.add(cycleDuration);
      endOfNextPeriod = startOfNextPeriod.add(periodDuration);
    }
    futurePeriodDates[firstFuturePeriodStart] = DateType.START_OF_NEXT_PERIOD;
    return futurePeriodDates;
  }

  Stats getStats() => Stats(cycleLength: _settings.getCycle(), periodLength: _settings.getPeriod());

  void calculateStatsFromPeriods(List<DateTime> dates) {
    List<Period> periods = splitDaysIntoPeriods(dates);
    bool useManualStats = _settings.getManualAveragesFlag();

    if (periods.length > 2 && !useManualStats) {
      final List<int> cycleLengths = List.empty(growable: true);
      final List<int> periodLengths = List.empty(growable: true);

      for (int i = 0; i < periods.length - 1; i++) {
        Period lastPeriod = periods[i];
        Period nextPeriod = periods[i + 1];
        int cycleLength = DateTimeUtils.getNumberOfDatesBetween(lastPeriod.startDay, nextPeriod.startDay);
        int previousPeriodLength = DateTimeUtils.getNumberOfDatesBetween(lastPeriod.startDay, lastPeriod.endDay);
        cycleLengths.add(cycleLength);
        periodLengths.add(previousPeriodLength);
      }
      int averageCycle = cycleLengths.average.round();
      int averagePeriod = periodLengths.average.round();
      _settings.setCycle(averageCycle);
      _settings.setPeriod(averagePeriod);
    }
  }
}
