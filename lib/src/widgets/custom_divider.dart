import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    this.thickness: 0.3,
    this.color: Colors.black,
    this.leadingText,
    this.fontSize: 18.0,
    this.textColor: Colors.black,
    this.onMore,
  });

  final double thickness;
  final Color color;
  final String leadingText;
  final double fontSize;
  final Color textColor;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          leadingText,
          style: TextStyle(color: textColor, fontSize: fontSize,fontWeight: FontWeight.bold,),
        ),
        Expanded(
          child: Divider(
            color: color,
            thickness: thickness,
            indent: 10.0,
            endIndent: 10.0,
          ),
        ),
        IconButton(icon:Icon(Icons.more_horiz,color:Colors.black),
        onPressed:onMore)
      ],
    );
  }
}
