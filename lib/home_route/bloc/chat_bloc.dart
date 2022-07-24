import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/service/repository_service.dart';

import '../../model/chat/chat.dart';
import '../../model/chat/message.dart';
import '../../model/job.dart';
import '../../model/user.dart';

abstract class ChatEvent {}

class ChatReloadEvent extends ChatEvent {}

class ChatOpenEvent extends ChatEvent {
  final Job job;
  final User user;
  final Message message;

  ChatOpenEvent({required this.job, required this.user, required this.message});
}

class _ChatUpdateEvent extends ChatEvent {}

class ChatState {
  final List<Chat> chatsEmployee;
  final List<Chat> chatsEmployer;

  ChatState({this.chatsEmployee = const [], this.chatsEmployer = const []});
}

class ChatInitState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  ChatLoadedState({
    required super.chatsEmployee,
    required super.chatsEmployer,
  });
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final User user;

  final List<Chat> chatsEmployee = [];
  final List<Chat> chatsEmployer = [];

  StreamSubscription? chatEmployeeSubscription;
  StreamSubscription? chatEmployerSubscription;

  ChatBloc({
    required this.user,
  }) : super(ChatInitState()) {
    on<ChatReloadEvent>(_onChatReloadEvent);
    on<ChatOpenEvent>(_onChatAddEvent);
    on<_ChatUpdateEvent>(_onChatUpdateEvent);
  }

  _onChatReloadEvent(ChatReloadEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());

    chatEmployeeSubscription?.cancel();
    chatEmployerSubscription?.cancel();

    chatEmployeeSubscription =
        RepositoryService.listenChatEmployee().listen((List<Chat> event) {
      bool updated;
      for (Chat update in event) {
        updated = false;
        for (Chat chat in chatsEmployee) {
          if (chat.uid! == chat.uid!) {
            chat.messagesEmployee.addAll(update.messagesEmployee);
            chat.messagesEmployer.addAll(update.messagesEmployer);
            updated = true;
            break;
          }
        }
        if (!updated) {
          chatsEmployee.add(update);
        }
      }
      add(_ChatUpdateEvent());
    });

    chatEmployerSubscription =
        RepositoryService.listenChatEmployer().listen((List<Chat> event) {
      bool updated;
      for (Chat update in event) {
        updated = false;
        for (Chat chat in chatsEmployee) {
          if (chat.uid! == chat.uid!) {
            chat.messagesEmployee.addAll(update.messagesEmployee);
            chat.messagesEmployer.addAll(update.messagesEmployer);
            updated = true;
            break;
          }
        }
        if (!updated) {
          chatsEmployee.add(update);
        }
      }
      add(_ChatUpdateEvent());
    });
  }

  _onChatUpdateEvent(_ChatUpdateEvent event, Emitter<ChatState> emit) {
    emit(ChatLoadedState(
      chatsEmployee: chatsEmployee,
      chatsEmployer: chatsEmployer,
    ));
  }

  _onChatAddEvent(ChatOpenEvent event, Emitter<ChatState> emit) {
    RepositoryService.openChat(event.job, event.user, event.message);
  }
}
