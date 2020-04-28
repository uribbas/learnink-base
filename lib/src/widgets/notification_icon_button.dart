import 'package:flutter/material.dart';
import 'package:align_positioned/align_positioned.dart';

class NotificationIconButton extends StatelessWidget {

NotificationIconButton({
  this.size,
  this.icon,
  this.color,
  this.onPressed});

  final double size;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    final int counter = 10;
    final double newSize=size;
     return Container(
      height: newSize,
      width: newSize,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Padding(
            padding:EdgeInsets.only(top:5.0,right:20.0,bottom:20.0),
            child: IconButton(
              padding: EdgeInsets.all(0),
              alignment: Alignment.center,
                icon: Icon(
                  icon,
                  color: color,
                  size:newSize*0.75,
                ),
                onPressed: onPressed),
          ),
           counter!=0?AlignPositioned(
            alignment: Alignment.topRight,
            //touch: Touch.inside,
            child: Container(
              height:newSize*0.4,
              width:newSize*0.4,
              padding: EdgeInsets.all(2),
              decoration: new BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(newSize*0.2),
              ),
              constraints: BoxConstraints(
                minWidth: 15,
                minHeight: 15,
              ),
              child: Center(
                child: Text(
                  '$counter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ):Container(),
        ],
      ),
    );
  }
}
