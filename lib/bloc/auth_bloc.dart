import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_call_work/model/user.dart' as internal_user;
import 'package:on_call_work/service/repository_service.dart';

abstract class AuthState {}

class AuthInitState extends AuthState {}

class AuthUnauthenticatedState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final internal_user.User user;

  AuthAuthenticatedState({required this.user});

  Future<String?> get profilePicture {
    return RepositoryService.getProfilePicture(user);
  }
}

class AuthCompleteAccountState extends AuthState {}

class AuthDuplicatedAccountState extends AuthState {}

abstract class AuthEvent {}

class _AuthenticatedEvent extends AuthEvent {
  internal_user.User user;

  _AuthenticatedEvent({
    required this.user,
  });
}

class _UnauthenticatedEvent extends AuthEvent {}

class _CompleteAccountEvent extends AuthEvent {}

class AuthCompleteAccountEvent extends AuthEvent {
  final String name;
  final String surname;

  AuthCompleteAccountEvent({
    required this.name,
    required this.surname,
  });
}

class SignOutEvent extends AuthEvent {}

class AuthUpdateEvent extends AuthEvent {
  final XFile? picture;
  final String name;
  final String surname;
  final String bio;

  AuthUpdateEvent({
    required this.picture,
    required this.name,
    required this.surname,
    required this.bio,
  });
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitState()) {
    on<_AuthenticatedEvent>(_onAuthenticatedEvent);
    on<_UnauthenticatedEvent>(_onUnauthenticatedEvent);
    on<_CompleteAccountEvent>(_onCompleteAccountEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<AuthUpdateEvent>(_onAuthUpdateEvent);
    on<AuthCompleteAccountEvent>(_onAuthCompleteAccountEvent);

    _firebaseAuth.authStateChanges().listen((User? user) async {
      if (user == null) {
        add(_UnauthenticatedEvent());
      } else {
        internal_user.User? user = await RepositoryService.getUserByUid(
            FirebaseAuth.instance.currentUser!.uid);

        if (user == null) {
          add(_CompleteAccountEvent());
        } else {
          add(_AuthenticatedEvent(user: user));
        }
      }
    });
  }

  _onAuthCompleteAccountEvent(
      AuthCompleteAccountEvent event, Emitter<AuthState> emit) async {
    if ((await RepositoryService.getUserByUid(
            FirebaseAuth.instance.currentUser!.uid)) !=
        null) {
      emit(AuthDuplicatedAccountState());
      return;
    }

    internal_user.User user = internal_user.User(
      name: event.name,
      surname: event.surname,
      uid: FirebaseAuth.instance.currentUser!.uid,
      bio: '',
    );

    await RepositoryService.addUser(user);
    reload(event, emit);
  }

  _onAuthUpdateEvent(AuthUpdateEvent event, Emitter<AuthState> emit) async {
    String name = event.name;
    String surname = event.surname;
    String bio = event.bio;

    AuthState state = this.state;

    if (state is AuthAuthenticatedState) {
      await RepositoryService.updateUser(
        internal_user.User(
          uid: state.user.uid,
          name: name,
          surname: surname,
          bio: bio,
        ),
      );

/*      if(event.picture != null){
        event.picture.
      }*/

      reload(event, emit);
    }
  }

  reload(AuthEvent event, Emitter<AuthState> emit) async {
    User? user = _firebaseAuth.currentUser;

    if (user == null) {
      add(_UnauthenticatedEvent());
    } else {
      internal_user.User? user = await RepositoryService.getUserByUid(
          FirebaseAuth.instance.currentUser!.uid);

      if (user == null) {
        add(
          _CompleteAccountEvent(),
        );
      } else {
        add(
          _AuthenticatedEvent(
            user: user,
          ),
        );
      }
    }
  }

  _onAuthenticatedEvent(_AuthenticatedEvent event, Emitter<AuthState> emit) {
    emit(AuthAuthenticatedState(
      user: event.user,
    ));
  }

  _onCompleteAccountEvent(AuthEvent event, Emitter<AuthState> emit) {
    emit(AuthCompleteAccountState());
  }

  _onUnauthenticatedEvent(AuthEvent event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticatedState());
  }

  _onSignOutEvent(AuthEvent event, Emitter<AuthState> emit) async {
    await FirebaseAuth.instance.signOut();
    reload(event, emit);
  }
}
