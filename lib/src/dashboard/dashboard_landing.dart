import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnink/src/dashboard/dashboard.dart';
import 'package:learnink/src/dashboard/user_details_page.dart';
import '../services/database.dart';
import '../login/auth.dart';
import '../models/user.dart';

class DashboardLanding extends StatefulWidget {
  DashboardLanding({Key key, this.user}) : super(key: key);
  final User user;
  @override
  _DashboardLandingState createState() => _DashboardLandingState();
}

class _DashboardLandingState extends State<DashboardLanding> {
  Database db;

  void initState() {
    super.initState();
    db=FirestoreDatabase(uid: widget.user.uid);
     _checkUserDetails();
  }

  void _checkUserDetails() {
    db.getCollectionRef('users').then((userRef) {
      db.selectedUsersRefList(userRef.where('uid', isEqualTo: widget.user.uid))
          .then((userInfo) {
        Future.delayed(Duration.zero,()=>_updateScreenState(context,userInfo));
      }).catchError((error) {
        print(error);
      });
    }).catchError((error) {
      print(error);
    });

    //print('Inside initState $userRef');



  }

  void _updateScreenState(BuildContext context,List<LearninkUserInfo> userInfo){

    if (userInfo.isNotEmpty) {
      //TODO: show dashboard
      Navigator.of(context).push(
          MaterialPageRoute(builder:(context)=>Dashboard(),fullscreenDialog: true,),);

    } else{
      //TODO: add user and show the details page
      UserDetailPage.show(context,database:db,user:widget.user);
    }

  }

  @override
  Widget build(BuildContext context) {
    //print(_screen);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );;
  }
}
