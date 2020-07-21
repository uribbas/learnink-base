import 'package:align_positioned/align_positioned.dart';
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
  double _width;

  @override
  Widget build(BuildContext context) {
    //_width=MediaQuery.of(context).size.width-5;
    return SizedBox(
      height: height,
      child: Stack(
        fit:StackFit.expand,
         children: [
           AlignPositioned(
             dx:0,
             dy:4.0,
             child:Container(
               width:MediaQuery.of(context).size.width-4.0,
               height: MediaQuery.of(context).size.height-4.0,
//        padding: EdgeInsets.all(1.0),
               decoration: BoxDecoration(
                 gradient: LinearGradient(
                   colors: [
                     Color(0x00FFFFFF),
                     //elevationColor,
                     elevationColor,
                   ],
                   stops: [0.85, 1.0],
                   begin: Alignment.topCenter,
                   end: Alignment.bottomCenter,
                   tileMode: TileMode.repeated,
                 ),
                 borderRadius: BorderRadius.all(Radius.circular(radius)),
                 border: Border.all(
                     color: Colors.transparent,
                     width: 1.0,
                     style: BorderStyle.solid
                 ),
               ),


               child:Container(
               color:Colors.transparent,
                 constraints: BoxConstraints.expand(),
             ),

           ),
      ),

      AlignPositioned(
        child: Container(
           width:MediaQuery.of(context).size.width -4.0,
//        padding: EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            color:color,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            border: Border.all(
                color: Colors.transparent,
                width: 1.0,
                style: BorderStyle.solid
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              OutlineButton(
                child: Container(
                    padding: const EdgeInsets.all(5.0),
                    height: height - 8.0,
                    child: Center(child: child)
                ),
                color: color,
                highlightColor: highlightColor,
                highlightElevation: highlightElevation,
                borderSide: BorderSide(width: borderWidth, color: borderColor),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: borderWidth, color: borderColor),
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                ),
                onPressed: onPressed,
              ),
          ],


      ),
        ),
      ),
         ],
      ),
        );


  }
}
