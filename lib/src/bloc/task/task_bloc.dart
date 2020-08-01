import 'package:fancyscrumpoker/src/resource/model/daily_record.dart';
import 'package:fancyscrumpoker/src/resource/repository.dart';
import 'package:rxdart/rxdart.dart';

import 'package:fancyscrumpoker/src/resource/model/task.dart';
import 'package:fancyscrumpoker/src/resource/provider/database_provider.dart';

class TaskBloc {
  final BehaviorSubject _typedTaskNameStreamController = BehaviorSubject<String>();
  final BehaviorSubject _taskNameStreamController = BehaviorSubject<String>();

  final BehaviorSubject _dailyRecordsStream = BehaviorSubject<List<DailyRecord>>();

  final BehaviorSubject _taskErrorStreamController = BehaviorSubject<String>();

  final Repository _repository = Repository(DatabaseProvider());

  Repository getRepository() {
    return _repository;
  }

  ValueStream<dynamic> getDailyRecordsStream() {
    return _dailyRecordsStream.stream;
  }

  Future<List<DailyRecord>> getAllDailyRecords() async {
    List<DailyRecord> records = await _repository.getAllDailyRecords();
    _dailyRecordsStream.sink.add(records);

    return records;
  }

  ValueStream<String> getTypedTaskNameStream() {
    return _typedTaskNameStreamController.stream;
  }

  ValueStream<String> getTaskNameStream() {
    return _taskNameStreamController.stream;
  }

  ValueStream<String> getTaskErrorStream() {
    return _taskErrorStreamController.stream;
  }

  Future<bool> taskExistInDatabase(String taskName) {
    return _repository.taskExists(taskName);
  }

  Future<int> saveTaskToDatabase(Task task) {
    return _repository.addTask(task);
    //error handling for that is needed here. Prompts the user to change the name of the task and retry
  }

  void saveTaskNameToState(String taskName) {
    _taskNameStreamController.sink.add(taskName);
    _typedTaskNameStreamController.drain();
  }

  void typeTaskName(String text) {
    _typedTaskNameStreamController.sink.add(text);
  }

  void clearTask() {
    _taskNameStreamController.sink.add(null);
    _typedTaskNameStreamController.sink.add(null);

    _taskNameStreamController.drain();
    _typedTaskNameStreamController.drain();
  }

  void setError(String text) {
    _taskErrorStreamController.sink.add(text);
  }

  void dispose() {
    _typedTaskNameStreamController.close();
    _taskNameStreamController.close();
    _taskErrorStreamController.close();
    _dailyRecordsStream.close();
  }
}
