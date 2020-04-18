import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnink/src/login/auth.dart';
import 'package:learnink/src/models/user.dart';
import '../services/database.dart';

class UserDetailPage extends StatefulWidget {
  UserDetailPage({Key key, this.database, this.user, this.auth, this.documentId, this.authSource}) : super(key: key);
  final Database database;
  final LearninkUserInfo user;
  final AuthBase auth;
  final String documentId;
  final String authSource;

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {

  final _formKey = GlobalKey<FormState>();

  String _uid;
  String _name;
  String _gender;
  String _email;
  String _phoneNumber;
  String _subscriberId;
  Timestamp _userCreationTimeStamp;

  void initState(){
    super.initState();
    if(widget.user !=null) {
      //TODO: set the values here
      _name = widget.user.name;
      _gender = widget.user.gender;
      _email = widget.user.email;
      _phoneNumber = widget.user.phoneNumber;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    //TODO: create a userInfo object and write to database
    if(widget.documentId == null){
      // Check changes in the form fields and then add the values
      await FirestoreDatabase(uid: widget.user.uid).addUser(widget.user);
    } else {
      //      set the existing document
      // Check changes in the form fields and then add the values
      await FirestoreDatabase(uid: widget.user.uid).setUser(widget.user,widget.documentId);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: <Widget>[
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
          elevation: 2.0,
          title: Text('Update Details'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: _submit,
            ),
          ],
        ),
        body: _buildContents(),
        backgroundColor: Colors.transparent,
      ),
    ]);
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.transparent,
          elevation: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Name of the child',
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          disabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, ) ,
          ),
          enabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, ) ,
          ),
        ),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          disabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, ) ,
          ),
          enabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, ) ,
          ),
        ),
        validator: (value) => value.isNotEmpty ? null : 'Sex can\'t be empty',
        initialValue: _gender,
        onSaved: (value) => _gender=value,
      ),

      TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          enabled: widget.authSource != "email",
          disabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, ) ,
          ),
          enabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, ) ,
          ),
        ),
        validator: (value) => value.isNotEmpty ? null : 'Email can\'t be empty',
        initialValue: _email,
        onSaved: (value) => _email=value,
      ),

      TextFormField(
        decoration: InputDecoration(
          labelText: 'Mobile number',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          enabled: widget.authSource != "phone",
          disabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, ) ,
          ),
          enabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, ) ,
          ),
        ),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        validator: (value) => value.isNotEmpty ? null : 'Phone number can\'t be empty',
        initialValue: _phoneNumber!=null?'$_phoneNumber':null,
        onSaved: (value) => _phoneNumber= value,
      ),
      SizedBox(height: 10.0,),
      FlatButton(
          color: Colors.transparent,
          child: Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          onPressed: ()=> _signOut(context)

      ),
    ];
  }

  Future<void> _signOut(BuildContext context) async {
    await widget.auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

}

