import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
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

class JobReloadEvent extends JobEvent {
  Completer? completer;

  JobReloadEvent({this.completer});
}

class JobAddEvent extends JobEvent {
  final String name;
  final String description;
  final num pay;
  final LatLng location;
  final DateTime from;
  final DateTime to;

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

  _onJobReloadEvent(JobReloadEvent event, Emitter<JobState> emit) async {
    emit(JobLoadingState());

    List<Job> jobs = await RepositoryService.getAvailableJobs();

    event.completer?.complete();

    emit(JobLoadedState(jobs: jobs));
  }

  _onJobAddEvent(JobAddEvent event, Emitter<JobState> emit) async {
    Job job = Job(
      name: event.name,
      description: event.description,
      from: event.from,
      to: event.to,
      pay: event.pay,
      location: event.location,
      uidOwner: FirebaseAuth.instance.currentUser!.uid,
      isAvailable: true,
    );
    RepositoryService.addJob(job);
  }
}
