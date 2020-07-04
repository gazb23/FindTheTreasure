import 'package:find_the_treasure/widgets_common/platform_alert_dialog.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({@required String title, @required PlatformException exception}) : super(
    title: title,
    content: _message(exception),
    defaultActionText: 'OK'
  );

  static String _message(PlatformException exception) {
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    //Custom messages on sign in and account creation
  'ERROR_WEAK_PASSWORD' : 'We both know that password isn\'t strong enough! Passwords must be at least 6 characters.',
  'ERROR_USER_NOT_FOUND' : 'Uh Oh! There is no user under that email address.',
  'ERROR_INVALID_EMAIL' : 'Please check your email, you may have made a whoopsy!',
  'ERROR_EMAIL_ALREADY_IN_USE' : 'Umm...This is awkward! That email is already in use by another account, please check your email and try again.',  
  'ERROR_WRONG_PASSWORD' : 'Wrong password, please try again.',
  'ERROR_USER_DISABLED' : 'Your account has been disabled, please contact support for help.',
  'ERROR_TOO_MANY_REQUESTS' : 'You have been locked out! Too many attempts to sign in.',
  'ERROR_OPERATION_NOT_ALLOWED' : 'Indicates that Email & Password accounts are not enabled.',  
  'ERROR_REQUIRES_RECENT_LOGIN' : 'Please logout of the application and re-try after login.',
  'network_error' : 'Please check your network connection and try again.'
};
}

