import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

abstract class FirestoreModel extends FirestoreElement {
  String? uid;
  FirebaseModelState state;

  FirestoreModel({
    this.uid,
    required this.state,
  });

  CollectionReference get collectionReference;
}

abstract class FirestoreElement {
  Map<String, dynamic> get json;

  set firestore(Map<String, dynamic> firestore);

  Map<String, dynamic> get firestore {
    Map<String, dynamic> firestore = json;

    firestore.map(
      (key, value) => MapEntry(
        key,
        _converter(value),
      ),
    );

    return firestore;
  }

  _converter(dynamic value) {
    if (value is num || value is String || value is bool) {
      return value;
    } else if (value is FirestoreModel) {
      return value.collectionReference.doc(value.uid);
    } else if (value is List) {
      return value.map((e) => _converter(e));
    } else if (value is Map<String, dynamic>) {
      return value.map(
        (key, value) => MapEntry(
          key,
          _converter(value),
        ),
      );
    } else if (value is DateTime) {
      return Timestamp.fromDate(value);
    } else if (value is LatLng) {
      return GeoPoint(value.latitude, value.longitude);
    } else if (value is FirestoreElement) {
      return value.firestore;
    } else {
      throw FirestoreTypeException(value);
    }
  }
}

class FirestoreTypeException implements Exception {
  final dynamic cause;

  FirestoreTypeException(this.cause);
}

enum FirebaseModelState {
  notLoaded,
  loaded,
  modified,
  created,
}
