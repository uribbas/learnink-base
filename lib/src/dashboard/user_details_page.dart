import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learnink/src/login/auth.dart';
import 'package:learnink/src/models/user.dart';
import 'package:learnink/src/services/toastMessage.dart';
import 'package:learnink/src/widgets/blue_page_template.dart';
import 'package:learnink/src/widgets/custom_outline_button.dart';
import 'package:learnink/src/widgets/learnink_loading_indicator.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';
import 'dashboard_landing.dart';
import 'package:flutter/services.dart';


class UserDetailPage extends StatefulWidget {
  UserDetailPage(
      {Key key,
      this.user,
      this.auth,
      this.documentId,
      this.authSource,
      this.skipPage})
      : super(key: key);
  final LearninkUserInfo user;
  final AuthBase auth;
  final String documentId;
  final AuthSource authSource;
  final void Function(bool) skipPage;

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
  bool _submited=false;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();


  void initState() {
    super.initState();
    if (widget.user != null) {
      //TODO: set the values here
      _name = widget.user.name;
      _gender = widget.user.gender;
      _email = widget.user.email;
      _phoneNumber = widget.user.phoneNumber;
    }
  }

  void _nameEditingComplete(BuildContext context){
    final newFocus=widget.authSource==AuthSource.email?_phoneFocusNode:_emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _emailEditingComplete(BuildContext context){
    FocusScope.of(context).requestFocus(_phoneFocusNode);
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _skipPage(BuildContext context) async{
    final Database database=Provider.of<Database>(context,listen:false);
    if (widget.documentId == null) {
      // Check changes in the form fields and then add the values
      await database.addUser(widget.user);
    }
    widget.skipPage(true);
  }

  Future<void> _submit(BuildContext context) async {


    final form=_formKey.currentState;
   try {
     final Database database=Provider.of<Database>(context,listen:false);
     if (_validateAndSaveForm()) {
       form.deactivate();
       setState((){_submited=true;});
       //      set the existing document
       // Check changes in the form fields and then add the values
       LearninkUserInfo user= widget.user.copyWith(
         name:_name,
         gender: _gender,
         phoneNumber: _phoneNumber,
         email: _email,
       );
       if (widget.documentId != null) {
         await database.setUser(user, widget.documentId);
       } else {
        // New user registration, so create the user document
         await database.addUser(user);
       }
       widget.skipPage(true);
     }
   } on PlatformException catch(e){

     setState((){_submited=true;});
     ToastMessage.showToast('Your details were not updated because of error. Please try again'
         , Colors.red);

   }
  }

  @override
  Widget build(BuildContext context) {
    return _submited? Stack(fit: StackFit.expand, children: <Widget>[
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
          top: true,
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
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text('Update Details'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Skip',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: ()=>_skipPage(context),
            ),
          ],
        ),
        body: _buildContents(context),
        backgroundColor: Colors.transparent,
      ),
    ],
    )
    :BluePageTemplate(child:Center(child:LearninkLoadingIndicator(),),);
  }

  Widget _buildContents(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.transparent,
          elevation: 0.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(context),
      ),
    );
  }

  List<Widget> _buildFormChildren(BuildContext context) {
    return [
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Name of the child',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          errorStyle: TextStyle(color:Colors.yellowAccent),
          disabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, ) ,
          ),
          enabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, ) ,
          ),
          errorBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellowAccent,) ,
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellowAccent,) ,
          ),
        ),
        focusNode: _nameFocusNode,
        textInputAction: TextInputAction.next,
        onEditingComplete: ()=>_nameEditingComplete(context),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      DropdownButtonFormField(
        value: _gender,
        decoration:InputDecoration(
          labelText: 'Gender',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          errorStyle: TextStyle(color:Colors.yellowAccent),
          disabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, ) ,
          ),
          enabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, ) ,
          ),
          errorBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellowAccent,) ,
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellowAccent,) ,
          ),
        ),
        items:<String>['Girl','Boy','Other'].map((String item) {
          return DropdownMenuItem<String>(
            child: Text('$item', style: TextStyle(color: Colors.blue),),
            value: item,
          );
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return <String>['Girl','Boy','Other'].map<Widget>((String item) {
            return Text(item);
          }).toList();
        },
        iconEnabledColor: Colors.white,
        onSaved: (value) => _gender = value,
        onChanged:(value) => setState((){_gender=value;}),
        validator: (value) => value!=null? null : 'Gender can\'t be empty',

      ),

      TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          enabled: widget.authSource != AuthSource.email,
          errorStyle: TextStyle(color:Colors.yellowAccent),
          disabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, ) ,
          ),
          enabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, ) ,
          ),
          errorBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellowAccent,) ,
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellowAccent,) ,
          ),
        ),
        validator: (value) => value.isNotEmpty ? null : 'Email can\'t be empty',
        initialValue: _email,
        focusNode: _emailFocusNode,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        onEditingComplete: ()=>widget.authSource==AuthSource.phone?
                               _submit(context):
                              _emailEditingComplete(context),
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Mobile number',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          enabled: widget.authSource != AuthSource.phone,
          errorStyle: TextStyle(color:Colors.yellowAccent),
          disabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, ) ,
          ),
          enabledBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, ) ,
          ),
          errorBorder:UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellowAccent,) ,
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellowAccent,) ,
          ),
        ),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        validator: (value) =>
            value.isNotEmpty ? null : 'Phone number can\'t be empty',
        initialValue: _phoneNumber != null ? '$_phoneNumber' : null,
        focusNode: _phoneFocusNode,
        textInputAction: TextInputAction.next,
        onEditingComplete: ()=>_submit(context),
        onSaved: (value) => _phoneNumber = value,
      ),
      SizedBox(
        height: 10.0,
      ),
      CustomOutlineButton(
        child: Text(
          'Save',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed:()=>_submit(context),
      ),
    ];
  }

}
