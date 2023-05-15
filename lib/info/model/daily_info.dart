import 'dart:math';

import 'package:flutter/material.dart';
import 'package:strawberry/info/model/sex_type.dart';
import 'package:strawberry/info/repository/database_constants.dart';

class DailyInfo {
  late int id;
  late DateTime date;
  late SexType sex;
  late bool birthControl;
  late double temperature;
  late String notes;

  DailyInfo({
    required this.id,
    required this.date,
    required this.sex,
    required this.birthControl,
    required this.temperature,
    required this.notes
  });

  DailyInfo.create(this.date) {
    id = Random().nextInt(10000);
    sex = SexType.NONE;
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
      sexColumn: sex,
      birthControlColumn: birthControl,
      temperatureColumn: temperature,
      notesColumn: notes
    };
  }

  static DailyInfo fromMap(Map<String, dynamic> map) {
    return DailyInfo(
      id: map[idColumn],
      date: DateTime.fromMillisecondsSinceEpoch(map[dateColumn], isUtc: true),
      sex: map[sexColumn],
      birthControl: map[birthControlColumn],
      temperature: map[temperatureColumn],
      notes: map[notesColumn]
    );
  }

  // Implement toString to make it easier to see information about
  // each period day when using the print statement.
  @override
  String toString() {
    return 'Daily info {id: $id, date: $date, sex: $sex, birth control: $birthControl, temperature: $temperature, notes: $notes}';
  }
}
