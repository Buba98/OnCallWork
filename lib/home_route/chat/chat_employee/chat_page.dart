import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/home_route/bloc/chat_bloc.dart';
import 'package:on_call_work/home_route/chat/chat_employee/conversation_widget.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (BuildContext context, ChatState state) => ListView.builder(
          itemCount: state.chatsEmployee.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 16),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => ConversationWidget(
            chat: state.chatsEmployee[index],
          ),
        ),
      ),
    );
  }
}
