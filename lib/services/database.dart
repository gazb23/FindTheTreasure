import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_treasure/models/avatar_model.dart';
import 'package:find_the_treasure/models/location_model.dart';
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

   //Receive a filtered stream of all quests where the isAdmin contains true
  Stream<List<QuestModel>> questFieldIsAdmin({@required String field, @required isEqualTo}) => _service.collectionStreamEqualTo(
      field: field,
      isEqualTo: isEqualTo,
      path: APIPath.quests(),
      builder: (data, documentId) => QuestModel.fromMap(data, documentId));   

    //Receive a filtered stream of all challenges completed by a user for a given location 
    
  Stream<List<LocationModel>> locationFieldContainsUID({@required String field}) => _service.filteredArrayCollectionStream(
      field: field,
      arrayContains: uid,
      path: APIPath.quests(),
      builder: (data, documentId) => LocationModel.fromMap(data, documentId));    


    // Receive a stream of current user
  Stream<UserData> userStream() => _service.documentStream(
      path: APIPath.user(uid: uid),
      builder: (data, documentId) => UserData.fromMap(data, documentId));

  //Receice a stream of all USERS from Firebase
  Stream<List<UserData>> usersStream() => _service.collectionStream(
    orderBy: 'points',
    descending: true,
      path: APIPath.users(),
      builder: (data, documentId) => UserData.fromMap(data, documentId));    

  // Receive a stream of a single quest
  Stream<QuestModel> questStream({@required String questId}) => _service.documentStream(
      path: APIPath.quest(questId: questId),
      builder: (data, documentId) => QuestModel.fromMap(data, documentId));

  //Receice a stream of all locations for a given quest from Firebase
  Stream<List<LocationModel>> locationsStream({@required String questId}) => _service.collectionStream(
    descending: false,
      path: APIPath.locations(questId: questId),
      builder: (data, documentId) => LocationModel.fromMap(data, documentId));    

    // Receive a stream of a single location
  Stream<LocationModel> locationStream({@required String questId, @required String locationId}) => _service.documentStream(
      path: APIPath.location(questId: questId, locationId: locationId),
      builder: (data, documentId) => LocationModel.fromMap(data, documentId));    

  //Receice a stream of all Challenges for a given location from Firebase
  Stream<List<QuestionsModel>> challengesStream({@required String questId, @required String locationId}) => _service.collectionStream(
    orderBy: 'challengeNumber',
    descending: false,
      path: APIPath.challenges(questId: questId, locationId: locationId),
      builder: (data, documentId) => QuestionsModel.fromMap(data, documentId));    

  //Receice a stream of a single Challenge for a given location from Firebase
  Stream<QuestionsModel> challengeStream({@required String questId, @required String locationId, @required String challengeId}) => _service.documentStream(
      path: APIPath.challenge(questId: questId, locationId: locationId, challengeId: challengeId),
      builder: (data, documentId) => QuestionsModel.fromMap(data, documentId));           


  //WRITE DATA:
  

  // Add UID to likedBy Array on Firebase
   Future<void> arrayUnion(String documentId) async {
   final likedByRef = _db.collection('/quests').document(documentId);
   print('add');
   await likedByRef.updateData({'likedBy': FieldValue.arrayUnion([uid])});
 }
  // Remove UID from likedBy Array on Firebase
  Future<void> arrayRemove(String documentId) async {
   final likedByRef = _db.collection('/quests').document(documentId);
   print('remove');
   await likedByRef.updateData({'likedBy': FieldValue.arrayRemove([uid])});
 }

   // Add UID to chosen field Array on Firebase
   Future<void> arrayUnionField({@required String documentId, @required String field, @required String collectionRef}) async {
   final likedByRef = _db.collection(collectionRef).document(documentId);
   print('add uid');
   await likedByRef.updateData({field: FieldValue.arrayUnion([uid])});
 }
    // Add chosen data to chosen field Array on Firebase
   Future<void> arrayUnionFieldData({@required String documentId, @required String field, @required String collectionRef, @required String data}) async {
   final likedByRef = _db.collection(collectionRef).document(documentId);
   print('add data');
   await likedByRef.updateData({field: FieldValue.arrayUnion([data]) });
 }

    // Remove UID from chosen field Array on Firebase
   Future<void> arrayRemoveField({@required String documentId,  @required String field, @required String collectionRef}) async {
   final likedByRef = _db.collection(collectionRef).document(documentId);
   print('remove uid');
   await likedByRef.updateData({field: FieldValue.arrayRemove([uid])});
 }



    // Update user data
  Future<void> updateUserData({UserData userData}) async => await _service.setData(
    path: APIPath.user(uid: uid),
    data: userData.toMap()
  );

 
 

    // Sets the avatar download url
  Future<void> setAvatarReference(AvatarReference avatarReference) async {
    final path = APIPath.avatar(uid);
    final reference = Firestore.instance.document(path);
    await reference.setData(avatarReference.toMap(), merge: true);
  }

  // Reads the current avatar download url
  Stream<AvatarReference> avatarReferenceStream() {
    final path = APIPath.avatar(uid);
    final reference = Firestore.instance.document(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => AvatarReference.fromMap(snapshot.data));
  }


      
}
