class APIPath {  
  
  static String quests() => 'quests/';
  static String heartedQuests({String uid}) => 'users/$uid/likedQuests/';

}