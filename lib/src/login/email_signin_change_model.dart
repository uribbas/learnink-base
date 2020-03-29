import 'package:flutter/cupertino.dart';
import 'validators.dart';
import 'auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInChangeModel with EmailAndPasswordValidator,ChangeNotifier {

  EmailSignInChangeModel({
      @required this.auth,
      this.email='',
      this.password='',
      this.formType=EmailSignInFormType.signIn,
      this.isLoading=false,
      this.submitted=false});

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  String get primaryButtonText{
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText{
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have and account? Sign in';
  }

  bool get canSubmit{
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get showEmailErrorText{
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;

  }

  String get showPasswordErrorText{
    bool showErrorText =submitted && !passwordValidator.isValid(password);
    print('Inside showPasswordErrorText:$showErrorText');
    return showErrorText? invalidPasswordErrorText:null;

  }

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);

    try {
      //await Future.delayed(Duration(seconds: 10));
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailandPassword(
          email: email,
          password: password,
        );
      } else {
        print('email:${email}, password:${password}');
        await auth.createUserWithEmailandPassword(
          email: email,
          password: password,
        );
      }
    } catch (e) {
      updateWith(isLoading: false);
      print(e.toString());
      print('Inside catch submit email sign in bloc');
      rethrow;
    }
  }

  void updateEmail(email) => updateWith(email: email);

  void updatePassword(password) => updateWith(password: password);

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
        email: '',
        password: '',
        formType: formType,
        isLoading: false,
        submitted: false
    );
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
}) {
      this.email=email??this.email;
      this.password=password??this.password;
      this.formType=formType??this.formType;
      this.isLoading=isLoading??this.isLoading;
      this.submitted=submitted??this.submitted;
      notifyListeners();

  }

}
