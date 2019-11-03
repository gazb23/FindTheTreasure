import 'package:find_the_treasure/services/auth.dart';
import 'package:flutter/foundation.dart';


class SocialSignInBloc {
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  SocialSignInBloc({@required this.auth, @required this.isLoading});
  
 
  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;      
      return await signInMethod();
    } catch(e) {
      isLoading.value = false;
      rethrow;
    }
  }


  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
  Future<User> signInWithFacebook() async => await _signIn(auth.signInWithFacebook);
} 