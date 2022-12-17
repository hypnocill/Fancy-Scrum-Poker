import 'package:fancyscrumpoker/src/config/settings.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {
  SettingsBloc() {
    settings.initSharedPreferences().then(
          (data) => _settingsStreamController.sink.add(settings),
          onError: (_) => print('SettingsBloc::constructor - error with initializing Settings'),
        );
  }

  final BehaviorSubject _settingsStreamController = BehaviorSubject<Settings>.seeded(settings);

  ValueStream<Settings> getSettingsStream() {
    return _settingsStreamController.stream;
  }

  Settings getSettingsObjcet() {
    return settings;
  }

  void setSelectedScreen(String title) {
    settings.setSelectedScreen(title);
    settings.save();

    _settingsStreamController.sink.add(settings);
  }

  void toggleShakeOnRevealSetting() {
    settings.toggleShakeOnReveal();
    settings.save();

    _settingsStreamController.sink.add(settings);
  }

  void toggleAlwaysAskForTaskNameSetting() {
    settings.toggleAlwaysAskForTaskName();
    settings.save();

    _settingsStreamController.sink.add(settings);
  }

  void toggleKeepScreenOn() {
    settings.toggleKeepScreenOn();
    settings.save();

    _settingsStreamController.sink.add(settings);
  }

  void dispose() {
    _settingsStreamController.close();
  }
}
