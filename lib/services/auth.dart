import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:find_the_treasure/models/user_model.dart';
import 'package:find_the_treasure/services/database.dart';
import 'package:find_the_treasure/widgets_common/platform_exception_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';



// class User {
//   final String uid;
//   final String email;
//   final String loginCredential;
//   User({this.email, this.uid, this.loginCredential});
// }

abstract class AuthBase {
  User get currentUser;
  Stream<User> authStateChanges();
  Future<User> signInWithGoogle();
  Future<User> signInWithApple({List<Scope> scopes});
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> validateCurrentPassword({@required String password});
  void updatePassword(String password);
  Future<void> updateEmail(String email);
  // Future<User> signInWithFacebook();
}

class Auth implements AuthBase {
  // Create an instance of each Firebase Auth Class
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  // final FacebookLogin _facebookLogin = FacebookLogin();
  // final Firestore _firestore = Firestore.instance;
  // bool _isIOS = Platform.isIOS;

  @override
  User get currentUser => FirebaseAuth.instance.currentUser;

  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  //   User _userFromFirebase(FirebaseUser user) {
  //   return user != null
  //       ? User(
  //           uid: user.uid,
  //           email: user.email,
  //           loginCredential: _isIOS
  //               ? user.providerData[0].providerId
  //               : user.providerData[1].providerId,
  //         )
  //       : null;
  // }

  @override
  Future<User> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        if (userCredential.additionalUserInfo.isNewUser) {
          await _createUserData(userCredential.user);
        }

        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
            message: 'Missing Google ID token');
      }
    } else {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          final displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(displayName: displayName);
        }
        if (authResult.additionalUserInfo.isNewUser) {
          await _createUserData(authResult.user);
        }

        return firebaseUser;

      case AuthorizationStatus.error:
      
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
        default: throw UnimplementedError();
    }
    
  }

  // Future<User> signInWithFacebook() async {
  //   FacebookLoginResult result = await _facebookLogin.logIn(
  //     ['email', 'public_profile'],
  //   );
  //   if (result.accessToken != null) {
  //     final authResult = await _firebaseAuth.signInWithCredential(
  //       FacebookAuthProvider.getCredential(
  //         accessToken: result.accessToken.token,
  //       ),
  //     );
  //     if (authResult.additionalUserInfo.isNewUser) {
  //       await _createUserData(authResult.user);
  //     }
  //     return _userFromFirebase(authResult.user);
  //   } else {
  //     throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  //   }
  // }

  Future<void> signOut() async {
    await _googleSignIn.signOut();

    // await _facebookLogin.logOut();
    return await _firebaseAuth.signOut();
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult.user;
  }

  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _createUserData(authResult.user);

    return authResult.user;
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return null;
  }

  Future<void> _createUserData(User user) {
    final UserData updateUserData = UserData(
        displayName: user.displayName ?? 'Adventurer',
        locationsExplored: [],
        email: user.email,
        photoURL: user.photoURL,
        uid: user.uid ?? '',
        points: 0,
        userDiamondCount: 50,
        // userKeyCount: 1,
        isAdmin: false,
        seenIntro: false);
    return DatabaseService(uid: user.uid)
        .updateUserData(userData: updateUserData);
  }

  Future<bool> validateCurrentPassword({@required String password}) async {
    AuthCredential authCredentials = EmailAuthProvider.credential(
        email: currentUser.email, password: password);
    try {
      var authResult =
          await currentUser.reauthenticateWithCredential(authCredentials);
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
    currentUser.updatePassword(password);
  }

  Future<void> updateEmail(String email) async {
    return await currentUser.updateEmail(email);
  }
}
