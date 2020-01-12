import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/firestore_service.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  final String uid;

  DatabaseService({@required this.uid}) : assert(uid != null);

  final _service = FirestoreService.instance;
  final _db = Firestore.instance;

  //READ DATA:
  //Receice a stream of all quests from Firebase
  Stream<List<QuestModel>> questsStream() => _service.collectionStream(
      path: APIPath.quests(),
      builder: (data, documentId) => QuestModel.fromMap(data, documentId));

  //Receive a filtered stream of all quests liked by current user
  Stream<List<QuestModel>> userLikedQuestsStream() => _service.filteredArrayCollectionStream(
      field: 'likedBy',
      arrayContains: uid,
      path: APIPath.quests(),
      builder: (data, documentId) => QuestModel.fromMap(data, documentId));

  // Receive a stream of the current user
  Stream<UserData> userDataStream() {
    return _db.collection('users').document(uid).snapshots().map((snapshot) {
      if (snapshot.data == null)
        return null;
      else {
        return UserData.fromMap(snapshot.data);
      }
    });
  }

  // Receive a stream of a single quest
  Stream<QuestModel> questStream({@required String documentId}) => _service.documentStream(
      path: APIPath.quest(documentId),
      builder: (data, documentId) => QuestModel.fromMap(data, documentId));


  //WRITE DATA:
  // Add UID to likedBy Array on Firebase
   Future<void> arrayUnion(String documentId, String uid) async {
   final likedByRef = _db.collection('/quests').document(documentId);
   print('add');
   await likedByRef.updateData({'likedBy': FieldValue.arrayUnion([uid])});
 }
  // Remove UID from likedBy Array on Firebase
  Future<void> arrayRemove(String documentId, String uid) async {
   final likedByRef = _db.collection('/quests').document(documentId);
   print('remove');
   await likedByRef.updateData({'likedBy': FieldValue.arrayRemove([uid])});
 }



  //DELTE DATA:
 




      
}
