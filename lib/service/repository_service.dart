import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

import '../model/job.dart';
import '../model/user.dart' as internal_user;

class RepositoryService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final CollectionReference _jobs = _firestore.collection('jobs');
  static final CollectionReference _users = _firestore.collection('users');

  static Future<void> addDocument(
      String collectionPath, Map<String, dynamic> document) {
    return _firestore.collection(collectionPath).add(document).then(
          (value) => developer.log("Document added: $value"),
        )..catchError(
        (error) => developer.log("Failed to add user: $error"),
      );
  }

  static Future<List<QueryDocumentSnapshot>> getDocuments(
      String collectionPath) async {
    CollectionReference collectionReference =
        _firestore.collection(collectionPath);

    return (await collectionReference.get()).docs;
  }

  static Future<List<Job>> getAvailableJobs() async {
    List<QueryDocumentSnapshot> list = (await _jobs.get()).docs;

    List<Job> jobs = [];
    Job job;

    for (QueryDocumentSnapshot snapshot in list) {

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      data['owner_id'] = (data['owner_id'] as DocumentReference?)?.path.split('/')[1];

      job = Job.fromFirestore(data);

      if (job.from.isAfter(DateTime.now())) {
        jobs.add(job);
      }
    }

    return jobs;
  }

  static Future<void> addJob(Job job) async {
    Map<String, dynamic> document = job.firestoreDocument;

    document['owner_id'] = _users.doc(document['owner_id']);

    return _jobs.add(document).then(
          (value) => developer.log("Document added: $value"),
        )..catchError(
        (error) => developer.log("Failed to add user: $error"),
      );
  }

  static Future<internal_user.User?> getUserByUid(String uid) async {
    DocumentSnapshot snapshot = await _users.doc(uid).get();

    if (!snapshot.exists) {
      return null;
    }

    return internal_user.User.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  static Future<void> addUser(internal_user.User user) async =>
      _users.doc(user.uid).set(user.json).then(
            (value) => developer.log("Document added"),
          )..catchError(
          (error) => developer.log("Failed to add user: $error"),
        );

  static Future<void> updateUser(internal_user.User user) async =>
      _users.doc(user.uid).update(user.json).then(
            (value) => developer.log("Document updated"),
          )..catchError(
          (error) => developer.log("Failed to update user: $error"),
        );
}
