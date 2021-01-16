import 'package:find_the_treasure/presentation/sign_in/validators.dart';

class PasswordResetModel with EmailAndPasswordValidators {
  final String email;
  final bool isLoading;
  final bool submitted;

  //default values when form is first presented
  PasswordResetModel({
    this.email = '',
    this.isLoading = false,
    this.submitted = false,
  });

  PasswordResetModel copyWith({
    String email,
    bool isLoading,
    bool submitted,
  }) {
    return PasswordResetModel(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }

  // Email and Password validators

  bool get canSubmit {
    return !emailIsEmpty.isValid(email) &&
        emailStringValidator.isValid(email) &&
        !isLoading;
  }

  String get emailErrorText {
    bool showErrorText = !emailIsEmpty.isValid(email) &&
        !emailStringValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }
}
