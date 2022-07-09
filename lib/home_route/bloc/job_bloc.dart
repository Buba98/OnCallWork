import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/service/repository_service.dart';

import '../../model/job.dart';

abstract class JobState {}

class JobInitState extends JobState {}

class JobLoadedState extends JobState {
  List<Job> jobs;

  JobLoadedState({required this.jobs});
}

abstract class JobEvent {}

class JobReloadEvent extends JobEvent {}

class JobBloc extends Bloc<JobEvent, JobState> {
  JobBloc() : super(JobInitState()) {
    on<JobReloadEvent>(_onJobReloadEvent);
  }

  _onJobReloadEvent(JobEvent event, Emitter<JobState> emit) async {
    List<QueryDocumentSnapshot> queryDocumentSnapshots =
        await RepositoryService.getDocuments('works');

    List<Job> jobs = [];

    for (QueryDocumentSnapshot snapshot in queryDocumentSnapshots) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      jobs.add(Job.fromJson(data));
    }

    emit(JobLoadedState(jobs: jobs));
  }
}
