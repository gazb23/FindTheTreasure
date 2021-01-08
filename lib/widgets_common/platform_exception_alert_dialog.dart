import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({@required String title, @required Exception exception}) : super(
    title: title,
    content: _message(exception),
    defaultActionText: 'OK'
  );

  static String _message(Exception exception) {
   if (exception is FirebaseException) {
      return _errors[exception.code] ?? exception.message;
    }
    return exception.toString();
  }

  static Map<String, String> _errors = {
    //Custom messages on sign in and account creation
  'weak-password' : 'We both know that password isn\'t strong enough! Passwords must be at least 6 characters.',
  'user-not-found' : 'Uh Oh! There is no user under that email address.',
  'invalid-email' : 'Please check your email, you may have made a whoopsy!',
  'email-already-in-use' : 'Umm...This is awkward! That email is already in use by another account, please check your email and try again.',  
  'wrong-password' : 'Wrong password, please try again.',
  'user-disabled' : 'Your account has been disabled, please contact support for help.',
  'too-many-requests' : 'You have been locked out! Too many attempts to sign in.',
  'operation-not-allowed' : 'Indicates that Email & Password accounts are not enabled.',  
  'requires-recent-login' : 'Please logout of the application and re-try after login.',
  'network-error' : 'Please check your network connection and try again.'
};
}

