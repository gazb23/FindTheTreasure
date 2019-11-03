abstract class StringValidator {
  bool isNotEmpty(String value);
  
}

class NonEmptyStringValidator implements StringValidator {
  @override
  // return true if the string is not empty
  bool isNotEmpty(String value) {
    return value.isNotEmpty;
  }


  
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = 'Email can\'t be empty';
  final String invalidPasswordErrorText = 'Password must 6 or more characters';
}