import 'package:flutter/material.dart';
import 'package:on_call_work/auth_route/sign_in_route/sign_in_page.dart';
import 'package:on_call_work/auth_route/sign_up_route/sign_up_page.dart';

import '../widget/k_button.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'On call work',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(
              flex: 3,
            ),
            KButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              ),
              text: 'Sign In',
            ),
            const SizedBox(
              height: 25,
            ),
            KButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              ),
              colorForeground: Colors.indigo,
              colorBackground: Colors.white,
              text: 'Sign Up',
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
