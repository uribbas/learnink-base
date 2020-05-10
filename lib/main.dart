import 'package:flutter/material.dart';
import 'src/landing_page.dart';
import 'src/services/auth.dart';
import 'package:provider/provider.dart';
import 'src/services/learnink_connection_status_real.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  LearninkConnectionStatus.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>(create:(context)=>Auth()),
        Provider<LearninkConnectionStatus>(create:(context)=>LearninkConnectionStatus.instance)
      ],

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

