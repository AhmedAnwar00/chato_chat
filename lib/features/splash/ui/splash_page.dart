import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/features/splash/controller/splash_controller.dart';
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
  bool? _showPattern;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final showPattern = await _controller.load();
    if (!mounted) {
      return;
    }
    setState(() => _showPattern = showPattern);
  }

  @override
  Widget build(BuildContext context) {
    final showPattern = _showPattern;
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.background
        : showPattern == false
        ? AppColors.primary
        : AppColors.surfaceChat;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: showPattern == null
          ? const SizedBox.shrink()
          : Stack(
              fit: StackFit.expand,
              children: [
                SplashBackdrop(showPattern: showPattern),
                const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [SplashLogo(), SplashTitle()],
                  ),
                ),
              ],
            ),
    );
  }
}
