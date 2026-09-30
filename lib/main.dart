import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/messaging/authenticated_device_token_store.dart';
import 'package:my_chatoo_chat/core/routing/app_route.dart';
import 'package:my_chatoo_chat/core/routing/app_router.dart';
import 'package:my_chatoo_chat/core/theme/app_theme.dart';
import 'package:my_chatoo_chat/core/theme/app_theme_controller.dart';
import 'package:my_chatoo_chat/features/splash/controller/splash_controller.dart';
import 'package:my_chatoo_chat/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(AuthenticatedDeviceTokenStore().saveForCurrentUser());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.controller});

  final SplashController? controller;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppThemeController _theme = AppThemeController();

  @override
  void initState() {
    super.initState();
    _theme.start(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _theme.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRouter(
      splashController: widget.controller,
      onToggleTheme: _theme.toggle,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Linoooooo Chat',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _theme.mode,
      initialRoute: AppRoute.splash.path,
      onGenerateRoute: router.onGenerateRoute,
    );
  }
}
