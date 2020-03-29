import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_page.dart';
//import 'package:time_tracker_flutter_course/app/sign_in/phone_sign_in_page.dart';
import 'sign_in_manager.dart';
//import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'social_sign_in_button.dart';
import 'platform_exception_alert_dialog.dart';
import 'auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({@required this.manager, @required this.isLoading});
  final SignInManager manager;
  final bool isLoading;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, manager, _) =>
                SignInPage(manager: manager, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    if (exception.code != 'ERROR_ABORTED_BY_USER') {
      PlatformExceptionAlertDialog(
              title: 'Sign in falied', exception: exception)
          .show(context);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
  }

  void _signInWithPhone(BuildContext context) {
    /* Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => PhoneSignInPage(),
    ));*/
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[700],
                  Colors.blue[900],
                ],
                stops: [0.2, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.repeated,
              ),
            ),
          ),
          Image.asset(
            'assets/icons/bg-art.png',
          ),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
  ) {
    return Positioned(
       left:20.0,
        top:20.0,
        child: Container(
          width:MediaQuery.of(context).size.width,
          height:MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 50.0, child: _buildHeader()),
            SizedBox(height: 50.0),
            SocialSignInButton(
              text: 'Sign in with Google',
              image: 'assets/icons/google.png',
              textColor: Colors.black,
              color: Colors.white,
              onPressed: isLoading ? null : () => _signInWithGoogle(context),
            ),
            SizedBox(height: 8.0),
            SocialSignInButton(
              text: 'Sign in with facebook',
              image: 'assets/icons/fb.png',
              textColor: Colors.black,
              color: Colors.blueAccent,
              onPressed: () {},
            ),
            SizedBox(height: 8.0),
//            SignInButton(
//              text: 'Sign in with email',
//              textColor: Colors.black,
//              color: Colors.teal,
//              onPressed: isLoading?null:() => _signInWithEmail(context),
//            ),
            SizedBox(height: 8.0),
//            SignInButton(
//              text: 'Go anonymous',
//              textColor: Colors.black,
//              color: Colors.blueGrey,
//              onPressed: isLoading?null:() => _signInAnonymously(context),
//            ),
//            SizedBox(height: 8.0),
//            SignInButton(
//              text: 'Sign in with Phone ',
//              textColor: Colors.black,
//              color: Colors.blueGrey,
//              onPressed: isLoading?null:() => _signInWithPhone(context),
//            ),
            // PhoneLogin(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    print(isLoading);
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40),
    );
  }
}
