import 'package:sqflite/sqflite.dart';
import 'package:strawberry/period/repository/database_constants.dart';
import 'package:strawberry/period/model/period_day.dart';
import 'package:path/path.dart';

class PeriodRepository {
  late Database _database;

  Future init() async {
    _database = await openDatabase(
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

  Future<void> truncate() async {
    await _database.delete(tableName);
  }

  Future<void> insertPeriod(PeriodDay period) async {
    await _database.insert(
      tableName,
      period.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DateTime>> getPeriodDates() async {
    final List<Map<String, dynamic>> maps = await _database.query(tableName);

    return List.generate(maps.length, (i) {
      return PeriodDay.fromMap(maps[i]).date;
    });
  }

  Future<void> updatePeriod(PeriodDay period) async {
    await _database.update(
      tableName,
      period.toMap(),
      where: '$idColumn = ?',
      whereArgs: [period.id],
    );
  }

  Future<void> deletePeriod(DateTime date) async {
    await _database.delete(
      tableName,
      where: '$dateColumn = ?',
      // Pass the period's id as a whereArg to prevent SQL injection.
      whereArgs: [date.millisecondsSinceEpoch],
    );
  }
}
