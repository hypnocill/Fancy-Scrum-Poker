import 'package:fancyscrumpoker/src/bloc/settings/settings_bloc_provider.dart';
import 'package:fancyscrumpoker/src/resource/model/task.dart';
import 'package:flutter/material.dart';

import 'package:fancyscrumpoker/src/bloc/task/task_bloc_provider.dart';
import 'package:fancyscrumpoker/src/widgets/singe_card.dart';
import 'package:fancyscrumpoker/src/widgets/widget_flipper.dart';
import 'package:wakelock/wakelock.dart';

class Reveal extends StatefulWidget {
  final String taskVote;
  final String taskType;

  Reveal(this.taskVote, this.taskType);

  @override
  _RevealState createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  @override
  Widget build(BuildContext context) {
    TaskBloc _taskBloc = TaskBlocProvider.of(context);
    SettingsBloc _settingsBloc = SettingsBlocProvider.of(context);

    if (_settingsBloc.getSettingsObjcet().getKeepScreenOn()) {
      try {
        Wakelock.enable();
      } catch (e) {
        print('Exception - Wake Lock cannot be enabled!');
      }
    }

    return Scaffold(
      body: WidgetFlipper(
        onFirstTap: () {
          _saveTaskToDatabase(context, _taskBloc);
        },
        onSecondTap: () {
          Navigator.pop(context);
          _taskBloc.clearTask();
        },
        backWidget: SingleCard.flat(
          widget.taskVote,
          Color.fromRGBO(36, 36, 38, 1),
        ),
        frontWidget: Hero(
          tag: widget.taskVote,
          child: Material(
            child: SingleCard.flat(
              _taskBloc.getTaskNameStream().value ?? 'READY',
              Color.fromRGBO(81, 82, 89, 1),
            ),
            type: MaterialType.transparency,
          ),
        ),
      ),
    );
  }

  void _saveTaskToDatabase(BuildContext context, TaskBloc bloc) async {
    String taskName = bloc.getTaskNameStream().value;

    if (taskName == null) {
      return;
    }

    bloc.saveTaskToDatabase(
      _getTaskObject(taskName, widget.taskVote, widget.taskType), //eror handle this
    );
  }

  Task _getTaskObject(String name, String vote, String type) {
    return Task(
      name,
      vote,
      type,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  dispose() {
    super.dispose();
    Wakelock.disable();
  }
}
