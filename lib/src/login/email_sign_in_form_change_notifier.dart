import 'package:flutter/material.dart';
import 'custom_outline_button.dart';
import 'package:provider/provider.dart';
import 'platform_exception_alert_dialog.dart';
import 'auth.dart';
import 'package:flutter/services.dart';
import 'email_signin_change_model.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({@required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) =>
            EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _toggleVisibility = true;

  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    print('dispose called');
    super.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _submit() async {
    try {
      print('Inside try _submit EmailSignInBlocBased:1');
      await model.submit();
      print('Inside try _submit EmailSignInBlocBased:2');
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      print('Inside catch _submit EmailSignInBlocBased');
      print(e.toString());
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 8.0,
      ),
      CustomOutlineButton(
        child: Text(
          model.primaryButtonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed:_submit,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        onPressed: !model.isLoading ? () => _toggleFormType() : null,
        child: Text(model.secondaryButtonText,
            style: TextStyle(
              color: Colors.white,
            )),
      ),

      FlatButton(
        onPressed: () {},
        child: Text('Forgot password?',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline,
            )),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    print(
        'Insode _buildPasswordTextField,errorText:${model.invalidPasswordErrorText}');
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.showPasswordErrorText,
        errorStyle:TextStyle(color:Colors.white54),
        enabled: model.isLoading == false,
        suffixIcon: IconButton(
          icon: _toggleVisibility
              ? Icon(Icons.visibility)
              : Icon(Icons.visibility_off),
          onPressed: () {
            setState(() {
              _toggleVisibility = !_toggleVisibility;
            });
          },
        ),
      ),
      obscureText: _toggleVisibility,
      textInputAction: TextInputAction.next,
      focusNode: _passwordFocusNode,
      onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com ',
        errorText: model.showEmailErrorText,
        errorStyle: TextStyle(color:Colors.white54),
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: model.updateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
