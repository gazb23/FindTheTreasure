import 'package:find_the_treasure/models/quest_model.dart';
import 'package:find_the_treasure/services/api_paths.dart';
import 'package:find_the_treasure/services/firestore_service.dart';
import 'package:flutter/foundation.dart';


abstract class Database {
  Stream<List<QuestModel>> questsStream();
}

class FireStoreDatabase implements Database {
  final String uid;

  FireStoreDatabase({@required this.uid}) : assert(uid != null);

  final _service = FirestoreService.instance;

  //Read data from Firebase
  Stream<List<QuestModel>> questsStream() => _service.collectionStream(
    path: APIPath.quests(uid),
    builder: (data,documentId) => QuestModel.fromMap(data, documentId)
  );



  // Write data to Firebase


}
