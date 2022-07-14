import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/service/repository_service.dart';

import '../model/chat/chat.dart';

abstract class ChatEvent {}

class ChatLoadEvent extends ChatEvent {}

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
  }

  _onChatLoadEvent(ChatLoadEvent event, Emitter<ChatState> emit) async {
    (await RepositoryService.listenChatAsEmployee()).listen((event) {

    });
  }
}
