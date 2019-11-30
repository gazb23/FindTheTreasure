import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  final String uid;
  DatabaseService({@required this.uid}) : assert(uid != null);

  final _service = FirestoreService.instance;
  final _db = Firestore.instance;
  //Read data from Firebase
  Stream<List<QuestModel>> questsStream() => _service.collectionStream(
      path: APIPath.quests(),
      builder: (data, documentId) => QuestModel.fromMap(data));

  Stream<UserData> userDataStream() {
    return _db.collection('users').document(uid).snapshots().map(
          (snapshot) {
            if (snapshot.data == null)
            return null;
            else {
              return UserData.fromMap(snapshot.data);
            }
          } 
          
        );
        
  } 

  //Write data to firebase
  Future<void> userLikedQuest(Map<String, dynamic> userQuest) async {
    final path = 'users/$uid/';
    final documentReference = Firestore.instance.document(path);
    await documentReference.setData(userQuest, merge: true);
  }
}
