import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';
import 'package:strawberry/model/daily_info.dart';
import 'package:strawberry/period/repository/database_constants.dart';
import 'package:path/path.dart';

class PeriodRepository {
  late Database _database;

  Future init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'period_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db
            .execute('CREATE TABLE $tableName($idColumn INTEGER PRIMARY KEY, '
                '$dateColumn INTEGER, '
                '$hadPeriodColumn INTEGER, '
                '$hadSexColumn INTEGER, '
                '$birthControlColumn INTEGER, '
                '$temperatureColumn FLOAT,'
                '$notesColumn STRING )');
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 2,
    );
  }

  Future<void> truncate() async {
    await _database.delete(tableName);
  }

  Future<void> insertInfoForDay(DailyInfo dailyInfo) async {
    await _database.insert(
      tableName,
      dailyInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DateTime>> getPeriodDates() async {
    final List<Map<String, dynamic>> maps = await _database
        .query(tableName, where: '$hadPeriodColumn = ?', whereArgs: [1]);

    return List.generate(maps.length, (i) {
      return DailyInfo.fromMap(maps[i]).date;
    });
  }

  Future<DailyInfo> getInfoForDate(DateTime date, double defaultTemperature, bool defaultBirthControl) async {
    final List<Map<String, dynamic>> entry = await _database.query(tableName,
        where: '$dateColumn = ?',
        whereArgs: [date.millisecondsSinceEpoch],
        limit: 1);
    final found = List.generate(entry.length, (index) {
      return DailyInfo.fromMap(entry[index]);
    });
    return found.firstOrNull ?? DailyInfo.create(date, defaultTemperature, defaultBirthControl);
  }

  Future<void> updateInfoForDay(DailyInfo dailyInfo) async {
    await _database.update(tableName, dailyInfo.toMap(),
        where: '$idColumn = ?',
        whereArgs: [dailyInfo.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteInfoForDate(DateTime date) async {
    await _database.delete(
      tableName,
      where: '$dateColumn = ?',
      // Pass the period's id as a whereArg to prevent SQL injection.
      whereArgs: [date.millisecondsSinceEpoch],
    );
  }
}
