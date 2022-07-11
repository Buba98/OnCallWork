import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Job {
  String name;
  String description;
  DateTime from;
  DateTime to;
  num pay;
  LatLng location;
  String ownerId;

  Job({
    required this.name,
    required this.description,
    required this.from,
    required this.to,
    required this.pay,
    required this.location,
    required this.ownerId,
  });

  Job.fromFirestore(Map<String, dynamic> document)
      : name = document['name'],
        description = document['description'],
        from = (document['from'] as Timestamp).toDate(),
        to = (document['from'] as Timestamp).toDate(),
        pay = document['pay'],
        location = LatLng((document['location'] as GeoPoint).latitude,
            (document['location'] as GeoPoint).latitude),
        ownerId = document['owner_id'];

  Job.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        from = json['from'],
        to = json['to'],
        pay = json['pay'],
        location = json['location'],
        ownerId = json['owner_id'];

  Map<String, dynamic> get json => {
        'name': name,
        'description': description,
        'from': from,
        'to': to,
        'pay': pay,
        'location': location,
        'owner_id': ownerId,
      };

  Map<String, dynamic> get firestoreDocument => {
        'name': name,
        'description': description,
        'from': Timestamp.fromDate(from),
        'to': Timestamp.fromDate(to),
        'pay': pay,
        'location': GeoPoint(location.latitude, location.longitude),
        'owner_id': ownerId,
      };
}
