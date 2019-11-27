import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;

  UserModel({@required this.uid});



  // Convert QuestModel into a Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid
    };
  }
}
