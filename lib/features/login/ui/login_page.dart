import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_chatoo_chat/core/routing/app_route.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/features/login/controller/login_controller.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_body.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.controller});

  final LoginController? controller;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController _controller =
      widget.controller ?? LoginController();
  var _identifier = '';
  var _password = '';

  Future<void> _submit() {
    return _finish(
      _controller.signIn(identifier: _identifier, password: _password),
    );
  }

  Future<void> _signInWithGoogle() {
    return _finish(_controller.signInWithGoogle());
  }

  Future<void> _signInWithFacebook() {
    return _finish(_controller.signInWithFacebook());
  }

  Future<void> _finish(Future<void> result) async {
    if (mounted) {
      setState(() {});
    }
    await result;
    if (!mounted) {
      return;
    }
    setState(() {});
    final message = _controller.status == LoginStatus.success
        ? 'Login Successful'
        : _controller.errorMessage;
    if (message != null) {
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(message)));
    }
    if (_controller.status == LoginStatus.success) {
      Navigator.of(context).pushReplacementNamed(AppRoute.chat.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.background : AppColors.surfaceLight;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: background,
          ),
      child: Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: LoginBody(
            onIdentifierChanged: (value) => setState(() => _identifier = value),
            onPasswordChanged: (value) => setState(() => _password = value),
            onSubmit: _submit,
            onGooglePressed: _signInWithGoogle,
            onFacebookPressed: _signInWithFacebook,
            isLoading: _controller.status == LoginStatus.loading,
            errorMessage: _controller.errorMessage,
          ),
        ),
      ),
    );
  }
}
