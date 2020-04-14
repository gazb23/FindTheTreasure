class UserData {
  final String id;
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final int userDiamondCount;
  final int userKeyCount;
  final int points;
  


  UserData({
    this.id, 
    this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.userDiamondCount,
    this.userKeyCount,
    this.points,  
  }) : assert(UserData != null);


    Map<String, dynamic> toMap() {
    return {      
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'userDiamondCount': userDiamondCount,
      'userKeyCount': userKeyCount,
      'points': points
    
    };
  }



// Use a factory in situations where you don't necessarily want to return a new instance of the class itself

  factory UserData.fromMap(Map data, String documentId) {
    if (data == null) {
   
      return null;
    }
    return UserData(
      id: documentId,
      uid: data['uid'],
      email: data['email'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      userDiamondCount: data['userDiamondCount'],
      userKeyCount: data['userKeyCount'],
      points: data['points'], 
      
    );
  }


}