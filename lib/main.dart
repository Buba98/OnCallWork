import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/auth_route/auth_page.dart';
import 'package:on_call_work/complete_account/complete_account_page.dart';
import 'package:on_call_work/home_route/bloc/job_bloc.dart';
import 'package:on_call_work/home_route/home_page.dart';
import 'package:on_call_work/splash_page.dart';

import 'bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(),
        ),
        BlocProvider<JobBloc>(
          create: (BuildContext context) => JobBloc(),
        ),
      ],
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
        primarySwatch: Colors.blue,
      ),
      home: BlocListener<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is AuthUnauthenticatedState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AuthPage()),
            );
          } else if (state is AuthAuthenticatedState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (state is AuthCompleteAccountState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CompleteAccountPage()),
            );
          }
        },
        child: const SplashPage(),
      ),
    );
  }
}
