import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows)
        result.maskFilter = null;
      return true;
    }());
    return result;
  }
}


class CustomOutlineButton extends StatelessWidget {
  CustomOutlineButton({
    this.child,
    this.color: Colors.transparent,
    this.height: 60.0,
    this.radius: 10.0,
    this.borderColor: Colors.white,
    this.borderWidth: 1.0,
    this.highlightColor: Colors.indigoAccent,
    this.elevationColor: Colors.white54,
    this.highlightElevation: 0.0,
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
    return Container(
      height:height,
      width: double.maxFinite-10,
      padding: EdgeInsets.all(8.0),
      child: Container(
        height:height-5,
        // width:_width,
//        padding: EdgeInsets.all(1.0),
        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            colors: [
//              Color(0x00FFFFFF),
//              elevationColor,
//            ],
//            stops: [0.88, 1.0],
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//            tileMode: TileMode.repeated,
//          ),
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          border: Border.all(
              color: Colors.transparent, width: 1.0, style: BorderStyle.solid),
        boxShadow: [
          CustomBoxShadow(
            color: elevationColor.withOpacity(0.7),
            blurStyle: BlurStyle.outer,
            blurRadius: 5,
            offset:Offset(0,0),

          ),
          ]
        ),

        child: SizedBox(
          height:height-5,
          width:double.maxFinite-10,
          child: OutlineButton(
            padding: EdgeInsets.all(0.0),
            child: Center(child: child),
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
        ),
      ),
    );
  }
}
