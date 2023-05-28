import 'package:sqflite/sqflite.dart';
import 'package:strawberry/info/repository/database_constants.dart';
import 'package:strawberry/info/model/daily_info.dart';
import 'package:path/path.dart';

class InfoRepository {
  late Database _database;

  Future init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'info_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $tableName($idColumn INTEGER PRIMARY KEY, '
          '$dateColumn INTEGER, '
          '$sexColumn STRING, '
          '$birthControlColumn BOOLEAN, '
          '$temperatureColumn FLOAT,'
          '$notesColumn STRING )',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> truncate() async {
    await _database.delete(tableName);
  }

  Future<void> insertDailyInfo(DailyInfo info) async {
    await _database.insert(
      tableName,
      info.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DailyInfo> getDailyInfo(DateTime date) async {
    final List<Map<String, dynamic>> maps = await _database.query(tableName,
        where: "$dateColumn = ?",
        whereArgs: [date.millisecondsSinceEpoch],
        limit: 1,
        offset: 0);

    if (maps.isNotEmpty) {
      return DailyInfo.fromMap(maps.first);
    } else {
      return DailyInfo.create(date);
    }
  }

  Future<void> updateDailyInfo(DailyInfo info) async {
    await _database.update(
      tableName,
      info.toMap(),
      where: '$idColumn = ?',
      whereArgs: [info.id],
    );
  }

  Future<void> deleteDailyInfo(DailyInfo info) async {
    await _database.delete(
      tableName,
      where: '$dateColumn = ?',
      // Pass the period's id as a whereArg to prevent SQL injection.
      whereArgs: [info.date.millisecondsSinceEpoch],
    );
  }
}
