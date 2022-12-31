import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';
import 'package:strawberry/period/database_constants.dart';
import 'package:strawberry/period/period.dart';
import 'package:strawberry/period/period_constants.dart';
import 'package:strawberry/period/period_day.dart';
import 'package:path/path.dart';
import 'package:strawberry/period/stats.dart';

class PeriodRepository {
  late Database database;

  Future initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'period_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $tableName($idColumn INTEGER PRIMARY KEY, $dateColumn INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertPeriod(PeriodDay period) async {
    await database.insert(
      tableName,
      period.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DateTime>> getPeriodDates() async {
    final List<Map<String, dynamic>> maps = await database.query(tableName);

    return List.generate(maps.length, (i) {
      return PeriodDay.fromMap(maps[i]).date;
    });
  }

  Future<Stats> getStats() async {
    final List<DateTime> days = await getPeriodDates();
    days.sort();

    final List<Period> periods = List.empty(growable: true);
    for (DateTime day in days) {
      Period? newPeriod = periods.firstWhereOrNull((period) => period.addToEndOfPeriod(day));
      if(newPeriod == null) {
        periods.add(Period(startDay: day, endDay: day));
      }
    }

    if(periods.length < 3) {
      return Stats.avgStats();
    }

    final List<int> cycleLengths = List.empty(growable: true);
    final List<int> periodLengths = List.empty(growable: true);
    for(int i = 0; i < periods.length - 1; i++) {
      cycleLengths.add(periods[i].startDay.difference(periods[i + 1].startDay).inDays);
      periodLengths.add(periods[i].startDay.difference(periods[i].endDay).inDays);
    }
    periodLengths.add(periods[periods.length - 1].startDay.difference(periods[periods.length - 1].endDay).inDays);
    Stats stats = Stats(cycleLength: cycleLengths.average.round(), periodLength: periodLengths.average.round());
    return stats;
  }

  Future<void> updatePeriod(PeriodDay period) async {
    await database.update(
      tableName,
      period.toMap(),
      where: '$idColumn = ?',
      whereArgs: [period.id],
    );
  }

  Future<void> deletePeriod(DateTime date) async {
    await database.delete(
      tableName,
      where: '$dateColumn = ?',
      // Pass the period's id as a whereArg to prevent SQL injection.
      whereArgs: [date.millisecondsSinceEpoch],
    );
  }
}
