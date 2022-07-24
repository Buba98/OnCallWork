import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_call_work/bloc/auth_bloc.dart';
import 'package:on_call_work/home_route/loading_screen.dart';
import 'package:on_call_work/widget/k_button.dart';

import '../../widget/k_user_input.dart';

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

  XFile? image;

  ImageProvider imageProvider =
      const AssetImage('assets/images/profile_picture_placeholder.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
          if (state is AuthAuthenticatedState) {
            state.profilePicture.then((String? value) {
              if (value != null) {
                setState(
                  () => imageProvider = NetworkImage(value),
                );
              }
            });

            nameTextEditingController.text = state.user.name;
            surnameTextEditingController.text = state.user.surname;
            bioTextEditingController.text = state.user.bio;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 4,
                                color: Colors.white,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 10),
                                )
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageProvider,
                              ),
                            ),
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
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
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
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.text,
                        hintText: 'Name',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: KUserInput(
                        controller: surnameTextEditingController,
                        keyboardType: TextInputType.text,
                        hintText: 'Surname',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: KUserInput(
                        controller: bioTextEditingController,
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
                                picture: image,
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
              ],
            );
          }
          return const LoadingScreen();
        },
      ),
    );
  }

  _onTap() async {
    await ImagePicker().pickImage(source: ImageSource.camera).then(
      (XFile? value) async {
        if (value == null) {
          return;
        }

        image = value;
        Uint8List byte = await value.readAsBytes();

        setState(() {
          imageProvider = MemoryImage(byte);
        });
      },
    );
  }
}
