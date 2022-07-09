import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class RepositoryService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
