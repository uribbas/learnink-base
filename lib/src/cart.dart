import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Cart',style:TextStyle(fontSize: 30.0,color:Colors.blue,),
          ),
        ),
      ),
    );
  }
}
