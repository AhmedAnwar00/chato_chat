import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_chatoo_chat/core/theme/app_colors.dart';
import 'package:my_chatoo_chat/features/signup/controller/signup_controller.dart';
import 'package:my_chatoo_chat/features/signup/ui/widgets/signup_body.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, this.controller});

  final SignUpController? controller;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final SignUpController _controller =
      widget.controller ?? SignUpController();
  var _email = '';
  var _password = '';

  Future<void> _submit() async {
    final result = _controller.signUp(email: _email, password: _password);
    if (mounted) {
      setState(() {});
    }
    await result;
    if (mounted) {
      setState(() {});
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
          child: SignupBody(
            onEmailChanged: (value) => setState(() => _email = value),
            onPasswordChanged: (value) => setState(() => _password = value),
            onSubmit: _submit,
            isLoading: _controller.status == SignUpStatus.loading,
            errorMessage: _controller.errorMessage,
          ),
        ),
      ),
    );
  }
}
