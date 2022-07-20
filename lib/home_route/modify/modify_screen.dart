import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/home_route/chat/chat_employer_page.dart';

import '../bloc/job_bloc.dart';
import '../job_card.dart';
import '../loading_screen.dart';

class ModifyScreen extends StatelessWidget {
  const ModifyScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<JobBloc, JobState>(
        builder: (BuildContext context, JobState state) {
          if (state is JobLoadedState) {
            return ListView.builder(
              itemCount: state.ownJobs.length,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: JobCard(
                  job: state.ownJobs[index],
                  iconData: Icons.mode,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatEmployerPage(
                          job: state.ownJobs[index],
                        ),
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
