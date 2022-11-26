// start day
// end day
import 'package:strawberry/period/database_constants.dart';

class Period {
  final int id;
  final DateTime startDate;
  final DateTime endDate;

  Period({
    required this.id,
    required this.startDate,
    required this.endDate,
  });

  // Convert a Period into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      idColumn: id,
      startDateColumn: startDate.millisecondsSinceEpoch,
      endDateColumn: endDate.millisecondsSinceEpoch,
    };
  }

  static Period fromMap(Map<String, dynamic> map) {
    return Period(
      id: map[idColumn],
      startDate: DateTime.fromMillisecondsSinceEpoch(map[startDateColumn]),
      endDate: DateTime.fromMillisecondsSinceEpoch(map[endDateColumn]),
    );
  }

  // Implement toString to make it easier to see information about
  // each period when using the print statement.
  @override
  String toString() {
    return 'Period{id: $id, startDate: $startDate, endDate: $endDate}';
  }
}
