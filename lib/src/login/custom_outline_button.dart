import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  CustomOutlineButton({
    this.child,
    this.color:Colors.transparent,
    this.height:50.0,
    this.radius:20.0,
    this.borderColor:Colors.white,
    this.borderWidth:1.0,
    this.highlightElevation:20.0,
    this.onPressed,
  });

  final Widget child;
  final Color color;
  final double radius;
  final double height;
  final Color borderColor;
  final double borderWidth;
  final double highlightElevation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:height,
      child:OutlineButton(
      child: child,
      color: color,
      borderSide:BorderSide(width:borderWidth,color:borderColor) ,
      shape: RoundedRectangleBorder(
        side:BorderSide(width:borderWidth,color:borderColor),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      onPressed: onPressed,
    ),
    );
  }
}
