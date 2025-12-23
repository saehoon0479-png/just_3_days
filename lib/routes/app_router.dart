import 'package:flutter/material.dart';
import '../domain/challenge/challenge_controller.dart';
import '../domain/challenge/challenge_state.dart';
import '../ui/screens/s1_goal_setup_screen.dart';

class AppRouter {
  static const s1 = '/s1';

  static String initialRouteFor(ChallengeState state) {
    return s1;
  }

  static Route<dynamic> onGenerateRoute({
    required RouteSettings settings,
    required ChallengeController controller,
  }) {
    switch (settings.name) {
      case s1:
      default:
        return MaterialPageRoute(
          builder: (_) => S1GoalSetupScreen(controller: controller),
        );
    }
  }
}