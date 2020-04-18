import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnink/src/dashboard/dashboard.dart';
import 'package:learnink/src/dashboard/user_details_page.dart';
import '../services/database.dart';
import '../login/auth.dart';
import '../models/user.dart';

class DashboardLanding extends StatefulWidget {
  DashboardLanding({Key key, this.auth, this.user}) : super(key: key);
  final User user;
  final AuthBase auth;
  @override
  _DashboardLandingState createState() => _DashboardLandingState();
}

class _DashboardLandingState extends State<DashboardLanding> {
  Database db;
  var _authUser;
  var _authSource;
  var _documentId;

  void initState() {
    super.initState();
    db=FirestoreDatabase(uid: widget.user.uid);
    print("Inside initState call ${widget.auth} ${widget.user.uid}");
     _checkUserDetails();
  }

  LearninkUserInfo _getAuthUserInfo(){
    return LearninkUserInfo(
      uid: widget.user.uid,
      name: widget.user.displayName,
      email: widget.user.email,
      phoneNumber: widget.user.phoneNumber,
      gender: null,
    );

  }


  bool _isDetailsMissing(LearninkUserInfo user){
    return (user.email == null || user.email == '') ||
        (user.phoneNumber == null || user.phoneNumber == '') ||
        (user.name == null || user.name == '') ||
        (user.gender == null || user.gender == '');
  }

  void _checkUserDetails() {
    db.getCollectionRef('users').then((userRef) {
      db.selectedUsersRefList(userRef.where('uid', isEqualTo: widget.user.uid))
          .then((userInfo) {
        setState(() {
          _authUser = userInfo.isNotEmpty ? userInfo[0] : _getAuthUserInfo();
          _authSource = (widget.user.email != null || widget.user.email !='')  ? 'email' : 'phone';
          _documentId = userInfo.isNotEmpty ? userInfo[0].documentId : null;
        });
      }).catchError((error) {
        print(error);
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("_authUser ${_authUser}");
    if(_authUser != null){
      if(_isDetailsMissing(_authUser)){
        print("Provider value ${widget.user.providerId} $_authSource $_documentId");
        return UserDetailPage(database:db,user:_authUser, auth: widget.auth, documentId: _documentId, authSource: _authSource);
      } else {
        return Dashboard(auth: widget.auth);
//        return Dashboard(auth: widget.auth);
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );;
    }
  }
}
