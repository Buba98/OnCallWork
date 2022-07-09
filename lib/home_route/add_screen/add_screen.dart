import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:on_call_work/home_route/add_screen/pay_location_input_screen.dart';
import 'package:on_call_work/home_route/add_screen/summary_screen.dart';
import 'package:on_call_work/home_route/add_screen/to_input_screen.dart';

import '../bloc/job_bloc.dart';
import 'from_input_screen.dart';
import 'name_description_input_screen.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

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
        automaticallyImplyLeading: false,
        leading: status > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => status--),
              )
            : null,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (status + 1) / 5,
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
                          location:
                              GeoPoint(location.latitude, location.longitude),
                          from: Timestamp.fromDate(from),
                          to: Timestamp.fromDate(to),
                        ),
                      );
                },
                description: '',
                from: from,
              ),
            ),
        ],
      ),
    );
  }
}
