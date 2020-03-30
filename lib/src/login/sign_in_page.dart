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
                  Color(0xff004fe0),
                  Color(0xff002d7f),
                ],
                stops: [0.2, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.repeated,
              ),
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                color: Colors.transparent,
//                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/icons/bg-art.png',
                ),
              )
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
//       left:10.0,
        top:20.0,
        child: Container(
          width:MediaQuery.of(context).size.width,
          height:MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(16.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 200.0, child: _buildHeader()),
            SizedBox(height: 150.0),
            SocialSignInButton(
              text: 'Sign in with Google',
              image: 'assets/icons/google.png',
              textColor: Colors.white,
              color: Colors.transparent,
              onPressed: isLoading ? null : () => _signInWithGoogle(context),
            ),
            SizedBox(height: 8.0),
            SocialSignInButton(
              text: 'Sign in with Phone',
              image: 'assets/icons/phone.png',
              textColor: Colors.white,
              color: Colors.transparent,
              onPressed: () {},
            ),
            SizedBox(height: 8.0),
            SocialSignInButton(
              text: 'Sign in with Email',
              image: 'assets/icons/email.png',
              textColor: Colors.white,
              color: Colors.transparent,
              onPressed: () {},
            ),
            SizedBox(height: 8.0),
//
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

    return SafeArea(
      top:true,
      left:true,
      right:true,
      child: Column(
        children: <Widget> [
          Text(
          'Sign in',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 30),
        ),
          SizedBox(height:50.0),
          CircleAvatar(backgroundColor: Colors.white,
          child:Text('Logo'),)
        ]
      ),
    );
  }
}
