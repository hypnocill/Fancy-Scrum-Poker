import 'package:fancyscrumpoker/src/resource/model/daily_record.dart';
import 'package:fancyscrumpoker/src/resource/model/task.dart';

class Repository {
  Provider _dbProvider;

  Repository(this._dbProvider);

  Future<List<DailyRecord>> getAllDailyRecords() async {
    return _dbProvider.getAllDailyRecords();
  }

  Future<int> deleteDailyRecord(int timestamp) async {
    return _dbProvider.deleteDailyRecord(timestamp);
  }

  Future<void> deleteAllDailyRecords() async {
    return _dbProvider.deleteAllDailyRecords();
  }

  Future<int> addTask(Task task) async {
    return _dbProvider.addTask(task);
  }

  Future<bool> taskExists(String taskName) async {
    return _dbProvider.taskExists(taskName);
  }
}

////////////////////////////////////////////////////////////////////////////////

abstract class Provider {
  Future<List<DailyRecord>> getAllDailyRecords();

  Future<int> deleteDailyRecord(int id);

  Future<void> deleteAllDailyRecords();

  Future<int> addTask(Task task);

  Future<bool> taskExists(String task);
}
