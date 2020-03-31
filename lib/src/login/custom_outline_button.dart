import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  CustomOutlineButton({
    this.child,
    this.color:Colors.transparent,
    this.height:50.0,
    this.radius:10.0,
    this.borderColor:Colors.white,
    this.borderWidth:1.0,
    this.highlightColor: Colors.indigoAccent,
    this.elevationColor:Colors.white54,
    this.highlightElevation:0.0,
    this.onPressed,
  });

  final Widget child;
  final Color color;
  final double radius;
  final double height;
  final Color borderColor;
  final double borderWidth;
  final Color highlightColor;
  final Color elevationColor;
  final double highlightElevation;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:height,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0x00FFFFFF),
              elevationColor,
            ],
            stops: [0.9, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.repeated,
          ),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(radius),
              bottomRight: Radius.circular(radius),
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              child: Container(
                  height: height - 6.0,
                  child: Center(child: child)
              ),
              color: color,
              highlightColor: highlightColor,
              highlightElevation: highlightElevation,
              borderSide:BorderSide(width:borderWidth,color:borderColor) ,
              shape: RoundedRectangleBorder(
                side:BorderSide(width:borderWidth,color:borderColor),
                borderRadius: BorderRadius.all(Radius.circular(radius)),
              ),
              onPressed: onPressed,
            ),
            Container(
              height: 0.0,
            ),
          ],
        ),
      ),
    );
  }
}
