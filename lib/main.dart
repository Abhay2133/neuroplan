import 'package:flutter/material.dart';
import 'package:neuroplan/constants/themes.dart';
import 'package:neuroplan/router/app_router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NeuroPlan',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Can be system, light, or dark
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}