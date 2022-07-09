import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/service/repository_service.dart';

import '../../model/job.dart';

abstract class JobState {}

class JobInitState extends JobState {}

class JobLoadingState extends JobState {}

class JobLoadedState extends JobState {
  List<Job> jobs;

  JobLoadedState({required this.jobs});
}

abstract class JobEvent {}

class JobReloadEvent extends JobEvent {}

class JobAddEvent extends JobEvent {
  final String name;
  final String description;
  final num pay;
  final GeoPoint location;
  final Timestamp from;
  final Timestamp to;

  JobAddEvent({
    required this.name,
    required this.description,
    required this.pay,
    required this.location,
    required this.from,
    required this.to,
  });
}

class JobBloc extends Bloc<JobEvent, JobState> {
  JobBloc() : super(JobInitState()) {
    on<JobReloadEvent>(_onJobReloadEvent);
    on<JobAddEvent>(_onJobAddEvent);
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

  _onJobAddEvent(JobEvent event, Emitter<JobState> emit) async {

    print(1);

    if (event is JobAddEvent) {
      print(2);
      Job job = Job(
          name: event.name,
          description: event.description,
          from: event.from,
          to: event.to,
          pay: event.pay,
          location: event.location);
      RepositoryService.addDocument('works', job.json);
    }
  }
}
