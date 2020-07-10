

import 'package:flutter/foundation.dart';

class APIPath {  
  static String user({String uid}) => 'users/$uid';
  static String users() => 'users';
  static String quests() => 'quests';
  static String faqs() => 'faqs';
  static String quest({@required String questId}) => 'quests/$questId';
  static String locations({@required String questId}) => 'quests/$questId/locations';
  static String location({@required String questId, @required String locationId}) => 'quests/$questId/locations/$locationId';
  static String challenges({@required String questId, @required String locationId}) => 'quests/$questId/locations/$locationId/challenges';
  static String challenge({@required String questId, @required String locationId, @required String challengeId}) => 'quests/$questId/locations/$locationId/challenges/$challengeId';
  static String avatar(String uid) => 'users/$uid';

  

}