import 'package:flutter/material.dart';
import 'package:on_call_work/home_route/chat/chat_employee/chat_employee_page.dart';

class ButtonChat extends StatelessWidget {
  const ButtonChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.chat),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      },
    );
  }
}
