import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login/auth.dart';

class Dashboard extends StatelessWidget {
  final AuthBase auth;

  const Dashboard({Key key, this.auth}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("Inside dashboard");
    return Scaffold(body: Center(
      child: Container(
        child: FlatButton(
          color: Colors.transparent,
          child: Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.redAccent,
              fontSize: 20.0,
            ),
          ),
          onPressed: ()=> _signOut(context)

        ),
      ),
    ));
  }
  Future<void> _signOut(BuildContext context) async {
    await auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
