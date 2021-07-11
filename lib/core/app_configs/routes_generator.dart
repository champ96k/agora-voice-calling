import 'package:flutter/material.dart';

import '../../src/pages/caller_home.dart';
import '../../src/pages/caller_screen.dart';
import 'screen_names.dart';

class RouteGenerator {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case ScreenNames.callerScreen:
        return MaterialPageRoute(
          builder: (context) => const CallerScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const CallerHome(),
        );
    }
  }
}
