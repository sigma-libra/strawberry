import 'dart:math';

import 'package:strawberry/model/sex_type.dart';
import 'package:strawberry/period/repository/database_constants.dart';

class DailyInfo {
  late int id;
  late DateTime date;
  late bool hadPeriod;
  late SexType hadSex;
  late bool birthControl;
  late double temperature;
  late String notes;

  DailyInfo(
      {required this.id,
      required this.date,
      required this.hadPeriod,
      required this.hadSex,
      required this.birthControl,
      required this.temperature,
      required this.notes});

  DailyInfo.create(this.date) {
    id = Random().nextInt(10000);
    hadPeriod = false;
    hadSex = SexType.NONE;
    birthControl = false;
    temperature = 0;
    notes = "";
  }

  // Convert a Period into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      idColumn: id,
      dateColumn: date.millisecondsSinceEpoch,
      hadPeriodColumn: hadPeriod ? 1 : 0,
      hadSexColumn: hadSex.index,
      birthControlColumn: birthControl ? 1 : 0,
      temperatureColumn: temperature,
      notesColumn: notes
    };
  }

  static DailyInfo fromMap(Map<String, dynamic> map) {
    return DailyInfo(
        id: map[idColumn],
        date: DateTime.fromMillisecondsSinceEpoch(map[dateColumn], isUtc: true),
        hadPeriod: map[hadPeriodColumn] == 1 ? true : false,
        hadSex: SexType.values[map[hadSexColumn]],
        birthControl: map[birthControlColumn] == 1 ? true: false,
        temperature: map[temperatureColumn],
        notes: map[notesColumn]);
  }

  // Implement toString to make it easier to see information about
  // each period day when using the print statement.
  @override
  String toString() {
    return 'Daily info {id: $id, date: $date, had period: $hadPeriod, had sex: $hadSex, birth control: $birthControl, temperature: $temperature, notes: $notes}';
  }
}
