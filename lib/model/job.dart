import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:on_call_work/service/repository_service.dart';

class Job {
  String name;
  String description;
  DateTime from;
  DateTime to;
  num pay;
  bool isAvailable;
  LatLng location;
  String uidEmployer;
  String? uid;

  Job({
    required this.name,
    required this.description,
    required this.from,
    required this.to,
    required this.pay,
    required this.location,
    required this.uidEmployer,
    required this.isAvailable,
    this.uid,
  });

  Job.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        from = json['from'],
        to = json['to'],
        pay = json['pay'],
        location = json['location'],
        uidEmployer = json['uid_employer'],
        uid = json['uid'],
        isAvailable = json['is_available'];

  factory Job.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;

    json['from'] = (json['from'] as Timestamp).toDate();
    json['to'] = (json['to'] as Timestamp).toDate();
    json['location'] =
        LatLng(json['location'].latitude, json['location'].longitude);

    json['uid'] = documentSnapshot.id;
    json['uid_employer'] = (json['uid_employer'] as DocumentReference?)!.id;

    return Job.fromJson(json);
  }

  Map<String, dynamic> get json => {
        'name': name,
        'description': description,
        'from': from,
        'to': to,
        'pay': pay,
        'location': location,
        'uid_employer': uidEmployer,
        'uid': uid,
        'is_available': isAvailable,
      };

  Map<String, dynamic> get firestore {
    Map<String, dynamic> json = this.json;

    json.remove('uid');
    json['from'] = Timestamp.fromDate(from);
    json['to'] = Timestamp.fromDate(to);
    json['location'] = GeoPoint(location.latitude, location.longitude);
    json['uid_employer'] = RepositoryService.users.doc(json['uid_employer']);

    return json;
  }
}
