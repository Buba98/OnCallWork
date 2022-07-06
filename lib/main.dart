import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/home_route/home_page.dart';
import 'package:on_call_work/splash_page.dart';

import 'auth_route/auth_page.dart';
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
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          switch (state) {
            case AuthState.init:
              return const SplashPage();
            case AuthState.unauthenticated:
              return const AuthPage();
            case AuthState.authenticated:
              return const HomePage();
          }
        },
      ),
    );
  }
}
