import 'package:flutter/material.dart';
import 'custom_outline_button.dart';

class SocialSignInButton extends CustomOutlineButton {
  SocialSignInButton(
      {String text,
      String image,
      Color textColor,
      double height:50,
      Color color,
      VoidCallback onPressed})
      : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              Container(
                height:height-4.0,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      image
                    ),
                  ),
                ),
              ),
              Text(
                text,
                style: TextStyle(
                    color: textColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(image),
                ),
              ),
            ],
          ),
          color: color,
          height:height,
          onPressed: onPressed,
        );
}
