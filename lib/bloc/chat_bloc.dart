import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/service/repository_service.dart';

import '../model/chat/chat.dart';
import '../model/chat/message.dart';
import '../model/job.dart';
import '../model/user.dart';

abstract class ChatEvent {}

class ChatLoadEvent extends ChatEvent {}

class ChatOpenEvent extends ChatEvent {
  final Job job;
  final User user;
  final Message message;

  ChatOpenEvent({required this.job, required this.user, required this.message});

}

class ChatState {}

class ChatInitState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<Chat> chatsAsEmployee;
  final List<Chat> chatsAsEmployer;

  ChatLoadedState({
    required this.chatsAsEmployee,
    required this.chatsAsEmployer,
  });
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitState()) {
    on<ChatLoadEvent>(_onChatLoadEvent);
    on<ChatOpenEvent>(_onChatAddEvent);
  }

  _onChatLoadEvent(ChatLoadEvent event, Emitter<ChatState> emit) async {
    (await RepositoryService.listenChatEmployee()).listen((event) {

    });
  }

  _onChatAddEvent(ChatOpenEvent event, Emitter<ChatState> emit) {
    RepositoryService.openChat(event.job, event.user, event.message);
  }
}
