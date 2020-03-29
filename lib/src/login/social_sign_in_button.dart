import 'package:flutter/material.dart';
import 'custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton{
  SocialSignInButton({
      String text,
      String image,
      Color textColor,
      Color color,
      VoidCallback onPressed
  }): super(
    child:Row(
      mainAxisAlignment:MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(image),
        Text(
          text,
          style: TextStyle(
            color:textColor,
            fontSize: 16.0,
            fontWeight: FontWeight.bold
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: Image.asset(image),
        ),

      ],
    ),
    color:color,
    onPressed:onPressed,
  );

}