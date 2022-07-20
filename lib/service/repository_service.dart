import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as developer;

import '../model/chat/chat.dart';
import '../model/chat/message.dart';
import '../model/job.dart';
import '../model/user.dart' as internal_user;

class RepositoryService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static final CollectionReference jobs = _firestore.collection('jobs');
  static final CollectionReference users = _firestore.collection('users');
  static final CollectionReference chats = _firestore.collection('chats');
  static final Reference baseStorage = _storage.ref('user');

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

  static Future<void> addJob(Job job) async =>
      jobs.add(job.firestore).then(
            (value) => developer.log("Document added: $value"),
      )
        ..catchError(
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
      )
        ..catchError(
              (error) => developer.log("Failed to add user: $error"),
        );

  static Future<void> updateUser(internal_user.User user) async =>
      users.doc(user.uid).update(user.json).then(
            (value) => developer.log("Document updated"),
      )
        ..catchError(
              (error) => developer.log("Failed to update user: $error"),
        );

  static Stream<List<Chat>> listenChatEmployee() {
    StreamController<List<Chat>> stream = StreamController();

    chats.where('uid_employee',
        isEqualTo: users.doc(FirebaseAuth.instance.currentUser!.uid))
      ..get().then((QuerySnapshot value) {
        List<Chat> chatList = [];

        for (QueryDocumentSnapshot snapshot in value.docs) {
          chatList.add(Chat.fromFirestore(snapshot));
        }
        stream.add(chatList);
      })
      ..snapshots().listen((QuerySnapshot event) {
        List<Chat> chatList = [];

        for (QueryDocumentSnapshot snapshot in event.docs) {
          chatList.add(Chat.fromFirestore(snapshot));
        }
        stream.add(chatList);
      });

    return stream.stream;
  }

  static Stream<List<Chat>> listenChatEmployer() {
    StreamController<List<Chat>> stream = StreamController();

    chats.where('uid_employer',
        isEqualTo: users.doc(FirebaseAuth.instance.currentUser!.uid))
      ..get().then((QuerySnapshot value) {
        List<Chat> chatList = [];

        for (QueryDocumentSnapshot snapshot in value.docs) {
          chatList.add(Chat.fromFirestore(snapshot));
        }
        stream.add(chatList);
      })
      ..snapshots().listen((QuerySnapshot event) {
        List<Chat> chatList = [];

        for (QueryDocumentSnapshot snapshot in event.docs) {
          chatList.add(Chat.fromFirestore(snapshot));
        }
        stream.add(chatList);
      });

    return stream.stream;
  }

  static Future<void> sendMessage(Chat chat, Message newMessage) async =>
      chats.doc(chat.uid).update({
        'messages': FieldValue.arrayUnion([newMessage.json]),
      }).then(
            (value) => developer.log("Document added"),
      )
        ..catchError(
              (error) => developer.log("Failed to add user: $error"),
        );

  static Future<void> openChat(Job job, internal_user.User user,
      Message firstMessage) async {
    Chat chat = Chat(
      uidJob: job.uid!,
      uidEmployee: user.uid!,
      messagesEmployee: [firstMessage],
      messagesEmployer: [],
      uidEmployer: job.uidEmployer,
    );
    return chats.add(chat.firestore).then(
          (value) => developer.log("Document added: $value"),
    )
      ..catchError(
            (error) => developer.log("Failed to add user: $error"),
      );
  }

  static Future<String?> getProfilePicture(internal_user.User user) async {
    try {
      String string = await baseStorage
          .child(user.uid!)
          .child('profile.png')
          .getDownloadURL();

      return string;
    } on FirebaseException catch (e) {
      developer.log('Failed to get profile picture: $e');
    } catch (e) {
      developer.log('$e');
    }
    return null;
  }

  static updateProfilePicture(internal_user.User user, XFile picture) async {
    try {
      await baseStorage
          .child(user.uid!)
          .child('profile.png')
          .putData(await picture.readAsBytes());
    } catch (e) {
      developer.log("Failed to upload profile picture: $e");
    }
  }
}
