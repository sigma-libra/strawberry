import 'package:sqflite/sqflite.dart';
import 'package:strawberry/period/database_constants.dart';
import 'package:strawberry/period/period.dart';
import 'package:path/path.dart';

class PeriodRepository {
  late Database database;

  Future initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'period_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $tableName($idColumn INTEGER PRIMARY KEY, $startDateColumn INTEGER, $endDateColumn INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<void> insertPeriod(Period period) async {
    await database.insert(
      tableName,
      period.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Period>> getPeriods() async {
    final List<Map<String, dynamic>> maps = await database.query(tableName);

    return List.generate(maps.length, (i) {
      return Period.fromMap(maps[i]);
    });
  }

  Future<void> updatePeriod(Period period) async {
    await database.update(
      tableName,
      period.toMap(),
      where: '$idColumn = ?',
      whereArgs: [period.id],
    );
  }

  Future<void> deletePeriod(int id) async {
    await database.delete(
      tableName,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }
}
