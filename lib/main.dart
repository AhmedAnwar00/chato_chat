import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_theme.dart';
import 'package:my_chatoo_chat/features/splash/controller/splash_controller.dart';
import 'package:my_chatoo_chat/features/splash/ui/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.controller});

  final SplashController? controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Linoooooo Chat',
      theme: AppTheme.data,
      home: SplashPage(controller: controller),
    );
  }
}
