import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();
// IMPORTANT IF DOCUMENT DOESN"T HAVE TIMESTAMP AS A FIELD WILL HAVE TO INCLUDE ORDERBUY
  Stream<List<T>> collectionStream<T>(
      {@required
          String path,
      String orderBy,
      bool descending,
      @required
          T builder(
        Map<String, dynamic> data,
        String documentId,
      )}) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .orderBy(orderBy ?? 'timestamp', descending: descending ?? true);

    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }

  Stream<List<T>> filteredArrayCollectionStream<T>(
      {@required
          String path,
      @required
          String field,
      @required
          dynamic arrayContains,
      @required
          T builder(
        Map<String, dynamic> data,
        String documentId,
      )}) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .where(field, arrayContains: arrayContains);

    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }

  Stream<List<T>> collectionStreamEqualTo<T>(
      {@required
          String path,
      @required
          String field,
      @required
          bool isEqualTo,
      @required
          T builder(
        Map<String, dynamic> data,
        String documentId,
      )}) {
    final reference = FirebaseFirestore.instance
        .collection(path)
        .where(field, isEqualTo: isEqualTo);

    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();

    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final documentReference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await documentReference.set(
      data,
      SetOptions(merge: true),
    );
  }

  Future<void> deleteData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  // CRUD operations for local storage
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/image.png');
  }
}
