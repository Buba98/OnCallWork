import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:on_call_work/service/repository_service.dart';

import '../../model/job.dart';
import '../../model/user.dart';

abstract class JobState {}

class JobInitState extends JobState {}

class JobLoadingState extends JobState {}

class JobLoadedState extends JobState {
  List<Job> availableJobs;
  List<Job> ownJobs;

  JobLoadedState({
    required this.availableJobs,
    required this.ownJobs,
  });
}

abstract class JobEvent {}

class JobReloadEvent extends JobEvent {}

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
  final User user;

  JobBloc({
    required this.user,
  }) : super(JobInitState()) {
    on<JobReloadEvent>(_onJobReloadEvent);
    on<JobAddEvent>(_onJobAddEvent);
  }

  _onJobReloadEvent(JobReloadEvent event, Emitter<JobState> emit) async {
    emit(JobLoadingState());

    List<Job> jobs = await RepositoryService.getAvailableJobs();

    List<Job> availableJobs = [];
    List<Job> ownJobs = [];

    for (Job element in jobs) {
      if (element.uidEmployer == user.uid!) {
        ownJobs.add(element);
      } else {
        availableJobs.add(element);
      }
    }

    emit(JobLoadedState(availableJobs: availableJobs, ownJobs: ownJobs));
  }

  _onJobAddEvent(JobAddEvent event, Emitter<JobState> emit) async {
    Job job = Job(
      name: event.name,
      description: event.description,
      from: event.from,
      to: event.to,
      pay: event.pay,
      location: event.location,
      uidEmployer: user.uid!,
      isAvailable: true,
    );
    RepositoryService.addJob(job);
  }
}
