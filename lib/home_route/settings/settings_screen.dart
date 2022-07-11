import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/bloc/auth_bloc.dart';
import 'package:on_call_work/home_route/loading_screen.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController surnameTextEditingController =
      TextEditingController();
  final TextEditingController bioTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          if (state is AuthAuthenticatedState) {
            return Column(
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
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: bioTextEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                  ),
                ),
                ElevatedButton(
                  onPressed: () => context.read<AuthBloc>().add(
                        AuthUpdateEvent(
                          name: nameTextEditingController.text,
                          surname: surnameTextEditingController.text,
                          bio: bioTextEditingController.text,
                        ),
                      ),
                  child: const Text('Save'),
                ),
              ],
            );
          }
          return const LoadingScreen();
        },
      ),
    );
  }
}
