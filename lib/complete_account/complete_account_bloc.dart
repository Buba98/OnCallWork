import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/service/repository_service.dart';
import 'package:on_call_work/model/user.dart' as internal_user;

enum CompleteAccountState {
  init,
  done,
  error,
}

class CompleteAccountEvent {
  String name;
  String surname;

  CompleteAccountEvent({
    required this.name,
    required this.surname,
  });
}

class CompleteAccountBloc
    extends Bloc<CompleteAccountEvent, CompleteAccountState> {
  CompleteAccountBloc() : super(CompleteAccountState.init) {
    on<CompleteAccountEvent>(_onCompleteAccountEvent);
  }

  Future<void> _onCompleteAccountEvent(
      CompleteAccountEvent event, Emitter<CompleteAccountState> emit) async {
  }
}
