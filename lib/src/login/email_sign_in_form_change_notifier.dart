import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../dashboard.dart';
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
  bool _toggleVisibility = false;

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

  void _toggleFormType({
    toggleType
  }) {
    print("Pressed toogle buttonn $toggleType value of enum ${model.formType}");
    model.toggleFormType(toggleType: toggleType);
    _emailController.clear();
    _passwordController.clear();
  }

  void _submit() async {
    try {
      print('Inside try _submit EmailSignInBlocBased:1');
      await model.submit();
      print('Inside try _submit EmailSignInBlocBased:2');
      if(model.formType==model.resetPassword){
        showToast('Password reset email sent, please check your email',Colors.lime);
        _toggleFormType(toggleType: model.signin);
        print('Inside try _submit Reset password redirect to login :3');
      } else {
        Navigator.of(context).popUntil((route) => route.isFirst);
//        Navigator.of(context).push(
//          MaterialPageRoute<void>(builder:(context)=>Dashboard(),fullscreenDialog: true,),);
      }
    } on PlatformException catch (e) {
      print('Inside catch _submit EmailSignInBlocBased');
      print(e.toString());
      /*PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);*/
      showToast(e.message,Colors.red);
    }
  }

  List<Widget> _buildChildren() {
    return [
      CircleAvatar(
        backgroundColor: Colors.white,
        child:Image.asset('assets/icons/email.png'),
      ),
      SizedBox(
        height: 40.0,
      ),
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      model.formType!=model.resetPassword ? _buildPasswordTextField() : SizedBox(height: 0.0,),
      SizedBox(
        height: model.formType!=model.resetPassword ? 8.0 : 0.0,
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
        height: 20.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed: !model.isLoading ? () => _toggleFormType(toggleType: model.formType==model.signin ? model.register : model.signin) : null,
//        color: Colors.redAccent,
            padding: EdgeInsets.all(0.0),
            child: Text(model.secondaryButtonText,
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          Container(
            width: 1.0,
              child: Text(''),
              decoration:BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
//                  left: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                  style: BorderStyle.solid
//                ),
                ),
              )
          ),
          FlatButton(
            onPressed: !model.isLoading ? () => _toggleFormType(toggleType: model.resetPassword) : null,
//        color: Colors.redAccent,
            padding: EdgeInsets.all(0.0),
            child: Text('Forgot password?',
              style: TextStyle(
                color: Colors.white,
//                decoration: TextDecoration.underline,
              ),
//          textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    print(
        'Inside _buildPasswordTextField,errorText:${model.invalidPasswordErrorText}');
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        errorText: model.showPasswordErrorText,
        errorStyle:TextStyle(color:Colors.yellowAccent),
        enabled: model.isLoading == false,
        disabledBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54, ) ,
        ),
        enabledBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, ) ,
        ),
        errorBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.yellowAccent, ) ,
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.yellowAccent, ) ,
        ),
        suffixIcon: IconButton(
          icon: _toggleVisibility
              ? Icon(Icons.visibility_off,color:Colors.white,)
              : Icon(Icons.visibility,color:Colors.white,),
          onPressed: () {
            setState(() {
              _toggleVisibility = !_toggleVisibility;
            });
          },
        ),
      ),
      obscureText: !_toggleVisibility,
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
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintText: 'test@test.com ',
        errorText: model.showEmailErrorText,
        errorStyle: TextStyle(color:Colors.yellowAccent),
        enabled: model.isLoading == false,
        disabledBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54, ) ,
        ),
        enabledBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, ) ,
        ),
        errorBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.yellowAccent,) ,
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.yellowAccent,) ,
        ),
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: model.updateEmail,
    );
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        //timeInSecForIos: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _buildChildren(),
        ),
      ),
    );
  }
}
