import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUiMixin {
  void makeStatusBarTransparent() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }
}
