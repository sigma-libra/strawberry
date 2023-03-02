import 'package:flutter/material.dart';

class Period {
  DateTime startDay;
  DateTime endDay;

  Period({required this.startDay, required this.endDay});

  bool includeInPeriod(DateTime day) {
    if (isInPeriod(day)) {
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
    Duration dayConstant = const Duration(days: 1);
    DateTime date = startDay;
    while (date.isBefore(endDay)) {
      dates.add(date);
      date = date.add(dayConstant);
    }
    return dates;
  }

  // Implement toString to make it easier to see information about
  // each period when using the print statement.
  @override
  String toString() {
    return 'Period {start date: $startDay, end date: $endDay}';
  }

  bool _isSameDay(DateTime firstDay, DateTime secondDay) {
    return firstDay.difference(secondDay).inDays.abs() == 0;
  }

  isInPeriod(DateTime day) {
    return _isSameDay(startDay, day) ||
        _isSameDay(endDay, day) ||
        (startDay.isBefore(day) && endDay.isAfter(day));
  }

  ListTile asListTile() {
    return ListTile(
      title: Text("${_dateString(startDay)} - ${_dateString(endDay)}"),
    );
  }

  String _dateString(DateTime dateTime) {
    return "${_addLeadingZero(dateTime.day)}/${_addLeadingZero(dateTime.month)}/${_addLeadingZero(dateTime.year)}";
  }

  String _addLeadingZero(int number) {
    if (number < 10) {
      return "0$number";
    } else {
      return "$number";
    }
  }
}
