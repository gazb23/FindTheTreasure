import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  void updateUserData(FirebaseUser user);
}

class Auth implements AuthBase {
  // Create an instance of each Firebase Auth Class
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  final Firestore _firestore = Firestore.instance;

  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
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
        
         await updateUserData(authResult.user);
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  Future<User> signInWithFacebook() async {
    FacebookLoginResult result = await _facebookLogin.logIn(
      ['email', 'public_profile'],
    );
    if (result.accessToken != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        ),
      );
      await updateUserData(authResult.user);
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _facebookLogin.logOut();
    return await _firebaseAuth.signOut();
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    await updateUserData(authResult.user);
    return _userFromFirebase(authResult.user);
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await updateUserData(authResult.user);
    return _userFromFirebase(authResult.user);
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return null;
  }

  Future<void> updateUserData(FirebaseUser user) async {
    DocumentReference ref = _firestore.collection('users').document(user.uid);

    return ref.setData({
      'uid':user.uid,
      'email':user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName ?? 'Adventure lover',
      'userDiamondCount': '50',
      'userKeyCount': '1',
    }, merge: true);
  }
}
