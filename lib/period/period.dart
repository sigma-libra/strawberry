// start day
// end day



class Period {
  DateTime startDay;
  DateTime endDay;

  Period({
    required this.startDay,
    required this.endDay
  });

  bool addToEndOfPeriod(DateTime day) {
    if(startDay.difference(day).inDays.abs() < 1 || endDay.difference(day).inDays.abs() < 1 || (startDay.isBefore(day) && endDay.isAfter(day))) {
      return true;
    }
    if(endDay.difference(day).inDays.abs() < 3) {
      endDay = day;
      return true;
    }
    return false;
  }

  List<DateTime> getDatesInPeriod() {
    List<DateTime> dates = List.empty(growable: true);
    DateTime date = startDay;
    Duration day = const Duration(days: 1);
    while(date != endDay) {
      dates.add(date);
      date = date.add(day);
    }
    dates.add(endDay);
    return dates;
  }

  // Implement toString to make it easier to see information about
  // each period when using the print statement.
  @override
  String toString() {
    return 'Period {start date: $startDay, end date: $endDay}';
  }
}
