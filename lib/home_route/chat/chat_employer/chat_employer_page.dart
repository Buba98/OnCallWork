import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/home_route/bloc/chat_bloc.dart';
import 'package:on_call_work/home_route/chat/chat_employee/conversation_widget.dart';

import '../../../model/chat/chat.dart';
import '../../../model/job.dart';

class ChatEmployerPage extends StatelessWidget {
  const ChatEmployerPage({Key? key, required this.job}) : super(key: key);

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applications for ${job.name}'),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
          builder: (BuildContext context, ChatState state) {
        List<Chat> chats = state.chatsEmployer
            .where((element) =>
                element.uidEmployer == FirebaseAuth.instance.currentUser!.uid)
            .toList();

        return ListView.builder(
          itemCount: chats.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 16),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => ConversationWidget(
            chat: chats[index],
          ),
        );
      }),
    );
  }
}
