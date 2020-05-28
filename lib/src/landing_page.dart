import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learnink/src/services/database.dart';
import 'package:learnink/src/services/learnink_connection_status_real.dart';
import 'package:learnink/src/widgets/blue_page_template.dart';
import 'package:learnink/src/widgets/learnink_empty_content.dart';
import 'package:learnink/src/widgets/learnink_loading_indicator.dart';
import 'package:learnink/src/widgets/white_page_template.dart';
import 'package:learnink/src/widgets/blue_page_template.dart';
import 'package:provider/provider.dart';
import 'dashboard/dashboard_landing.dart';
import 'home/home_page.dart';
import 'services/auth.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  StreamSubscription _connection;
  bool _connectionStatus = false;
  bool _previousStatus = false;

  @override
  void dispose() {
    _connection.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final learninkConnection = Provider.of<LearninkConnectionStatus>(context);

    _connection = learninkConnection.connectionStatus.listen((status) {
      _previousStatus = _connectionStatus;
      _connectionStatus = status;
      if (_previousStatus != _connectionStatus) {
        setState(() {});
      }
    });

    final auth = Provider.of<AuthBase>(context);
    return _connectionStatus
        ? StreamBuilder(
            stream: auth.onAuthStateChanged,
            builder: (context, snapshot) {
              print(
                  "inside builder ${snapshot.connectionState} ${snapshot.data} ");
              if (snapshot.connectionState == ConnectionState.active) {
                User user = snapshot.data;
                print(
                    "inside builder active check  ${snapshot.connectionState} ${user} ");
                if (user == null) {
                  print(
                      "inside builder active check  user null ${snapshot.connectionState} ${user} ");
                  return HomePage();
                }
                print(
                    "inside builder ${snapshot.connectionState} ${user.uid} ");
                return Provider<Database>(
                    create: (context) => FirestoreDatabase(uid: user.uid),
                    child: DashboardLanding(user: user));
              } else {
                return BluePageTemplate(
                  title: '',
                  child: LearninkLoadingIndicator(color: Colors.white),
                );
              }
            },
          )
        : BluePageTemplate(
            title: 'Network Issue',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: LearninkLoadingIndicator(color:Colors.white)),
                SizedBox(height: 80,),
                Center(child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text('Network issue detected, please ensure that your device is connected to internet',
                    style: TextStyle(fontSize: 16.0,),
//                    textAlign: TextAlign.justify,
//                    softWrap: false,
//                    maxLines: 4,
//                    overflow: TextOverflow.ellipsis,
                  ),
                )),
              ],
            ),
            leading: false,
          );
  }
}
