import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Chat',style:TextStyle(fontSize: 30.0,color:Colors.blue,),
          ),
        ),
      ),
    );
  }
}
