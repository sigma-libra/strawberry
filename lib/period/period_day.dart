// start day
// end day
import 'dart:math';

import 'package:strawberry/period/database_constants.dart';

class PeriodDay {
  late int id;
  late DateTime date;

  PeriodDay({
    required this.id,
    required this.date,
  });

  PeriodDay.create(this.date) {
    id = Random().nextInt(10000);
  }

  // Convert a Period into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      idColumn: id,
      dateColumn: date.millisecondsSinceEpoch,
    };
  }

  static PeriodDay fromMap(Map<String, dynamic> map) {
    return PeriodDay(
      id: map[idColumn],
      date: DateTime.fromMillisecondsSinceEpoch(map[dateColumn], isUtc: true),
    );
  }

  // Implement toString to make it easier to see information about
  // each period day when using the print statement.
  @override
  String toString() {
    return 'Period day {id: $id, date: $date}';
  }
}
