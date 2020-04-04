import 'package:flutter/material.dart';
import 'phone_signin_bloc_based.dart';

class PhoneSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
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
          ),
        ),
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
              onPressed: () => Navigator.of(context).pop(),),
          title: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 30,
            ),
          ),
        ),
        body:  Padding(
            padding: const EdgeInsets.all(0.0),
            child: Center(
              child: Card(
                child:PhoneLogInBlocBased.create(context),
                color:Colors.transparent,
                elevation:0.0,
              ),
            ),
        ),
        backgroundColor: Colors.transparent,
        
      ),
    ],
    );
  }

}

