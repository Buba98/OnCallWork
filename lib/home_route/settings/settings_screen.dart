import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_call_work/bloc/auth_bloc.dart';
import 'package:on_call_work/home_route/k_app_bar.dart';
import 'package:on_call_work/home_route/settings/widget/profile_picture.dart';
import 'package:on_call_work/widget/k_button.dart';

import '../../widget/k_user_input.dart';
import '../loading_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController surnameTextEditingController =
      TextEditingController();
  final TextEditingController bioTextEditingController =
      TextEditingController();

  Uint8List? newPicture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          if (state is AuthAuthenticatedState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Stack(
                      children: [
                        ProfilePicture(
                          pictureUrl: state.profilePicture,
                          newPicture: newPicture,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _onTap,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.green,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: KUserInput(
                      controller: nameTextEditingController
                        ..text = state.user.name,
                      keyboardType: TextInputType.text,
                      hintText: 'Name',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: KUserInput(
                      controller: surnameTextEditingController
                        ..text = state.user.surname,
                      keyboardType: TextInputType.text,
                      hintText: 'Surname',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: KUserInput(
                      controller: bioTextEditingController
                        ..text = state.user.bio,
                      keyboardType: TextInputType.multiline,
                      hintText: 'Bio',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: KButton(
                      onPressed: () => context.read<AuthBloc>().add(
                            AuthUpdateEvent(
                              name: nameTextEditingController.text,
                              surname: surnameTextEditingController.text,
                              bio: bioTextEditingController.text,
                              picture: newPicture,
                            ),
                          ),
                      text: 'Save',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextButton(
                      onPressed: () => context.read<AuthBloc>().add(
                            SignOutEvent(),
                          ),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateColor.resolveWith(
                          (states) => Theme.of(context).errorColor,
                        ),
                      ),
                      child: const Text('Sign out'),
                    ),
                  ),
                ],
              ),
            );
          }
          return const LoadingScreen();
        },
      ),
    );
  }

  _onTap() async {
    XFile? value = await ImagePicker().pickImage(source: ImageSource.camera);
    if (value != null) {
      Uint8List byte = await value.readAsBytes();

      setState(() {
        newPicture = byte;
      });
    }
  }
}
