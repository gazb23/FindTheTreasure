import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User({this.uid});
  final String uid;
}

abstract class AuthBase {
  
  Future<User> signInAnonymously();
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
}
class Auth implements AuthBase {
  // Create an instance of the Firebase Auth Class
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

/// onAuthStateChanged receives a [FirebaseUser] each time the user signIn or signOut. To remove dependency for the FireBase package we return a User class instead.
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }
  
  Future<User> signInAnonymously() async {
    FirebaseUser user = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(user);
  }
  Future<User> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}