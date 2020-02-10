import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/questions_model.dart';
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

  //Receive a filtered stream of all quests where the field contains the UID of the current user
  Stream<List<QuestModel>> questFieldContainsUID({@required String field}) => _service.filteredArrayCollectionStream(
      field: field,
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
  Stream<QuestModel> questStream({@required String questId}) => _service.documentStream(
      path: APIPath.quest(questId: questId),
      builder: (data, documentId) => QuestModel.fromMap(data, documentId));

  //Receice a stream of all locations for a given quest from Firebase
  Stream<List<QuestionsModel>> locationsStream({@required String questId}) => _service.collectionStream(
      path: APIPath.locations(questId: questId),
      builder: (data, documentId) => QuestionsModel.fromMap(data, documentId));    

    // Receive a stream of a single location
  Stream<QuestionsModel> locationStream({@required String questId, @required String locationId}) => _service.documentStream(
      path: APIPath.location(questId: questId, locationId: locationId),
      builder: (data, documentId) => QuestionsModel.fromMap(data, documentId));    

  //Receice a stream of all Challenges for a given location from Firebase
  Stream<List<QuestionsModel>> challengesStream({@required String questId, @required String locationId}) => _service.collectionStream(
      path: APIPath.challenges(questId: questId, locationId: locationId),
      builder: (data, documentId) => QuestionsModel.fromMap(data, documentId));    

  //Receice a stream of a single Challenge for a given location from Firebase
  Stream<QuestionsModel> challengeStream({@required String questId, @required String locationId, @required String challengeId}) => _service.documentStream(
      path: APIPath.challenge(questId: questId, locationId: locationId, challengeId: challengeId),
      builder: (data, documentId) => QuestionsModel.fromMap(data, documentId));           


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

   // Add UID to chosen field Array on Firebase
   Future<void> arrayUnionField({@required String documentId, @required String uid, @required String field}) async {
   final likedByRef = _db.collection('/quests').document(documentId);
   print('add');
   await likedByRef.updateData({field: FieldValue.arrayUnion([uid])});
 }

  // Update user diamonds and keys
  Future<void> updateUserDiamondAndKey({UserData userData}) async => await _service.setData(
    path: APIPath.user(uid: uid),
    data: userData.toMap()
  );


  //DELTE DATA:
 




      
}
