import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_outline_button.dart';
import 'otp_screen_page.dart';
import 'phone_signin_bloc.dart';
import 'phone_signin_model.dart';

class PhoneLogInBlocBased extends StatefulWidget {
  PhoneLogInBlocBased({@required this.bloc});
  final PhoneSignInBloc bloc;

  static Widget create(BuildContext context) {
    return Provider<PhoneSignInBloc>(
      create: (context) => PhoneSignInBloc(),
      child: Consumer<PhoneSignInBloc>(
        builder: (context, bloc, _) => PhoneLogInBlocBased(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _PhoneLogInBlocBasedState createState() => _PhoneLogInBlocBasedState();
}

class _PhoneLogInBlocBasedState extends State<PhoneLogInBlocBased> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void dispose() {
    print('dispose called');
    super.dispose();
    _phoneNumberController.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  void _continue(PhoneSignInModel model) {
    print('Form continued');
    widget.bloc.continued();
    if (model.phoneValidator.isValid(model.phoneNumber)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OTPScreenPage(mobileNumber: model.phoneNumber),
          fullscreenDialog: true,
        ),
      );
    }
  }

  void _phoneEditingComplete(PhoneSignInModel model) {
    _continue(model);
  }

  List<Widget> _buildChildren(PhoneSignInModel model) {
    final primaryText = !model.phoneValidator.isValid(model.phoneNumber)
        ? 'Enter Phone Number'
        : 'Continue';

    return [
      CircleAvatar(
        backgroundColor: Colors.white,
        child:Image.asset('assets/icons/phone.png'),
      ),
      SizedBox(
        height: 40.0,
      ),
      _buildPhoneTextField(model),
      SizedBox(
        height: 8.0,
      ),
      CustomOutlineButton(
        child: Text(
          model.primaryButtonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () => _continue(model),
      ),
    ];
  }

  TextField _buildPhoneTextField(PhoneSignInModel model) {
    return TextField(
      controller: _phoneNumberController,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: '1234567890',
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        errorText: model.showErrorText,
        errorStyle:TextStyle(color:Colors.yellowAccent),
        enabled: !model.isLoading,
        disabledBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54, ) ,
        ),
        enabledBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, ) ,
        ),
        errorBorder:UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.yellowAccent, ) ,
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.yellowAccent, ) ,
        ),
      ),
      autocorrect: false,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      focusNode: _phoneFocusNode,
      onEditingComplete: () => _phoneEditingComplete(model),
      onChanged: (phoneNumber) =>
          widget.bloc.updateWith(phoneNumber: phoneNumber),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.bloc.modelStream,
        initialData: PhoneSignInModel(),
        builder: (context, snapshot) {
          final PhoneSignInModel model = snapshot.data;
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: _buildChildren(model),
              ),
            ),
          );
        });
  }
}
