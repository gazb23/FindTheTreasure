import 'dart:async';
import 'package:find_the_treasure/models/email_sign_in_model.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:flutter/foundation.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});
  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void disose() => _modelController.close();

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      await auth.signInWithEmailAndPassword(_model.email, _model.password);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(submitted: false, isLoading: false);
    }
  }

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
