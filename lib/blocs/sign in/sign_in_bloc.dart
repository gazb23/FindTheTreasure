import 'package:find_the_treasure/services/auth.dart';
import 'package:flutter/foundation.dart';


class SocialSignInBloc {
  final AuthBase auth;
  SocialSignInBloc({@required this.auth});
  

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      return await signInMethod();
    } catch(e) {
      rethrow;
    }
  }


  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
  Future<User> signInWithFacebook() async => await _signIn(auth.signInWithFacebook);
} 