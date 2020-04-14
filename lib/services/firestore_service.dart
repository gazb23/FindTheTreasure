import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
    final reference = Firestore.instance.collection(path).orderBy(orderBy ?? 'timestamp',descending: descending ?? true);

    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map((snapshot) => builder(snapshot.data, snapshot.documentID))
        .toList());
  }

  Stream<List<T>> filteredArrayCollectionStream<T>(
      {@required
          String path,
      @required
          String field,
      @required
          String arrayContains,
      @required
          T builder(
        Map<String, dynamic> data,
        String documentId,
      )}) {
    final reference = Firestore.instance
        .collection(path)
        .where(field, arrayContains: arrayContains);

    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map((snapshot) => builder(snapshot.data, snapshot.documentID))
        .toList());
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = Firestore.instance.document(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    
    return snapshots
        .map((snapshot) => builder(snapshot.data, snapshot.documentID));
  }

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final documentReference = Firestore.instance.document(path);
    print('$path: $data');
    await documentReference.setData(data, merge: true);
    
  }


  Future<void> deleteData({@required String path}) async {
    final reference = Firestore.instance.document(path);
    print('delete: $path');
    await reference.delete();
  }
}
