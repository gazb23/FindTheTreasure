import 'package:profanity_filter/profanity_filter.dart';

abstract class StringValidator {
  bool isValid(String value);
}

class EmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isEmpty;
  }
}

class NameStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return !ProfanityFilter().hasProfanity(value);
  }
}

class EmailStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    String emailValidator = r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(emailValidator);
    return regExp.hasMatch(value);
  }
}

class PasswordStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    bool passwordvalidator = true;
    if (value.length >= 6) {
      return passwordvalidator;
    }
    return false;
  }
}

class EmailAndPasswordValidators {
  final StringValidator nameIsEmpty = EmptyStringValidator();
  final StringValidator emailIsEmpty = EmptyStringValidator();
  final StringValidator passwordIsEmpty = EmptyStringValidator();
  final StringValidator nameStringValidator = NameStringValidator();
  final StringValidator emailStringValidator = EmailStringValidator();
  final StringValidator passwordStringValidator = PasswordStringValidator();

  final String invalidNameErrorText = 'Oh my! Please avoid language like that';
  final String invalidEmailErrorText = 'Hmm, try double-checking your email.';
  final String invalidPasswordErrorText =
      'Whoops, looks like your password is too short';
}
