import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState {
  init,
  unauthenticated,
  authenticated,
}

abstract class AuthEvent {}

class _AuthenticatedEvent extends AuthEvent {}

class _UnauthenticatedEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthState.init) {
    on<_UnauthenticatedEvent>(_onUnauthenticatedEvent);
    on<_AuthenticatedEvent>(_onAuthenticatedEvent);
    on<SignOutEvent>(_onSignOutEvent);

    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        add(_UnauthenticatedEvent());
      } else {
        add(_AuthenticatedEvent());
      }
    });
  }

  _onUnauthenticatedEvent(AuthEvent event, Emitter<AuthState> emit) {
    emit(AuthState.unauthenticated);
  }

  _onAuthenticatedEvent(AuthEvent event, Emitter<AuthState> emit) {
    emit(AuthState.authenticated);
  }

  _onSignOutEvent(AuthEvent event, Emitter<AuthState> emit) async {
    await FirebaseAuth.instance.signOut();
  }
}
