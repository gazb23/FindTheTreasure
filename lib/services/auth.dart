import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class User {
  User({this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;  
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<void> signOut();
}

class Auth implements AuthBase {

  // Create an instance of each Firebase Auth Class
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  
  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

  // onAuthStateChanged receives a FirebaseUser each time the user signs in or signs out. To remove dependency for the FireBase package we return a User class instead by calling the userFromFirebase method.
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }


  Future<User> signInWithGoogle() async {
    
    final googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw StateError('Missing Google Auth Token');
      }
    } else {
      throw StateError('Google sign in aborted');
    }
  }

  Future<User> signInWithFacebook() async {
    
    FacebookLoginResult result = await _facebookLogin.logIn(
      ['email','public_profile'],
    );
    if (result.accessToken != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        ),
      );

      return _userFromFirebase(authResult.user);
    } else {
      throw StateError('Missing Facebook access token');
    }
  }

  Future<void> signOut() async {    
    await _googleSignIn.signOut();    
    await _facebookLogin.logOut();
    return await _firebaseAuth.signOut();
  }
}
