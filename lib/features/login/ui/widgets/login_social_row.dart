import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/features/login/ui/widgets/login_social_button.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class LoginSocialRow extends StatelessWidget {
  const LoginSocialRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LoginSocialButton(
            icon: Assets.images.loginFacebook.svg(width: 24, height: 24),
            label: 'Facebook',
          ),
        ),
        const SizedBox(width: 21),
        Expanded(
          child: LoginSocialButton(
            icon: Assets.images.loginGoogle.svg(width: 23.52, height: 24),
            label: 'Google',
          ),
        ),
      ],
    );
  }
}
