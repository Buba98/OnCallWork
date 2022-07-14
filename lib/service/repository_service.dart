import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

import '../model/chat/chat.dart';
import '../model/chat/message.dart';
import '../model/job.dart';
import '../model/user.dart' as internal_user;

class RepositoryService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final CollectionReference jobs = _firestore.collection('jobs');
  static final CollectionReference users = _firestore.collection('users');
  static final CollectionReference chats = _firestore.collection('chats');

  static Future<List<Job>> getAvailableJobs() async {
    List<QueryDocumentSnapshot> list =
        (await jobs.where('is_available', isEqualTo: true).get()).docs;

    List<Job> jobList = [];
    Job job;

    for (QueryDocumentSnapshot snapshot in list) {
      job = Job.fromFirestore(snapshot);

      if (job.from.isAfter(DateTime.now())) {
        jobList.add(job);
      }
    }

    return jobList;
  }

  static Future<void> addJob(Job job) async => jobs.add(job.firestore).then(
        (value) => developer.log("Document added: $value"),
      )..catchError(
      (error) => developer.log("Failed to add user: $error"),
    );

  static Future<internal_user.User?> getUserByUid(String uid) async {
    DocumentSnapshot snapshot = await users.doc(uid).get();

    if (!snapshot.exists) {
      return null;
    }

    return internal_user.User.fromDocumentSnapshot(snapshot);
  }

  static Future<void> addUser(internal_user.User user) async =>
      users.doc(user.uid).set(user.firestore).then(
            (value) => developer.log("Document added"),
          )..catchError(
          (error) => developer.log("Failed to add user: $error"),
        );

  static Future<void> updateUser(internal_user.User user) async =>
      users.doc(user.uid).update(user.json).then(
            (value) => developer.log("Document updated"),
          )..catchError(
          (error) => developer.log("Failed to update user: $error"),
        );

  static Stream<List<Chat>> listenChatEmployee() async* {
    Stream chatsStream = chats
        .where('employee', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    await for (final event in chatsStream) {
      List<Chat> chats = [];

      for (QueryDocumentSnapshot snapshot in event.docs) {
        chats.add(Chat.fromFirestore(snapshot));
      }
      yield chats;
    }
  }

  static Stream<List<Chat>> listenChatEmployer() async* {
    Stream chatsStream = chats
        .where('employer', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    await for (final event in chatsStream) {
      List<Chat> chats = [];

      for (QueryDocumentSnapshot snapshot in event.docs) {
        chats.add(Chat.fromFirestore(snapshot));
      }
      yield chats;
    }
  }

  static Future<void> sendMessage(Chat chat, Message newMessage) async =>
      chats.doc(chat.uid).update({
        'messages': FieldValue.arrayUnion([newMessage.json]),
      }).then(
        (value) => developer.log("Document added"),
      )..catchError(
          (error) => developer.log("Failed to add user: $error"),
        );

  static Future<void> openChat(
      Job job, internal_user.User user, Message firstMessage) async {
    Chat chat = Chat(
      uidJob: job.uid!,
      uidEmployee: user.uid!,
      messagesEmployee: [firstMessage],
      messagesEmployer: [],
    );
    return chats.add(chat.firestore).then(
          (value) => developer.log("Document added: $value"),
        )..catchError(
        (error) => developer.log("Failed to add user: $error"),
      );
  }
}
