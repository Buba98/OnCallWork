import 'package:flutter/material.dart';
import 'package:on_call_work/auth_route/sign_in_route/sign_in_page.dart';
import 'package:on_call_work/auth_route/sign_up_route/sign_up_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              ),
              child: const Text('Sign in'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              ),
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
