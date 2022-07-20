import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../../model/chat/message.dart';
import '../bloc/job_bloc.dart';
import '../job_card.dart';
import '../loading_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<JobBloc, JobState>(
        builder: (BuildContext context, JobState state) {
          if (state is JobLoadedState) {
            return ListView.builder(
              itemCount: state.availableJobs.length,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: JobCard(
                  job: state.availableJobs[index],
                  iconData: Icons.chat,
                  onPressed: () {
                    final TextEditingController controller =
                        TextEditingController();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Start conversation'),
                        content: TextField(
                          controller: controller,
                          maxLines: null,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<ChatBloc>().add(
                                    ChatOpenEvent(
                                      job: state.availableJobs[index],
                                      user: (context.read<AuthBloc>().state
                                              as AuthAuthenticatedState)
                                          .user,
                                      message: Message(
                                        text: controller.text,
                                        lamport: 0,
                                      ),
                                    ),
                                  );

                              Navigator.pop(context);
                            },
                            child: const Text('Send'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return const LoadingScreen();
          }
        },
      ),
    );
  }
}
