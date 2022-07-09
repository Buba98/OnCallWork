import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/auth_route/sign_in_route/sign_in_bloc.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) => SignInBloc(),
        child: BlocBuilder<SignInBloc, SignInState>(
          builder: (BuildContext context, SignInState state) {
            return Column(
              children: [
                state == SignInState.unhandledError
                    ? const Text('Not recognized error')
                    : Container(),
                TextField(
                  controller: emailTextEditingController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText:
                        state == SignInState.wrongEmail ? "Wrong email" : null,
                  ),
                ),
                TextField(
                  controller: passwordTextEditingController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: state == SignInState.wrongEmail
                        ? "Wrong password"
                        : null,
                  ),
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () => context.read<SignInBloc>().add(
                        SignInEvent(
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
