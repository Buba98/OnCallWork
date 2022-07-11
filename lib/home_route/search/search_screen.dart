import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/job_bloc.dart';
import '../job_card.dart';
import '../loading_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobBloc, JobState>(
      builder: (BuildContext context, JobState state) {
        if (state is JobInitState) {
          context.read<JobBloc>().add(JobReloadEvent());
        }

        if (state is JobLoadedState) {
          return ListView.separated(
            itemCount: state.jobs.length,
            itemBuilder: (context, index) {
              return JobCard(job: state.jobs[index]);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 20,
              );
            },
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
