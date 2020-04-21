import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
}
