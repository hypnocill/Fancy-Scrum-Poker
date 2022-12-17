import 'dart:collection';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:fancyscrumpoker/src/resource/model/daily_record.dart';
import 'package:fancyscrumpoker/src/resource/model/task.dart';
import 'package:fancyscrumpoker/src/resource/repository.dart';

class DatabaseProvider implements Provider {
  static const DATABASE_NAME = 'fancyscrumpoker.db';
  static const TASKS_TABLE_NAME = 'tasks';

  Database _database;

  DatabaseProvider() {
    init();
  }

  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), DatabaseProvider.DATABASE_NAME),
      onCreate: (db, version) {
        return db.execute(
          """
          CREATE TABLE
          ${DatabaseProvider.TASKS_TABLE_NAME}
          (name TEXT PRIMARY KEY, id INTEGER, vote TEXT, type TEXT, timestamp INTEGER);
          """,
        );
      },
      version: 1,
    );
  }

  Future<List<DailyRecord>> getAllDailyRecords() async {
    final List<Map<String, dynamic>> results =
        await _database.query(DatabaseProvider.TASKS_TABLE_NAME);

    final rawRecords = SplayTreeMap<int, List<Task>>((a, b) => b.compareTo(a));

    results.forEach((row) {
      final _task = Task(row['name'], row['vote'], row['type'], row['timestamp']);

      if (rawRecords[row['id']] is! List) {
        rawRecords[row['id']] = [];
      }

      rawRecords[row['id']] = [...rawRecords[row['id']], _task];
    });

    final List<DailyRecord> records = [];

    rawRecords.forEach((index, rawRecord) {
      records.add(DailyRecord(rawRecord));
    });

    return records;
  }

  Future<int> deleteDailyRecord(int id) {
    return _database.delete(
      DatabaseProvider.TASKS_TABLE_NAME,
      where: 'id = "${id}"',
    );
  }

  Future<void> deleteAllDailyRecords() {}

  Future<int> addTask(Task task) async {
    return _database.insert(DatabaseProvider.TASKS_TABLE_NAME, task.toMap());
  }

  Future<bool> taskExists(String taskName) async {
    List<Map<String, dynamic>> result = await _database.query(
      DatabaseProvider.TASKS_TABLE_NAME,
      where: 'name = "${taskName}"',
    );

    if (result.length > 0) {
      return true;
    }

    return false;
  }
}
