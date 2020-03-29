import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_raised_button.dart';

class SubmitRaisedButton extends CustomRaisedButton {
  SubmitRaisedButton({@required text, VoidCallback onPressed})
      : super(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                ),
          ),
          color: Colors.blue,
          onPressed: onPressed,
        );
}
