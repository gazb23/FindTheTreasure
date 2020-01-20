

class APIPath {  
  static String user(String uid) => 'users/$uid/';
  static String quests() => 'quests/';
  static String quest(String documentId) => 'quests/$documentId/';
  static String locations(String documentId) => 'quests/$documentId/locations/';
  static String challenges(String questDocumentId, String locationDocumentId) => 'quests/$questDocumentId/locations/$locationDocumentId/challenges/';
  

  

}