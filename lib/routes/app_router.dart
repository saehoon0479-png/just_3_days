import 'package:flutter/material.dart';
import '../ui/screens/splash_intro_screen.dart';
import '../ui/screens/s1_goal_setup_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String s1 = '/s1';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashIntroScreen(),
          settings: settings,
        );
      case s1:
      default:
        return MaterialPageRoute(
          builder: (_) => const S1GoalSetupScreen(),
          settings: settings,
        );
    }
  }
}
