import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? uid;
  String name;
  String surname;
  String bio;

  User({
    this.uid,
    required this.name,
    required this.surname,
    required this.bio,
  });

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        surname = json['surname'],
        bio = json['bio'];

  factory User.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;

    json['uid'] = documentSnapshot.id;

    return User.fromJson(json);
  }

  Map<String, dynamic> get json => {
        'uid': uid,
        'name': name,
        'surname': surname,
        'bio': bio,
      };

  Map<String, dynamic> get firestore {
    Map<String, dynamic> json = this.json;

    json.remove('uid');

    return json;
  }
}
