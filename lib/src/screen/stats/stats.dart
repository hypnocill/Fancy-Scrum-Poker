import 'package:flutter/material.dart';

import 'package:fancyscrumpoker/src/bloc/task/task_bloc.dart';
import 'package:fancyscrumpoker/src/bloc/task/task_bloc_provider.dart';
import 'package:fancyscrumpoker/src/resource/model/daily_record.dart';

class Stats extends StatelessWidget {
  final TaskBloc _bloc;

  Stats(this._bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        //move to a number of separate functions
        stream: _bloc.getDailyRecordsStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text('Fetching statistics...'),
            );
          }

          List<DailyRecord> records = snapshot.data as List<DailyRecord>;

          if (records.length == 0) {
            return Center(
              child: Text(
                'You have not voted for named tasks yet!',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (BuildContext context, int index) {
              final DailyRecord record = records[index];
              final int tasksCount = record.getRecord().length;

              String taskCountString = tasksCount.toString() + ' task';

              if (tasksCount > 1) {
                taskCountString += 's';
              }

              return Card(
                color: Color.fromRGBO(81, 82, 89, 1),
                margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                elevation: 3,
                child: ListTile(
                  title: Text(record.getFormattedDate()),
                  subtitle: Text(taskCountString),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_forever),
                    color: Colors.red[300],
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, record);
                    },
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/daily_record_details',
                    arguments: record,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, DailyRecord record) {
    //put in a Mixin and let it receive a callback for its action
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Deleting records for ${record.getFormattedDate()}'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () async {
              await _bloc.getRepository().deleteDailyRecord(record.getId());
              _bloc.getAllDailyRecords();
              Navigator.pop(context);
            },
            child: new Text('PROCEED'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text('CANCEL'),
          ),
        ],
      ),
    );
  }
}
