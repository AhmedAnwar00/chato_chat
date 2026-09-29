import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/routing/app_route.dart';
import 'package:my_chatoo_chat/features/fake_home/ui/fake_home_page.dart';
import 'package:my_chatoo_chat/features/login/ui/login_page.dart';
import 'package:my_chatoo_chat/features/signup/ui/signup_page.dart';
import 'package:my_chatoo_chat/features/splash/controller/splash_controller.dart';
import 'package:my_chatoo_chat/features/splash/ui/splash_page.dart';

class AppRouter {
  const AppRouter({this.splashController});

  final SplashController? splashController;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final route = AppRoute.values.where((item) => item.path == settings.name);
    final page = switch (route.isEmpty ? null : route.first) {
      AppRoute.splash => SplashPage(controller: splashController),
      AppRoute.login => const LoginPage(),
      AppRoute.signUp => const SignupPage(),
      AppRoute.fakeHome => const FakeHomePage(),
      null => SplashPage(controller: splashController),
    };
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}
