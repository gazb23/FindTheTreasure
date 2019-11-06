import 'package:find_the_treasure/presentation/sign_in/validators.dart';

class EmailSignInModel with EmailAndPasswordValidators {
  final String email;
  final String password;
  final bool isLoading;
  final bool submitted;
  
  //default values when form is first presented
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.submitted = false,
  });

  

  EmailSignInModel copyWith({
    String email,
    String password,
    bool isLoading,
    bool submitted
  }) {
    
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }

  // Email and Password validators
  
  bool get canSubmit {
    return !emailIsEmptyValidator.isValid(email) &&
        !passwordValidator.isValid(password) &&
        !isLoading && emailStringValidator.isValid(email) && passwordStringValidator.isValid(password);
  }

    String get emailErrorText {
    bool showErrorText =
        !emailIsEmptyValidator.isValid(email) && !emailStringValidator.isValid(email);
        return showErrorText ? invalidEmailErrorText : null;
  }

  String get passwordErrorText {
    bool showErrorText =
        !passwordValidator.isValid(password) && !passwordStringValidator.isValid(password);
        return showErrorText ? invalidPasswordErrorText : null;
  }



}
