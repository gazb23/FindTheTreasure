import 'package:find_the_treasure/presentation/sign_in/validators.dart';

class EmailSignInModel with EmailAndPasswordValidators {
  final String name;
  final String email;
  final String password;
  final bool isLoading;
  final bool submitted;
  
  //default values when form is first presented
  EmailSignInModel({
    this.name = '', 
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.submitted = false,
  });

  

  EmailSignInModel copyWith({
    String name,
    String email,
    String password,
    bool isLoading,
    bool submitted
  }) {
    
    return EmailSignInModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }

  // Name, Email and Password validators
  
  bool get canSubmitCreateAccount {
    return !nameIsEmpty.isValid(name) && !emailIsEmpty.isValid(email) &&
        !passwordIsEmpty.isValid(password) &&
        !isLoading && 
        nameStringValidator.isValid(name) && emailStringValidator.isValid(email) 
        && passwordStringValidator.isValid(password);
  }

    bool get canSubmitSignIn {
    return  !emailIsEmpty.isValid(email) &&
        !passwordIsEmpty.isValid(password) &&
        !isLoading && 
        emailStringValidator.isValid(email) 
        && passwordStringValidator.isValid(password);
  }

    
 
        String get nameErrorText {
    bool showErrorText =
        !nameIsEmpty.isValid(name) && !nameStringValidator.isValid(name);
        return showErrorText ? invalidNameErrorText : null;
  }
    
    String get emailErrorText {
    bool showErrorText =
        !emailIsEmpty.isValid(email) && !emailStringValidator.isValid(email);
        return showErrorText ? invalidEmailErrorText : null;
  }

  String get passwordErrorText {
    bool showErrorText =
        !passwordIsEmpty.isValid(password) && !passwordStringValidator.isValid(password);
        return showErrorText ? invalidPasswordErrorText : null;
  }



}
