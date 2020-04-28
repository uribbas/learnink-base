import 'package:flutter/material.dart';
import 'package:learnink/src/services/database.dart';
import 'package:provider/provider.dart';
import 'dashboard/dashboard_landing.dart';
import 'home/home_page.dart';
import 'login/auth.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        print("inside builder ${snapshot.connectionState} ${snapshot.data} ");
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          print(
              "inside builder active check  ${snapshot.connectionState} ${user} ");
          if (user == null) {
            print(
                "inside builder active check  user null ${snapshot.connectionState} ${user} ");
            return HomePage();
          }
          print("inside builder ${snapshot.connectionState} ${user.uid} ");
          return Provider<Database>(
              create:(context)=> FirestoreDatabase(uid:user.uid),
              child: DashboardLanding(user: user));

        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
