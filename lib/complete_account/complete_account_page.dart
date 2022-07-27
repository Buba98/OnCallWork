import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/bloc/auth_bloc.dart';
import 'package:on_call_work/complete_account/complete_account_bloc.dart';
import 'package:on_call_work/widget/k_button.dart';
import 'package:on_call_work/widget/k_user_input.dart';

class CompleteAccountPage extends StatelessWidget {
  CompleteAccountPage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final String uid;

  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController surnameTextEditingController =
      TextEditingController();

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
          create: (BuildContext context) => CompleteAccountBloc(uid: uid),
          child: BlocBuilder<CompleteAccountBloc, CompleteAccountState>(
            builder: (BuildContext context, CompleteAccountState state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Complete account',
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
                    controller: nameTextEditingController,
                    hintText: 'Name',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  KUserInput(
                    controller: surnameTextEditingController,
                    hintText: 'Surname',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  KButton(
                    onPressed: () {
                      context.read<CompleteAccountBloc>().add(
                            CompleteAccountEvent(
                              name: nameTextEditingController.text,
                              surname: surnameTextEditingController.text,
                            ),
                          );
                      context.read<AuthBloc>().add(AuthReloadEvent());
                    },
                    text: 'Complete account',
                  ),
                  const Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
