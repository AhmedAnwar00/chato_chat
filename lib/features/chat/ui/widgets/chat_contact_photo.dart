import 'package:flutter/material.dart';
import 'package:my_chatoo_chat/gen/assets.gen.dart';

class ChatContactPhoto extends StatelessWidget {
  const ChatContactPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 36,
        height: 36,
        child: Assets.images.chatAvatar.image(
          fit: BoxFit.cover,
          alignment: const Alignment(0, -0.72),
        ),
      ),
    );
  }
}
