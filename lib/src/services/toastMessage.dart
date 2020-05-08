import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_animations/simple_animations.dart';

class ToastMessage {
  static final int lengthShort = 1;
  static final int lengthLong = 2;
  static final int bottom = 0;
  static final int center = 1;
  static final int top = 2;

  static void showToast(String msg, BuildContext context,
      {int duration = 1,
        int gravity = 0,
        Color backgroundColor = const Color(0xAA000000),
        textStyle = const TextStyle(fontSize: 15, color: Colors.white),
        double backgroundRadius = 0,
        Border border}) {
    ToastView.dismiss();
    ToastView.createView(msg, context, duration, gravity, backgroundColor,
        textStyle, backgroundRadius, border);
  }
}

class ToastView {
  static final ToastView _singleton = new ToastView._internal();

  factory ToastView() {
    return _singleton;
  }

  ToastView._internal();

  static OverlayState overlayState;
  static OverlayEntry _overlayEntry;
  static bool _isVisible = false;

  static void createView(
      String msg,
      BuildContext context,
      int duration,
      int gravity,
      Color background,
      TextStyle textStyle,
      double backgroundRadius,
      Border border) async {
    overlayState = Overlay.of(context);

//    Paint paint = Paint();
//    paint.strokeCap = StrokeCap.square;
//    paint.color = background;

    _overlayEntry = new OverlayEntry(
      builder: (BuildContext context) => ToastWidget(
          widget: Container(
              width: MediaQuery.of(context).size.width,
              child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(backgroundRadius),
                      border: border,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Text(msg, softWrap: true, style: textStyle),
                  )),
            ),

          gravity: gravity),
    );
    _isVisible = true;
    overlayState.insert(_overlayEntry);
    await new Future.delayed(
        Duration(seconds: duration == null ? ToastMessage.lengthShort : duration));
    dismiss();
  }

  static dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class ToastWidget extends StatelessWidget {
  ToastWidget({
    Key key,
    @required this.widget,
    @required this.gravity,
  }) : super(key: key);

  final Widget widget;
  final int gravity;

  @override
  Widget build(BuildContext context) {
    return
       Positioned(
          top: gravity == 2 ? MediaQuery.of(context).viewInsets.top + 50 : null,
          bottom: gravity == 0 ? MediaQuery.of(context).viewInsets.bottom + 50 : null,
          child: ToastMessageAnimation(
            Material(
            color: Colors.transparent,
            child: widget,
          ),
       ),
    );
  }
}

enum AniProps {opacity,y}

class ToastMessageAnimation extends StatelessWidget {
  final Widget child;

  ToastMessageAnimation(this.child);

  @override
  Widget build(BuildContext context) {
    final _tween = MultiTween<AniProps>()
        ..add(AniProps.y,Tween(begin:50.0,end:0.0),
        Duration(milliseconds:250),
          Curves.easeIn
        )
       ..add( AniProps.y,Tween(begin:0.0,end:0.0),
           Duration(seconds: 1, milliseconds: 250),
          Curves.easeIn)
          ..add(AniProps.y,
              Tween(begin:0.0,end:50.0),
              Duration(milliseconds: 250),
           Curves.easeIn)
          ..add( AniProps.opacity,
            Tween(begin:0.0,end:1.0),
           Duration(milliseconds: 500),
          )
          ..add(AniProps.opacity,
            Tween(begin:1.0,end:1.0),
            Duration(seconds: 1),
          )
          ..add(AniProps.opacity,
          Tween(begin:1.0,end:0.0),
        Duration(milliseconds: 500),
    );

    return PlayAnimation(
      duration: _tween.duration,
      tween:_tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AniProps.opacity),
        child: Transform.translate(
            offset: Offset(0, value.get(AniProps.y)),
            child: child),
      ),
    );
  }
}