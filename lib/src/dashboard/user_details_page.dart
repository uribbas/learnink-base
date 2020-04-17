import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnink/src/login/auth.dart';
import '../services/database.dart';

class UserDetailPage extends StatefulWidget {
  UserDetailPage({Key key, this.database, this.user}) : super(key: key);
  final Database database;
  final User user;

  static Future<void> show(BuildContext context,
          {@required Database database,@required User user}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserDetailPage(database: database,user:user),
        fullscreenDialog: true,
      ),
    );
  }

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
  String _documentId;

  void initState(){
    super.initState();
    if(widget.user !=null) {
      //TODO: set the values here
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Edit Details'),
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
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
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
        decoration: InputDecoration(labelText: 'Your name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Sex'),
        validator: (value) => value.isNotEmpty ? null : 'Sex can\'t be empty',
        initialValue: _gender,
        onSaved: (value) => _gender=value,
      ),

      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => value.isNotEmpty ? null : 'Email can\'t be empty',
        initialValue: _email,
        onSaved: (value) => _email=value,
      ),

      TextFormField(
        decoration: InputDecoration(labelText: 'Mobile Number'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        validator: (value) => value.isNotEmpty ? null : 'Phone number can\'t be empty',
        initialValue: _phoneNumber!=null?'$_phoneNumber':null,
        onSaved: (value) => _phoneNumber= value,
      ),

    ];
  }

}

