import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/job_bloc.dart';
import '../job_card.dart';
import '../loading_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key, required this.leading}) : super(key: key);

  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          leading
        ],
      ),
      body: BlocBuilder<JobBloc, JobState>(
        buildWhen: (JobState previousState, JobState state) =>
            state is! JobLoadingState,
        builder: (BuildContext context, JobState state) {
          if (state is JobInitState) {
            context.read<JobBloc>().add(JobReloadEvent());
          }
          if (state is JobLoadedState) {
            return RefreshIndicator(
              onRefresh: () async {
                Completer completer = Completer();
                context
                    .read<JobBloc>()
                    .add(JobReloadEvent(completer: completer));

                await completer.future;
              },
              child: ListView.builder(
                itemCount: state.jobs.length,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: JobCard(
                    job: state.jobs[index],
                  ),
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
