class UserData {
  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final int userDiamondCount;
  final int userKeyCount;
  


  UserData( {
    this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.userDiamondCount,
    this.userKeyCount,
    
  }) : assert(UserData != null);

// Use a factory in situations where you don't necessarily want to return a new instance of the class itself
  factory UserData.fromMap(Map data) {
    return UserData(
      uid: data['uid'],
      email: data['email'],
      displayName: data['displayName'] != null ? data['displayName'] : 'Adventure King',
      photoURL: data['photoURL'],
      userDiamondCount: data['userDiamondCount'] != null ? data['userDiamondCount'] : 50,
      userKeyCount: data['userKeyCount'] != null ? data['userKeyCount'] : 1,
      
    );
  }
}
