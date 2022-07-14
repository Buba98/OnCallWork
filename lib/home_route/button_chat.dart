import 'package:flutter/material.dart';
import 'package:on_call_work/home_route/chat/chat_page.dart';

class ButtonChat extends StatelessWidget {
  const ButtonChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.chat),
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ChatPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
                  CurveTween(curve: Curves.ease),
                ),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
