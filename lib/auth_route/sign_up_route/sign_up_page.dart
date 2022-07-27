import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/auth_route/sign_up_route/sign_up_bloc.dart';
import 'package:on_call_work/widget/k_button.dart';

import '../../widget/k_user_input.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpPage({Key? key}) : super(key: key);

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
          create: (BuildContext context) => SignUpBloc(),
          child: BlocBuilder<SignUpBloc, SignUpState>(
            builder: (BuildContext context, SignUpState state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
                KUserInput(
                  isError: state == SignUpState.accountAlreadyExists,
                  errorText: 'Account already exists',
                  controller: emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 25,
                ),
                KUserInput(
                  isError: state == SignUpState.weakPassword,
                  errorText: 'Weak password',
                  controller: passwordController,
                  hintText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                KButton(
                  text: 'Sign up',
                  onPressed: () {
                    context.read<SignUpBloc>().add(
                          SignUpEvent(
                            email: emailController.text,
                            password: passwordController.text,
                          ),
                        );
                    emailController.clear();
                    passwordController.clear();
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
