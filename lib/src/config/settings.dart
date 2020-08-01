// Intended to be used only via the Settings bloc
import 'dart:convert';

import 'package:fancyscrumpoker/src/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  String _selectedScreen = Config.CARD_TEXT_DEFAULT_TITLE;
  bool _shakeOnReveal = true;
  bool _keepScreenOn = true;
  bool _alwaysAskForTaskName = false;

  Future<bool> initSharedPreferences() async {
    try {
      SharedPreferences cache = await SharedPreferences.getInstance();

      String settingsJson = cache.getString('settings');

      if (settingsJson == null) {
        return false;
      }

      Map<String, dynamic> settingsMap = jsonDecode(settingsJson);
      _setSettingsFromMap(settingsMap);
      return true;
    } catch (e) {
      print('Settings::initSharedPreferences() error: ${e}');

      return false;
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  String getSelectedScreenOption() {
    return _selectedScreen;
  }

  bool getShakeOnRevealSetting() {
    return _shakeOnReveal;
  }

  bool getAlwaysAskForTaskNameSetting() {
    return _alwaysAskForTaskName;
  }

  bool getKeepScreenOn() {
    return _keepScreenOn;
  }

  //////////////////////////////////////////////////////////////////////////////

  void setSelectedScreen(String title) {
    _selectedScreen = title;
  }

  void toggleShakeOnReveal() {
    _shakeOnReveal = !_shakeOnReveal;
  }

  void toggleAlwaysAskForTaskName() {
    _alwaysAskForTaskName = !_alwaysAskForTaskName;
  }

  void toggleKeepScreenOn() {
    _keepScreenOn = !_keepScreenOn;
  }

  //////////////////////////////////////////////////////////////////////////////

  void save() async {
    try {
      SharedPreferences cache = await SharedPreferences.getInstance();
      cache.setString('settings', _toJson());
    } catch (e) {
      print('Settings::save() error: ${e}');
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  String _toJson() {
    Map<String, dynamic> settingsMap = {
      'selected_screen': _selectedScreen,
      'shake_on_reveal': _shakeOnReveal,
      'keep_screen_on': _keepScreenOn,
      'always_ask_for_task_name': _alwaysAskForTaskName,
    };

    return jsonEncode(settingsMap);
  }

  _setSettingsFromMap(Map<String, dynamic> settings) {
    _selectedScreen = settings['selected_screen'] ?? Config.CARD_TEXT_DEFAULT_TITLE;
    _shakeOnReveal = settings['shake_on_reveal'] ?? true;
    _keepScreenOn = settings['keep_screen_on'] ?? true;
    _alwaysAskForTaskName = settings['always_ask_for_task_name'] ?? false;
  }
}

final Settings settings = Settings();
