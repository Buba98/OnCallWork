import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:on_call_work/bloc/auth_bloc.dart';
import 'package:on_call_work/bloc/chat_bloc.dart';
import 'package:on_call_work/model/chat/message.dart';

import '../model/job.dart';

class JobCard extends StatelessWidget {
  JobCard({
    Key? key,
    required this.job,
  }) : super(key: key);

  final Job job;

  final MapController controller = MapController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            FlutterMap(
              mapController: controller,
              options: MapOptions(
                center: LatLng(
                    job.location.latitude,
                    job.location.longitude -
                        7000 /
                            (6378137 *
                                math.cos(
                                    math.pi * job.location.latitude / 180)) *
                            180 /
                            math.pi),
                zoom: 9.0,
                maxZoom: 10.0,
                minZoom: 3.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: job.location,
                      builder: (ctx) => const Icon(Icons.location_on),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: IconButton(
                onPressed: () {
                  final TextEditingController controller =
                      TextEditingController();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Start conversation'),
                      content: TextField(
                        controller: controller,
                        maxLines: null,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<ChatBloc>().add(
                                  ChatOpenEvent(
                                    job: job,
                                    user: (context.read<AuthBloc>().state
                                            as AuthAuthenticatedState)
                                        .user,
                                    message: Message(
                                      text: controller.text,
                                      lamport: 0,
                                    ),
                                  ),
                                );

                            Navigator.pop(context);
                          },
                          child: const Text('Send'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.message),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: RichText(
                text: TextSpan(
                  text: job.name,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: '\n${job.description}',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: '\nPay: ${job.pay}',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: '\nFrom: ${job.from.toString().split(':00')[0]}',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: '\nTo: ${job.to.toString().split(':00')[0]}',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
