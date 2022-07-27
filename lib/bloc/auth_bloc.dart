import 'dart:async';

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

class AuthCompleteAccountState extends AuthState {
  final String uid;

  AuthCompleteAccountState({required this.uid});
}

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

class AuthReloadEvent extends AuthEvent {}

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
  StreamSubscription<User?>? streamSubscription;

  AuthBloc() : super(AuthInitState()) {
    on<_AuthenticatedEvent>(_onAuthenticatedEvent);
    on<_UnauthenticatedEvent>(_onUnauthenticatedEvent);
    on<_CompleteAccountEvent>(_onCompleteAccountEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<AuthUpdateEvent>(_onAuthUpdateEvent);
    on<AuthReloadEvent>(_onAuthReloadEvent);

    add(AuthReloadEvent());
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

      if (event.picture != null) {
        await RepositoryService.updateProfilePicture(
            state.user, event.picture!);
      }

      add(AuthReloadEvent());
    }
  }

  _onAuthenticatedEvent(_AuthenticatedEvent event, Emitter<AuthState> emit) {
    emit(AuthAuthenticatedState(
      user: event.user,
    ));
  }

  _onCompleteAccountEvent(AuthEvent event, Emitter<AuthState> emit) {
    emit(AuthCompleteAccountState(uid: _firebaseAuth.currentUser!.uid));
  }

  _onUnauthenticatedEvent(AuthEvent event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticatedState());
  }

  _onSignOutEvent(AuthEvent event, Emitter<AuthState> emit) async {
    await FirebaseAuth.instance.signOut();
  }

  _onAuthReloadEvent(AuthEvent event, Emitter<AuthState> emit) {
    streamSubscription?.cancel();

    streamSubscription =
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
}
