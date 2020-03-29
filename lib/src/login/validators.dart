abstract class StringValidator{
  bool isValid(String value);
}
class NonEmptyStringValidator implements StringValidator{

  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidator {
  final StringValidator emailValidator=NonEmptyStringValidator();
  final StringValidator passwordValidator=NonEmptyStringValidator();
  final String invalidEmailErrorText='Email can\'t be empty';
  final String invalidPasswordErrorText='Password can\'t be empty';
}

class LengthValidator implements StringValidator{
@override
  bool isValid(String value){
    return value.length == 10;
  }
}

class PhoneValidator{

  final String invalidPhoneErrorText='Phone number must be of 10 digits';
  final phoneValidator=LengthValidator();
}