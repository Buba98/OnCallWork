import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({
    Key? key,
    required this.name,
    required this.description,
    required this.from,
    required this.to,
    required this.pay,
    required this.location,
    required this.onPressed,
  }) : super(key: key);

  final String name;
  final String description;
  final DateTime from;
  final DateTime to;
  final num pay;
  final LatLng location;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text('Summary of the job offer'),
        ),
        Text(name),
        const Spacer(
          flex: 1,
        ),
        Text(description),
        const Spacer(
          flex: 1,
        ),
        Text(from.toString()),
        const Spacer(
          flex: 1,
        ),
        Text(to.toString()),
        const Spacer(
          flex: 1,
        ),
        Text(pay.toString()),
        const Spacer(
          flex: 1,
        ),
        Text(location.toString()),
        const Spacer(
          flex: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: ElevatedButton(
            onPressed: onPressed,
            child: const Text('Confirm'),
          ),
        ),
      ],
    );
  }
}
