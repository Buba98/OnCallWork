import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:on_call_work/home_route/add/add_bloc.dart';
import 'package:on_call_work/home_route/add/widget/summary_row.dart';
import 'package:on_call_work/widget/k_button.dart';

import '../../widget/k_text.dart';

class SummaryScreen extends StatelessWidget {
  final AddSummaryState state;

  const SummaryScreen({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: KText('Summary of the job offer'),
        ),
        SummaryRow.name(text: state.name),
        SummaryRow.description(text: state.description),
        SummaryRow.from(from: state.from),
        SummaryRow.to(to: state.to),
        SummaryRow.pay(pay: state.pay),
        SummaryRow.location(location: state.location),
        const Spacer(
          flex: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: KButton(
            onPressed: () => context.read<AddBloc>().add(AddSummaryEvent()),
            text: 'Confirm',
          ),
        ),
      ],
    );
  }
}
