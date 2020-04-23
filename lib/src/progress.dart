import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Progress',
              style:TextStyle(fontSize: 30.0,color:Colors.blue,)
          ),
        ),
      ),
    );
  }
}
