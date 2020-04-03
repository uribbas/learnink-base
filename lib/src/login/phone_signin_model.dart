import 'validators.dart';

class PhoneSignInModel with PhoneValidator{

  PhoneSignInModel({
     this.phoneNumber='',
     this.isLoading=false,
     this.continued=false});

  final String phoneNumber;
  final bool isLoading;
  final bool continued;

  String get primaryButtonText{
    return !phoneValidator.isValid(phoneNumber)
        ? 'Enter Phone Number'
        : 'Continue';
  }


  bool get canContinue{
    return phoneValidator.isValid(phoneNumber)  &&
        !isLoading;
  }


  String get showErrorText{
    bool showErrorText = continued && !phoneValidator.isValid(phoneNumber);
    return showErrorText ? invalidPhoneErrorText : null;
}

  PhoneSignInModel copyWith({
    String phoneNumber,
    bool isLoading,
    bool continued,
  }) {
    return PhoneSignInModel(
      phoneNumber:phoneNumber??this.phoneNumber,
      isLoading:isLoading??this.isLoading,
      continued:continued??this.continued,
    );
  }

}