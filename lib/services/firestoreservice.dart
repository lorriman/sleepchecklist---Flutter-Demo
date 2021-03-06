import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'globals.dart';

/// Copyright Andrea Bozito, with modifications.
/// Additions classes by Greg Lorriman, as noted.

abstract class ADatabaseService {
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  });

  Future<void> deleteDocument({required String path});
  Future<void> deleteField({required String path, required String fieldName});

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  });

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  });
}

//Greg Lorriman
//This is for testing, extends class below, and substitutes a FakeFirebaseFirestore
class FakeFirestoreService extends FirestoreService {
  FakeFirestoreService({required FakeFirebaseFirestore fakeFirestoreInstance})
      : firestoreInstance = fakeFirestoreInstance {
    instance = this;
  }
  @override
  // ignore: overridden_fields
  final FirebaseFirestore firestoreInstance;
  static FirestoreService? instance;
}

class FirestoreService extends ADatabaseService {
  final firestoreInstance = FirebaseFirestore.instance;
  static FirestoreService instance = FirestoreService();

  @override
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = firestoreInstance.doc(path);
    logger.v('try set: $path: $data');
    try {
      await reference.set(data, SetOptions(merge: merge));
    } catch (e, st) {
      logger.e('ERROR', e, st);
      rethrow;
    }
  }

  @override
  Future<void> deleteDocument({required String path}) async {
    final reference = firestoreInstance.doc(path);
    logger.v(
      'try delete: $path',
    );
    try {
      await reference.delete();
    } catch (e, st) {
      logger.e('ERROR', e, st);
      rethrow;
    }
  }

  @override
  Future<void> deleteField(
      {required String path, required String fieldName}) async {
    final reference = firestoreInstance.doc(path);
    logger.v(
      'try deleteField: $path : $fieldName',
    );
    try {
      await reference.update(
        {fieldName: FieldValue.delete()},
      );
    } catch (e, st) {
      logger.e('ERROR', e, st);
      rethrow;
    }
  }

  @override
  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    logger.v('try collectionStream $path');
    Query<Map<String, dynamic>> query = firestoreInstance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  @override
  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    logger.v('try documentStream $path');
    final DocumentReference<Map<String, dynamic>> reference =
        firestoreInstance.doc(path);
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}
