import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/platform_exception_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:io';

class User {
  final String uid;
  final String email;
  final String loginCredential;
  User({this.email, this.uid, this.loginCredential});
}

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> validateCurrentPassword({@required String password});
  void updatePassword(String password);
  Future<void> updateEmail(String email);
}

class Auth implements AuthBase {
  // Create an instance of each Firebase Auth Class
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  // final Firestore _firestore = Firestore.instance;
  bool _isIOS = Platform.isIOS;

  User _userFromFirebase(FirebaseUser user) {
    
    return user != null
        ? User(
            uid: user.uid,
            email: user.email,
            loginCredential: _isIOS
                ? user.providerData[0].providerId
                : user.providerData[1].providerId,
          )
          
        : null;
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
        if (authResult.additionalUserInfo.isNewUser) {
          await _createUserData(authResult.user);
        }

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
      if (authResult.additionalUserInfo.isNewUser) {
        await _createUserData(authResult.user);
      }
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
    return _userFromFirebase(authResult.user);
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _createUserData(authResult.user);

    return _userFromFirebase(authResult.user);
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return null;
  }

  Future<void> _createUserData(FirebaseUser user) {
    final UserData updateUserData = UserData(
        displayName: user.displayName ?? 'Adventurer',
        locationsExplored: [],
        email: user.email,
        photoURL: user.photoUrl,
        uid: user.uid ?? '',
        points: 0,
        userDiamondCount: 50,
        userKeyCount: 1,
        isAdmin: false,
        seenIntro: false);
    return DatabaseService(uid: user.uid)
        .updateUserData(userData: updateUserData);
  }

  Future<bool> validateCurrentPassword({@required String password}) async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    AuthCredential authCredentials = EmailAuthProvider.getCredential(
        email: firebaseUser.email, password: password);
    try {
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Error!',
        exception: e,
      );

      return false;
    }
  }

  void updatePassword(String password) async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();

    firebaseUser.updatePassword(password);
  }

  Future<void> updateEmail(String email) async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();

    return await firebaseUser.updateEmail(email);
  }
}
