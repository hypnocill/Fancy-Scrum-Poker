import 'package:fancyscrumpoker/src/resource/model/task.dart';
import 'package:intl/intl.dart';

class DailyRecord {
  List<Task> _dailyRecord;

  DailyRecord(List<Task> tasks) {
    //validate all tasks have the same key
    _dailyRecord = tasks;
  }

  String getFormattedDate() {
    int timestamp = _dailyRecord[0].getTimestamp();

    var format = DateFormat('d MMM, yyyy');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    return format.format(date);
  }

  int getId() {
    return _dailyRecord[0].getId();
  }

  Task getTask(String name) {}

  List<Task> getRecord() {
    return _dailyRecord;
  }
}
