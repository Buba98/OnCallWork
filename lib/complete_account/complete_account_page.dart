import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/bloc/auth_bloc.dart';
import 'package:on_call_work/complete_account/complete_account_bloc.dart';

class CompleteAccountPage extends StatelessWidget {
  CompleteAccountPage({
    Key? key,
  }) : super(key: key);

  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController surnameTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) => CompleteAccountBloc(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameTextEditingController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: surnameTextEditingController,
              decoration: const InputDecoration(
                labelText: 'Surname',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      AuthCompleteAccountEvent(
                        name: nameTextEditingController.text,
                        surname: surnameTextEditingController.text,
                      ),
                    );
                context.read<AuthBloc>().add(AuthCompleteAccountEvent(
                      name: nameTextEditingController.text,
                      surname: surnameTextEditingController.text,
                    ));
              },
              child: const Text('Complete account'),
            ),
          ],
        ),
      ),
    );
  }
}
