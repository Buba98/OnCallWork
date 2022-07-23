import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/auth_route/sign_in_route/sign_in_bloc.dart';
import 'package:on_call_work/widget/k_button.dart';

import '../../widget/k_user_input.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: BlocProvider(
          create: (BuildContext context) => SignInBloc(),
          child: BlocBuilder<SignInBloc, SignInState>(
              builder: (BuildContext context, SignInState state) {
            print(state.toString());
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(
                  flex: 4,
                ),
                KUserInput(
                  errorText:
                      state == SignInState.wrongPassword ? 'Wrong email' : null,
                  controller: emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 25,
                ),
                KUserInput(
                  errorText: state == SignInState.wrongPassword
                      ? 'Wrong password'
                      : null,
                  controller: passwordController,
                  hintText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: KButton(
                      text: 'Login',
                      onPressed: () {
                        context.read<SignInBloc>().add(
                              SignInEvent(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                        // emailController.clear();
                        // passwordController.clear();
                      }),
                ),
                const Spacer(),
              ],
            );
          }),
        ),
      ),
    );
  }
}
