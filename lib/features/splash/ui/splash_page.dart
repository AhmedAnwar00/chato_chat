import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/features/splash/controller/splash_controller.dart';
import 'package:my_chatoo_chat/features/splash/model/splash_content.dart';
import 'package:my_chatoo_chat/features/splash/ui/widgets/splash_backdrop.dart';
import 'package:my_chatoo_chat/features/splash/ui/widgets/splash_logo.dart';
import 'package:my_chatoo_chat/features/splash/ui/widgets/splash_title.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, this.controller});

  final SplashController? controller;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashController _controller =
      widget.controller ?? SplashController();
  SplashContent? _splash;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final splash = await _controller.load();
    if (!mounted) {
      return;
    }
    setState(() => _splash = splash);
  }

  @override
  Widget build(BuildContext context) {
    final splash = _splash;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: splash == null
          ? const SizedBox.shrink()
          : Stack(
              fit: StackFit.expand,
              children: [
                SplashBackdrop(splash: splash),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SplashLogo(splash: splash),
                      SplashTitle(splash: splash),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
