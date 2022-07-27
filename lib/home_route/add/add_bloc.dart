import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:on_call_work/model/job.dart';
import 'package:on_call_work/service/repository_service.dart';

import '../../model/user.dart';

class AddEvent {}

class AddInitEvent extends AddEvent {}

class AddNameDescriptionEvent extends AddEvent {
  final String name;
  final String description;

  AddNameDescriptionEvent({
    required this.name,
    required this.description,
  });
}

class AddFromEvent extends AddEvent {
  final DateTime from;

  AddFromEvent({
    required this.from,
  });
}

class AddToEvent extends AddEvent {
  final DateTime to;

  AddToEvent({
    required this.to,
  });
}

class AddPayLocationEvent extends AddEvent {
  final num pay;
  final LatLng location;

  AddPayLocationEvent({
    required this.pay,
    required this.location,
  });
}

class AddSummaryEvent extends AddEvent {}

class AddState {
  final int status;

  AddState({required this.status});
}

class AddBackEvent extends AddEvent {}

class AddInitState extends AddState {
  final String? name;
  final String? description;

  final bool isNameMissing;
  final bool isDescriptionMissing;

  AddInitState({
    required this.name,
    required this.description,
    this.isNameMissing = false,
    this.isDescriptionMissing = false,
  }) : super(status: 0);
}

class AddFromState extends AddState {
  final DateTime? from;
  final bool isDateFromBeforeNow;

  AddFromState({
    required this.from,
    this.isDateFromBeforeNow = false,
  }) : super(status: 1);
}

class AddToState extends AddState {
  final DateTime? to;
  final DateTime from;
  final bool isDateToBeforeFrom;

  AddToState({
    required this.to,
    required this.from,
    this.isDateToBeforeFrom = false,
  }) : super(status: 2);
}

class AddPayLocationState extends AddState {
  final num? pay;
  final LatLng? location;
  final bool isPayBelowZero;

  AddPayLocationState({
    required this.pay,
    required this.location,
    this.isPayBelowZero = false,
  }) : super(status: 3);
}

class AddSummaryState extends AddState {
  final String name;
  final String description;

  final num pay;

  final DateTime from;
  final DateTime to;
  final LatLng location;

  AddSummaryState({
    required this.name,
    required this.description,
    required this.pay,
    required this.from,
    required this.to,
    required this.location,
  }) : super(status: 4);
}

class AddBloc extends Bloc<AddEvent, AddState> {
  final User user;

  String? name;
  String? description;

  num? pay;

  DateTime? from;
  DateTime? to;
  LatLng? location;

  AddBloc({required this.user})
      : super(AddInitState(
          description: null,
          name: null,
        )) {
    on<AddInitEvent>(_onAddInitEvent);
    on<AddNameDescriptionEvent>(_onAddNameDescriptionEvent);
    on<AddFromEvent>(_onAddFromEvent);
    on<AddToEvent>(_onAddToEvent);
    on<AddPayLocationEvent>(_onAddPayLocationEvent);
    on<AddSummaryEvent>(_onAddSummaryEvent);
    on<AddBackEvent>(_onAddBackEvent);
  }

  _onAddInitEvent(AddInitEvent event, Emitter<AddState> emit) {
    name = null;
    description = null;
    pay = null;
    from = null;
    to = null;
    location = null;

    emit(AddInitState(
      name: name,
      description: description,
    ));
  }

  _onAddNameDescriptionEvent(
      AddNameDescriptionEvent event, Emitter<AddState> emit) {
    if (event.name.isEmpty || event.description.isEmpty) {
      emit(AddInitState(
        name: name,
        description: description,
        isNameMissing: event.name.isEmpty,
        isDescriptionMissing: event.description.isEmpty,
      ));
    } else {
      name = event.name;
      description = event.description;

      emit(AddFromState(
        from: from,
      ));
    }
  }

  _onAddFromEvent(AddFromEvent event, Emitter<AddState> emit) {
    if (event.from.isBefore(DateTime.now())) {
      emit(AddFromState(
        from: from,
        isDateFromBeforeNow: true,
      ));
    } else {
      from = event.from;

      emit(AddToState(
        from: from!,
        to: to,
      ));
    }
  }

  _onAddToEvent(AddToEvent event, Emitter<AddState> emit) {
    if (event.to.isBefore(from!)) {
      emit(AddToState(to: to, from: from!, isDateToBeforeFrom: true));
    } else {
      to = event.to;

      emit(AddPayLocationState(
        location: location,
        pay: pay,
      ));
    }
  }

  _onAddPayLocationEvent(AddPayLocationEvent event, Emitter<AddState> emit) {
    if (event.pay <= 0) {
      emit(AddPayLocationState(
          pay: pay, location: location, isPayBelowZero: true));
    } else {
      pay = event.pay;
      location = event.location;

      emit(AddSummaryState(
        name: name!,
        description: description!,
        pay: pay!,
        from: from!,
        to: to!,
        location: location!,
      ));
    }
  }

  _onAddSummaryEvent(AddSummaryEvent event, Emitter<AddState> emit) async {
    await RepositoryService.addJob(Job(
      name: name!,
      description: description!,
      from: from!,
      to: to!,
      pay: pay!,
      location: location!,
      uidEmployer: user.uid!,
      isAvailable: true,
    ));

    add(AddInitEvent());
  }

  _onAddBackEvent(AddBackEvent event, Emitter<AddState> emit) {
    if (state is AddFromState) {
      emit(AddInitState(name: name, description: description));
    } else if (state is AddToState) {
      emit(AddFromState(from: from));
    } else if (state is AddPayLocationState) {
      emit(AddToState(to: to, from: from!));
    } else if (state is AddSummaryState) {
      emit(AddPayLocationState(pay: pay, location: location));
    }
  }
}
