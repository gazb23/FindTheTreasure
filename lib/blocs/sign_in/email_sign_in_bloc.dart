import 'dart:async';
import 'package:find_the_treasure/models/email_sign_in_model.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:find_the_treasure/widgets_common/platform_exception_alert_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class EmailSignInBloc {
  final AuthBase auth;
  final _modelController = StreamController<EmailSignInModel>();
  EmailSignInBloc({@required this.auth});

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() => _modelController.close();

  void _showSignInError(PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      await auth.signInWithEmailAndPassword(_model.email, _model.password);
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  // Update email sign in model
  void updateWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      isLoading: isLoading,
      submitted: submitted,
    );
    _modelController.add(_model);
  }
}
