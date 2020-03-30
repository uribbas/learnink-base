import 'package:flutter/material.dart';
import 'src/landing_page.dart';
import 'src/login/auth.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create:(context)=>Auth(),
      child: MaterialApp(
          title:'Learnink',
          theme:ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Montserrat',
            primaryTextTheme: Typography().white,
            textTheme:Typography().white,

          ),
          home:LandingPage()
      ),
    );
  }
}

