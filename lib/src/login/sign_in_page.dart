import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/toastMessage.dart';
import '../widgets/learnink_loading_indicator.dart';
import 'phone_signin_page.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_page.dart';
import 'sign_in_manager.dart';
import '../widgets/social_sign_in_button.dart';
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
      ToastMessage.showToast('Sign in falied', context,backgroundColor:Colors.red);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
  }

  void _signInWithPhone(BuildContext context) {
     Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => PhoneSignInPage(),
    ));
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
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            child: SafeArea(
              top:true,
              child: Container(
                color: Colors.transparent,
//                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/icons/bg-art.png',
                ),
              ),
            )),
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed:()=>Navigator.of(context).pop()
            ),
            title: Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 30,
              ),
            ),
          ),
          body: _buildContent(context),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      // width:MediaQuery.of(context).size.width,
      //height:MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 200.0, child: _buildHeader()),
            SizedBox(height: 0.0),
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
              onPressed: isLoading?null:()=>_signInWithPhone(context),
            ),
            SizedBox(height: 8.0),
            SocialSignInButton(
              text: 'Sign in with Email',
              image: 'assets/icons/email.png',
              textColor: Colors.white,
              color: Colors.transparent,
              onPressed: isLoading?null:()=>_signInWithEmail(context),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    print(isLoading);
    if (isLoading) {
      return Center(
        child: LearninkLoadingIndicator(),
      );
    }

    return SafeArea(
      top: true,
      left: true,
      right: true,
      child: Column(children: <Widget>[
        SizedBox(height: 80.0),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30.0,
          child: Text('Logo'),
        )
      ]),
    );
  }
}
