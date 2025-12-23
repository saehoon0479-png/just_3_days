import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'ui/theme/app_theme.dart';

class Just3DaysApp extends StatelessWidget {
  const Just3DaysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '딱 3일만',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.s1,
    );
  }
}
