import 'package:intl/intl.dart';

class Task {
  int _id;
  String _name;
  String _vote;
  String _type;
  int _timestamp;

  int _year;
  int _month;
  int _day;
  DateTime _date;

  Task(String name, String vote, String type, int timestamp) {
    _name = name;
    _vote = vote;
    _type = type;
    _timestamp = timestamp;

    _timestampToProps(timestamp);
  }

  static int buildId(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    int year = date.year;
    int month = date.month;
    int day = date.day;

    return int.parse('${year}${month}${day}');
  }

  int getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  String getVote() {
    return _vote;
  }

  String getType() {
    return _type;
  }

  String getFormattedDate() {
    var format = DateFormat.Hm();
    var date = new DateTime.fromMillisecondsSinceEpoch(_timestamp);
    return format.format(date);
  }

  int getTimestamp() {
    return _timestamp;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': getId(),
      'name': getName(),
      'type': getType(),
      'vote': getVote(),
      'timestamp': getTimestamp(),
    };
  }

  int _buildId() {
    return int.parse('${_year}${_month}${_day}');
  }

  void _timestampToProps(int timestamp) {
    _date = DateTime.fromMillisecondsSinceEpoch(timestamp);

    _year = _date.year;
    _month = _date.month;
    _day = _date.day;

    _id = _buildId();
  }
}
