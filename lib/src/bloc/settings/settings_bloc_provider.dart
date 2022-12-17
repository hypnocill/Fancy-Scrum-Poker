import 'package:flutter/material.dart';

import 'settings_bloc.dart';
export 'settings_bloc.dart';

class SettingsBlocProvider extends InheritedWidget {
  final SettingsBloc _bloc;

  SettingsBlocProvider({Key key, Widget child})
      : _bloc = SettingsBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static SettingsBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsBlocProvider>()._bloc;
  }
}
