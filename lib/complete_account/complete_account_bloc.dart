import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/model/user.dart' as internal_user;

import '../service/repository_service.dart';

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
  final String uid;

  CompleteAccountBloc({required this.uid}) : super(CompleteAccountState.init) {
    on<CompleteAccountEvent>(_onCompleteAccountEvent);
  }

  Future<void> _onCompleteAccountEvent(
      CompleteAccountEvent event, Emitter<CompleteAccountState> emit) async {
    internal_user.User user = internal_user.User(
      name: event.name,
      surname: event.surname,
      uid: uid,
      bio: '',
    );

    await RepositoryService.addUser(user);
  }
}
