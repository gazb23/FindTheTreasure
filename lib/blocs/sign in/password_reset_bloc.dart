import 'dart:async';
import 'package:find_the_treasure/models/password_reset_model.dart';
import 'package:find_the_treasure/services/auth.dart';
import 'package:flutter/foundation.dart';

class PasswordResetBloc {
  
  final AuthBase auth;
  PasswordResetBloc({@required this.auth});

  final  _modelController = StreamController<PasswordResetModel>();
  Stream<PasswordResetModel> get modelStream => _modelController.stream;
  PasswordResetModel _model = PasswordResetModel();

  void dispose() => _modelController.close();

  
  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      await auth.resetPassword(_model.email);
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    } 
  }

  void updateEmail(String email) => updateWith(email: email);
  


  // Update email sign in model
  void updateWith({
    String email,    
    bool isLoading,
    bool submitted,
  }) {
    _model = _model.copyWith(
      email: email,      
      isLoading: isLoading,
      submitted: submitted,
    );
    _modelController.add(_model);
  }
}
