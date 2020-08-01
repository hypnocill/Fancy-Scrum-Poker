import 'package:flutter/material.dart';

import 'package:fancyscrumpoker/src/app.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      FancyScrumPoker()
    );
  });
}
