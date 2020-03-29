import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    this.child,
    this.color:Colors.transparent,
    this.height=50.0,
    this.radius:4.0,
    this.borderColor:Colors.white,
    this.onPressed,
  });

  final Widget child;
  final Color color;
  final double radius;
  final double height;
  final Color borderColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:height,
      child:RaisedButton(
      child: child,
      color: color,
      disabledColor: color,
      shape: RoundedRectangleBorder(
        side:BorderSide(color:borderColor),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      onPressed: onPressed,
    ),
    );
  }
}
