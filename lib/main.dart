import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/routing/app_route.dart';
import 'package:my_chatoo_chat/core/routing/app_router.dart';
import 'package:my_chatoo_chat/core/theme/app_theme.dart';
import 'package:my_chatoo_chat/features/splash/controller/splash_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.controller});

  final SplashController? controller;

  @override
  Widget build(BuildContext context) {
    final router = AppRouter(splashController: controller);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Linoooooo Chat',
      theme: AppTheme.data,
      initialRoute: AppRoute.splash.path,
      onGenerateRoute: router.onGenerateRoute,
    );
  }
}
