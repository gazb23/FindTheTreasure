import 'package:find_the_treasure/presentation/sign_in/validators.dart';

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.submitted = false,
  });

  final String email;
  final String password;
  final bool isLoading;
  final bool submitted;

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
  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText =
        submitted && !passwordValidator.isValid(password);
        return showErrorText ? invalidPasswordErrorText : null;
  }
  String get emailErrorText {
    bool showErrorText =
        submitted && !emailValidator.isValid(email);
        return showErrorText ? invalidEmailErrorText : null;
  }
}
