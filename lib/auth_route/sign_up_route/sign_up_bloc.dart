import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SignUpState {
  init,
  weakPassword,
  accountAlreadyExists,
  unhandledError,
}

class SignUpEvent {
  String email;
  String password;

  SignUpEvent({
    required this.email,
    required this.password,
  });
}

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState.init) {
    on<SignUpEvent>(_onSignInEvent);
  }

  Future<void> _onSignInEvent(
      SignUpEvent event, Emitter<SignUpState> emit) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignUpState.weakPassword);
      } else if (e.code == 'email-already-in-use') {
        emit(SignUpState.accountAlreadyExists);
      }
    } catch (e) {
      developer.log('Unhandled expression:\n $e');
      emit(SignUpState.unhandledError);
    }
  }
}
