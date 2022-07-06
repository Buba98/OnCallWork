import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/auth_route/sign_up_route/sign_up_bloc.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) => SignUpBloc(),
        child: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (BuildContext context, SignUpState state) {
            return Column(
              children: [
                state == SignUpState.unhandledError
                    ? const Text('Not recognized error')
                    : Container(),
                TextField(
                  controller: emailTextEditingController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: state == SignUpState.accountAlreadyExists
                        ? "Account already exists"
                        : null,
                  ),
                ),
                TextField(
                  controller: passwordTextEditingController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    errorText: state == SignUpState.weakPassword
                        ? "Weak password"
                        : null,
                  ),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () => context.read<SignUpBloc>().add(
                        SignUpEvent(
                          email: emailTextEditingController.text,
                          password: passwordTextEditingController.text,
                        ),
                      ),
                  child: const Text('Sign in'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
