import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SignInState {
  init,
  wrongEmail,
  wrongPassword,
  unhandledError,
}

class SignInEvent {
  String email;
  String password;

  SignInEvent({
    required this.email,
    required this.password,
  });
}

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInState.init) {
    on<SignInEvent>(_onSignInEvent);
  }

  Future<void> _onSignInEvent(
      SignInEvent event, Emitter<SignInState> emit) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(SignInState.wrongEmail);
      } else if (e.code == 'wrong-password') {
        emit(SignInState.wrongPassword);
      }
    } catch (e) {
      developer.log('Unhandled expression:\n $e');
      emit(SignInState.unhandledError);
    }
  }
}
