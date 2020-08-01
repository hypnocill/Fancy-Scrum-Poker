import 'package:fancyscrumpoker/src/bloc/settings/settings_bloc_provider.dart';
import 'package:fancyscrumpoker/src/screen/about/about.dart';
import 'package:fancyscrumpoker/src/screen/daily_record_details/daily_record_details.dart';
import 'package:fancyscrumpoker/src/screen/stats/stats.dart';
import 'package:fancyscrumpoker/src/utils/system_ui_mixin.dart';
import 'package:flutter/material.dart';
import 'package:fancyscrumpoker/src/bloc/task/task_bloc_provider.dart';
import 'package:fancyscrumpoker/src/screen/choice/choice.dart';
import 'package:fancyscrumpoker/src/screen/reveal/reveal.dart';
import 'package:flutter/services.dart';

class FancyScrumPoker extends StatelessWidget with SystemUiMixin {
  Widget build(BuildContext context) {
    makeStatusBarTransparent();
    _precacheAssets(context);

    return SettingsBlocProvider(
      child: TaskBlocProvider(
        child: MaterialApp(
          theme: ThemeData(
            brightness: Brightness.dark,
            accentColor: Color.fromRGBO(217, 217, 217, 1),
          ),
          onGenerateRoute: initRouting,
        ),
      ),
    );
  }

  MaterialPageRoute initRouting(RouteSettings settings) {
    switch (settings.name) {
      case '/reveal':
        var args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return Reveal(args['vote'], args['type']);
          },
        );
      case '/stats':
        return MaterialPageRoute(
          builder: (BuildContext context) {
            final TaskBloc _bloc = TaskBlocProvider.of(context);
            _bloc.getAllDailyRecords();
            return Stats(_bloc);
          },
        );
      case '/daily_record_details':
        return MaterialPageRoute(
          builder: (BuildContext context) =>
              DailyRecordDetails(settings.arguments),
        );
      case '/about':
        return MaterialPageRoute(
          builder: (BuildContext context) => About(),
        );
      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => Choice(),
        );
    }
  }

  void _precacheAssets(BuildContext context) {
    precacheImage(AssetImage('assets/images/drawer_header_2.jpg'), context);
  }
}
