import 'package:flutter/material.dart';

import 'task_bloc.dart';
export 'task_bloc.dart';

class TaskBlocProvider extends InheritedWidget {
  final TaskBloc _bloc;

  TaskBlocProvider({Key key, Widget child})
      : _bloc = TaskBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static TaskBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TaskBlocProvider>()._bloc;
  }
}
