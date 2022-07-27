import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_call_work/bloc/auth_bloc.dart';
import 'package:on_call_work/home_route/add/summary_screen.dart';
import 'package:on_call_work/home_route/k_app_bar.dart';

import 'add_bloc.dart';
import 'from_input_screen.dart';
import 'name_description_input_screen.dart';
import 'pay_location_input_screen.dart';
import 'to_input_screen.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddBloc(
          user:
              (context.read<AuthBloc>().state as AuthAuthenticatedState).user),
      child: BlocBuilder<AddBloc, AddState>(
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: KAppBar(
              leadingIcon: state is! AddInitState ? Icons.arrow_back : null,
              leadingOnPressed: state is! AddInitState
                  ? () => context.read<AddBloc>().add(AddBackEvent())
                  : null,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: state is AddInitState
                  ? NameDescriptionInputScreen(state: state)
                  : state is AddFromState
                      ? FromInputScreen(state: state)
                      : state is AddToState
                          ? ToInputScreen(state: state)
                          : state is AddPayLocationState
                              ? PayLocationInputScreen(state: state)
                              : state is AddSummaryState
                                  ? SummaryScreen(state: state)
                                  : throw UnimplementedError(
                                      'Not recognized state'),
            ),
          );
        },
      ),
    );
  }
}
