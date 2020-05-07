import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastMessage {

  static void showToast(message, Color color,{BuildContext context}) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        //timeInSecForIos: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter/animation.dart';
//
//class ToastMessage {
//  static final int lengthShort = 1;
//  static final int lengthLong = 2;
//  static final int bottom = 0;
//  static final int center = 1;
//  static final int top = 2;
//
//  static void showToast(String msg, BuildContext context,
//      {int duration = 3,
//        int gravity = 1,
//        Color backgroundColor = const Color(0xAA000000),
//        textStyle = const TextStyle(fontSize: 15, color: Colors.white),
//        double backgroundRadius = 20,
//        Border border}) {
//
//    ToastView.dismiss();
//    ToastView.createView(msg, context, duration, gravity, color?? backgroundColor,
//        textStyle, backgroundRadius, border);
//  }
//}
//
//class ToastView {
//  static final ToastView _singleton = new ToastView._internal();
//
//  factory ToastView() {
//    return _singleton;
//  }
//
//  ToastView._internal();
//
//  static OverlayState overlayState;
//  static OverlayEntry _overlayEntry;
//  static bool _isVisible = false;
//
//  static void createView(
//      String msg,
//      BuildContext context,
//      int duration,
//      int gravity,
//      Color background,
//      TextStyle textStyle,
//      double backgroundRadius,
//      Border border) async {
//    overlayState = Overlay.of(context);
//
//    Paint paint = Paint();
//    paint.strokeCap = StrokeCap.square;
//    paint.color = background;
//
//
//    _overlayEntry = new OverlayEntry(
//      builder: (BuildContext context) => ToastWidget(
//            widget: Container(
//              width: MediaQuery.of(context).size.width,
//              child: AnimatedOpacity(
//                // If the widget is visible, animate to 0.0 (invisible).
//                // If the widget is hidden, animate to 1.0 (fully visible).
//                opacity: _isVisible ? 1.0 : 0.0,
//                duration: Duration(milliseconds: 1000),
//                child: Container(
//                      alignment: Alignment.center,
//                      width: MediaQuery.of(context).size.width,
//                      child: Container(
//                        decoration: BoxDecoration(
//                          color: background,
//                          borderRadius: BorderRadius.circular(backgroundRadius),
//                          border: border,
//                        ),
//                        margin: EdgeInsets.symmetric(horizontal: 20),
//                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
//                        child: Text(msg, softWrap: true, style: textStyle),
//                      )),
//              ),
//            ),
//            gravity: gravity),
//    );
//    _isVisible = true;
//    overlayState.insert(_overlayEntry);
//    await new Future.delayed(
//        Duration(seconds: duration == null ? ToastMessage.lengthShort : duration), ()=>print("Count down "));
//    dismiss();
//  }
//
//  static dismiss() async {
//    if (!_isVisible) {
//      return;
//    }
//    _isVisible = false;
//    _overlayEntry?.remove();
//  }
//}
//
//class ToastWidget extends StatelessWidget {
//  ToastWidget({
//    Key key,
//    @required this.widget,
//    @required this.gravity,
//  }) : super(key: key);
//
//  final Widget widget;
//  final int gravity;
//
//
//  @override
//  Widget build(BuildContext context) {
//    return new Positioned(
//        top: gravity == 2 ? MediaQuery.of(context).viewInsets.top + 50 : null,
//        bottom: gravity == 0 ? MediaQuery.of(context).viewInsets.bottom + 50 : null,
//        child: Material(
//          color: Colors.transparent,
//          child: widget,
//        ));
//  }
//}