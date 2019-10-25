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
  'ERROR_USER_NOT_FOUND' : 'No user under that email',
  'ERROR_INVALID_EMAIL' : 'Please check your email, think you made a whoopsy!',
  'ERROR_EMAIL_ALREADY_IN_USE' : 'Email is already in use by a different account.',  
  'ERROR_WRONG_PASSWORD' : 'Wrong password ya goof!',
  'ERROR_USER_DISABLED' : 'User has been disabled.',
  'ERROR_TOO_MANY_REQUESTS' : 'You have been locke out! Too many attempts to sign in.',
  'ERROR_OPERATION_NOT_ALLOWED' : 'Indicates that Email & Password accounts are not enabled.'
};
}

