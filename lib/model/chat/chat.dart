import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_call_work/service/repository_service.dart';

import 'message.dart';

class Chat {
  final String? uid;
  final String uidJob;
  final String uidEmployee;
  final List<Message> messages;

  Chat({
    this.uid,
    required this.uidJob,
    required this.uidEmployee,
    required this.messages,
  });

  Chat.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        uidJob = json['uid_job'],
        uidEmployee = json['uid_employee'],
        messages = Message.fromJsonList(json['messages']);

  factory Chat.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;

    json['uid'] = documentSnapshot.id;
    json['uid_job'] = (json['uid_job'] as DocumentReference?)!.id;
    json['uid_employee'] = (json['uid_employee'] as DocumentReference?)!.id;

    return Chat.fromJson(json);
  }

  Map<String, dynamic> get json => {
        'uid': uid,
        'uid_job': uidJob,
        'uid_employee': uidEmployee,
        'messages': List<Map<String, dynamic>>.generate(
            messages.length, (index) => messages[index].json),
      };

  Map<String, dynamic> get firestore {
    Map<String, dynamic> json = this.json;

    json.remove('uid');

    json['uid_job'] = RepositoryService.jobs.doc(uidJob);
    json['uid_employee'] = RepositoryService.users.doc(uidEmployee);

    return json;
  }
}
