import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String name;
  String description;
  Timestamp from;
  Timestamp to;
  num pay;
  GeoPoint location;

  Job({
    required this.name,
    required this.description,
    required this.from,
    required this.to,
    required this.pay,
    required this.location,
  });

  Job.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        from = json['from'],
        to = json['to'],
        pay = json['pay'],
        location = json['location'];

  Map<String, dynamic> get json => {
        'name': name,
        'description': description,
        'from': from,
        'to': to,
        'pay': pay,
        'location': location,
      };
}
