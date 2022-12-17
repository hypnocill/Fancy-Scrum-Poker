import 'package:fancyscrumpoker/src/resource/model/daily_record.dart';
import 'package:fancyscrumpoker/src/resource/model/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DailyRecordDetails extends StatelessWidget {
  final DailyRecord _record;

  DailyRecordDetails(this._record);

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = _record.getRecord().reversed.toList(); //Reversed list for descening sorting

    return Scaffold(
      appBar: AppBar(
        title: Text(_record.getFormattedDate()),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 6.0),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int index) {
            final Task task = tasks[index];
            final double taskSize = _getTaskTileSize(task);

            return Container(
              padding: EdgeInsets.all(5.0),
              color: Color.fromRGBO(81, 82, 89, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      task.getName(),
                      style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  CircleAvatar(
                    radius: taskSize * 20,
                    backgroundColor: Color.fromRGBO(36, 36, 38, 1),
                    foregroundColor: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          task.getVote(),
                          style: TextStyle(fontSize: taskSize * 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          task.getType(),
                          style: TextStyle(fontSize: 10.0),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      task.getFormattedDate(),
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ),
                ],
              ),
            );
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(4, _getTaskTileSize(tasks[index])),
          mainAxisSpacing: 6.0,
          crossAxisSpacing: 6.0,
        ),
      ),
    );
  }

  double _getTaskTileSize(Task task) {
    final String vote = task.getVote();
    final double numericVote = double.tryParse(vote);

    if (numericVote == null) {
      //refactor this and the rest of the class
      return 1.5;
    } else if (numericVote > 8) {
      return 5;
    } else if (numericVote > 5) {
      return 4;
    } else if (numericVote > 2) {
      return 3;
    } else if (numericVote > 1) {
      return 2;
    } else if (numericVote > 0) {
      return 1.5;
    } else {
      return 2;
    }
  }
}
