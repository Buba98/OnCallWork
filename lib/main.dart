import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/auth_route/auth_page.dart';
import 'package:on_call_work/home_route/bloc/chat_bloc.dart';
import 'package:on_call_work/complete_account/complete_account_page.dart';
import 'package:on_call_work/home_route/bloc/job_bloc.dart';
import 'package:on_call_work/home_route/home_page.dart';
import 'package:on_call_work/splash_page.dart';

import 'bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    BlocProvider<AuthBloc>(
      create: (BuildContext context) => AuthBloc(),
      child: const OnCallWorkApp(),
    ),
  );
}

class OnCallWorkApp extends StatelessWidget {
  const OnCallWorkApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnCallWork',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.indigo,
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.indigo,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.indigo,
          surface: Colors.white,
          onSurface: Colors.indigo,
        ),
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          Navigator.popUntil(context, (route) => route.isFirst);

          if (state is AuthUnauthenticatedState) {
            return const AuthPage();
          } else if (state is AuthAuthenticatedState) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<JobBloc>(
                  create: (BuildContext context) => JobBloc(
                    user: state.user,
                  ),
                ),
                BlocProvider<ChatBloc>(
                  create: (BuildContext context) => ChatBloc(
                    user: state.user,
                  ),
                ),
              ],
              child: const HomePage(),
            );
          } else if (state is AuthCompleteAccountState) {
            return CompleteAccountPage();
          }
          return const SplashPage();
        },
      ),
    );
  }
}
