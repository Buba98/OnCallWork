import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:on_call_work/home_route/add/summary_screen.dart';

import 'pay_location_input_screen.dart';
import 'to_input_screen.dart';
import '../bloc/job_bloc.dart';
import 'from_input_screen.dart';
import 'name_description_input_screen.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key, required this.leading}) : super(key: key);

  final Widget leading;

  @override
  State<StatefulWidget> createState() => _AddScreen();
}

class _AddScreen extends State<AddScreen> {
  late String name;
  late String description;

  late num pay;

  late DateTime from;
  late DateTime to;
  late LatLng location;

  int status = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          widget.leading,
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: status / 4,
          ),
          if (status == 0)
            Flexible(
              child: NameDescriptionInputScreen(
                onPressed: (String name, String description) {
                  this.name = name;
                  this.description = description;
                  setState(() => status++);
                },
              ),
            ),
          if (status == 1)
            Flexible(
              child: FromInputScreen(
                onPressed: (DateTime from) {
                  this.from = from;
                  setState(() => status++);
                },
              ),
            ),
          if (status == 2)
            Flexible(
              child: ToInputScreen(
                  onPressed: (DateTime from) {
                    to = from;
                    setState(() => status++);
                  },
                  from: from),
            ),
          if (status == 3)
            Flexible(
              child: PayLocationInputScreen(
                onPressed: (LatLng location, num pay) {
                  this.pay = pay;
                  this.location = location;
                  setState(() => status++);
                },
              ),
            ),
          if (status == 4)
            Flexible(
              child: SummaryScreen(
                name: name,
                location: location,
                pay: pay,
                to: to,
                onPressed: () {
                  context.read<JobBloc>().add(
                        JobAddEvent(
                          name: name,
                          description: description,
                          pay: pay,
                          location: location,
                          from: from,
                          to: to,
                        ),
                      );
                },
                description: description,
                from: from,
              ),
            ),
        ],
      ),
    );
  }
}
