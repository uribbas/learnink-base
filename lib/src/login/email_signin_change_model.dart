import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'validators.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../models/user.dart';

enum EmailSignInFormType { signIn, register, resetPassword }

class EmailSignInChangeModel with EmailAndPasswordValidator,ChangeNotifier {

  EmailSignInChangeModel({
      @required this.auth,
      this.email='',
      this.password='',
      this.formType=EmailSignInFormType.signIn,
      this.isLoading=false,
      this.submitted=false,
      this.signin=EmailSignInFormType.signIn,
      this.register=EmailSignInFormType.register,
      this.resetPassword=EmailSignInFormType.resetPassword,});

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;
  EmailSignInFormType signin;
  EmailSignInFormType register;
  EmailSignInFormType resetPassword;

  String get primaryButtonText{
    switch(formType) {
      case EmailSignInFormType.signIn:
        return 'Sign in';
        break;
      case EmailSignInFormType.register:
        return 'Create an account';
        break;
      case EmailSignInFormType.resetPassword:
        return 'Reset password';
        break;
      default:
        return 'Sign in';
        break;
    }
  }

  String get secondaryButtonText{
    switch(formType) {
      case EmailSignInFormType.signIn:
        return 'Need an account? Register';
        break;
      case EmailSignInFormType.register:
        return 'Have an account? Sign in';
        break;
      case EmailSignInFormType.resetPassword:
        return 'Have an account? Sign in';
        break;
      default:
        return 'Have an account? Sign in';
        break;
    }
  }

  bool get canSubmit{
    return emailValidator.isValid(email) &&
        (formType == EmailSignInFormType.resetPassword || passwordValidator.isValid(password)) &&
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
      if (formType == EmailSignInFormType.resetPassword) {
        await auth.sendPasswordResetEmail(email: email);
      } else if (formType == EmailSignInFormType.signIn) {
        final user = await auth.signInWithEmailandPassword(
          email: email,
          password: password,
        );
        print('uid of user sign in is ${user.uid}');
      } else {
        print('email:${email}, password:${password}');
        final user = await auth.createUserWithEmailandPassword(
          email: email,
          password: password,
        );
        print('uid of user is ${user.uid}');
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

  void toggleFormType({
    EmailSignInFormType toggleType
  }) {
    final formType = toggleType;
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
