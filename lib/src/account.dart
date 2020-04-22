import 'package:flutter/material.dart';
import 'login/auth.dart';

class Account extends StatelessWidget {
  const Account({Key key, this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text('Account'),
        actions: <Widget>[
          FlatButton(child:Text('SignOut'),
          onPressed:() =>_signOut(context))
        ],),

      body: Container(
        child: Center(
          child: Text(
            'Account',
              style:TextStyle(fontSize: 30.0,color:Colors.blue,),
          ),
        ),
      ),
    );
  }
  Future<void> _signOut(BuildContext context) async{
    await auth.signOut();
  }
}
