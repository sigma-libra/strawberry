import 'package:strawberry/utils/date_time_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class Period {
  DateTime startDay;
  DateTime endDay;

  Period({required this.startDay, required this.endDay});

  bool belongsToPeriod(DateTime day) {
    if (_isWithinPeriod(day)) {
      return true;
    }
    if (endDay.difference(day).inDays.abs() < 3) {
      endDay = day;
      return true;
    }
    return false;
  }

  List<DateTime> getDatesInPeriod() {
    List<DateTime> dates = List.empty(growable: true);
    DateTime date = startDay;
    while (date.isBefore(endDay)) {
      dates.add(date);
      date = date.add(const Duration(days: 1));
    }
    return dates;
  }

  // Implement toString to make it easier to see information about
  // each period when using the print statement.
  @override
  String toString() {
    return 'Period {start date: $startDay, end date: $endDay}';
  }

  bool _isWithinPeriod(DateTime day) {
    return isSameDay(startDay, day) || isSameDay(endDay, day) || (startDay.isBefore(day) && endDay.isAfter(day));
  }

  String prettyString() => "${DateTimeUtils.formatPrettyDate(startDay)} - ${DateTimeUtils.formatPrettyDate(endDay)}";
}
