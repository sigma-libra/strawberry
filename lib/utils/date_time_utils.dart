class DateTimeUtils {

  static int getNumberOfDatesBetween(DateTime startDay, DateTime endDay) {
    return endDay.difference(startDay).inDays.abs() + 1;
  }

  static String formatPrettyDate(DateTime dateTime) {
    return "${_addLeadingZero(dateTime.day)}/${_addLeadingZero(dateTime.month)}/${_addLeadingZero(dateTime.year)}";
  }

  static String _addLeadingZero(int number) {
    if (number < 10) {
      return "0$number";
    } else {
      return "$number";
    }
  }
}
