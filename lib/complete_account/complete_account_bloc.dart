import 'package:flutter_bloc/flutter_bloc.dart';

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
