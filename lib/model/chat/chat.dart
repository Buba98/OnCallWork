import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_call_work/service/repository_service.dart';

import 'message.dart';

class Chat {
  final String? uid;
  final String uidJob;
  final String uidEmployee;
  final String uidEmployer;
  final List<Message> messagesEmployer;
  final List<Message> messagesEmployee;

  Chat({
    this.uid,
    required this.uidJob,
    required this.uidEmployee,
    required this.uidEmployer,
    required this.messagesEmployee,
    required this.messagesEmployer,
  });

  Chat.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        uidJob = json['uid_job'],
        uidEmployee = json['uid_employee'],
        uidEmployer = json['uid_employer'],
        messagesEmployer = Message.fromJsonList(json['messages_employer']),
        messagesEmployee = Message.fromJsonList(json['messages_employee']);

  factory Chat.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;

    json['uid'] = documentSnapshot.id;
    json['uid_job'] = (json['uid_job'] as DocumentReference?)!.id;
    json['uid_employee'] = (json['uid_employee'] as DocumentReference?)!.id;
    json['uid_employer'] = (json['uid_employer'] as DocumentReference?)!.id;

    return Chat.fromJson(json);
  }

  Map<String, dynamic> get json => {
        'uid': uid,
        'uid_job': uidJob,
        'uid_employee': uidEmployee,
        'uid_employer': uidEmployer,
        'messages_employee': List<Map<String, dynamic>>.generate(
            messagesEmployee.length, (index) => messagesEmployee[index].json),
        'messages_employer': List<Map<String, dynamic>>.generate(
            messagesEmployer.length, (index) => messagesEmployer[index].json),
      };

  Map<String, dynamic> get firestore {
    Map<String, dynamic> json = this.json;

    json.remove('uid');

    json['uid_job'] = RepositoryService.jobs.doc(uidJob);
    json['uid_employee'] = RepositoryService.users.doc(uidEmployee);
    json['uid_employer'] = RepositoryService.users.doc(uidEmployer);

    return json;
  }

  static void updateChat(List<Chat> chats, List<Chat> update) {
    int i;
    for (Chat chat in chats) {
      i = 0;
      while (i < update.length) {
        if (chat.uid! == update[i].uid) {
          chat.messagesEmployee.addAll(update[i].messagesEmployee);
          chat.messagesEmployer.addAll(update[i].messagesEmployer);
          update.removeAt(i);
        } else {
          i++;
        }
      }
    }

    chats.addAll(update);
  }
}
