class APIPath {  
  
  static String quests() => 'fl_content/';
  static String heartedQuests({String uid}) => 'users/$uid/likedQuests/';

}