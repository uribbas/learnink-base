import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_animations/simple_animations.dart';

class ToastMessage {
  static final int lengthShort = 1;
  static final int lengthLong = 5;
  static final int bottom = 0;
  static final int center = 1;
  static final int top = 2;

  static void showToast(String msg, BuildContext context,
      {Widget widget,
      int duration = 1,
      int gravity = 1,
      Color backgroundColor = const Color(0xAA000000),
      textStyle = const TextStyle(fontSize: 15, color: Colors.white),
      double backgroundRadius = 6,
      Border border}) {
    Widget toastWidget = widget ?? Text(msg, softWrap: true, style: textStyle);
    bool isMargin = msg == null || msg == '' ? false : true;
    ToastView.dismiss();
    ToastView.createView(toastWidget, isMargin, context, duration, gravity,
        backgroundColor, textStyle, backgroundRadius, border);
  }

  static void dismissToast() {
    ToastView.dismiss();
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
      Widget toastWidget,
      bool isMargin,
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
        duration: duration,
//          widget: Container(
//              width: MediaQuery.of(context).size.width,
//              child: Container(
//                  alignment: Alignment.center,
//                  width: MediaQuery.of(context).size.width,
//                  child: Container(
//                    decoration: BoxDecoration(
//                      color: background,
//                      borderRadius: BorderRadius.circular(backgroundRadius),
//                      border: border,
//                    ),
//                    margin: EdgeInsets.symmetric(horizontal: isMargin ? 20 : 0),
//                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
//                    child: toastWidget,
        widget: toastWidget,
        gravity: gravity,
        background: background,
        backgroundRadius: backgroundRadius,
        border: border,
        isMargin: isMargin,
      ),
    );
    _isVisible = true;
    overlayState.insert(_overlayEntry);
    await new Future.delayed(Duration(
        seconds: duration == null ? ToastMessage.lengthShort : duration,
        milliseconds: 500));
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
  ToastWidget(
      {Key key,
      @required this.widget,
      @required this.gravity,
      @required this.duration,
      this.background,
      this.backgroundRadius,
      this.border,
      this.isMargin})
      : super(key: key);

  final Widget widget;
  final int gravity;
  final int duration;
  final Color background;
  final double backgroundRadius;
  final Border border;
  final bool isMargin;

  @override
  Widget build(BuildContext context) {
//    print("***********************");
//    print('$widget');
    return Positioned(
        top: gravity == 2 ? MediaQuery.of(context).viewInsets.top + 50 : null,
        bottom:
            gravity == 0 ? MediaQuery.of(context).viewInsets.bottom + 50 : null,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: (widget is Text)
                ? ToastMessageAnimation(
                    Container(
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(backgroundRadius),
                        border: border,
                      ),
                      margin:
                          EdgeInsets.symmetric(horizontal: isMargin ? 20 : 0),
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Material(
                        color: Colors.transparent,
                        child: widget,
                      ),
                    ),
                    duration,
                  )
                : Material(
                    color: Colors.transparent,
                    child: widget,
                  ),
          ),
        ),
    );
  }
}

enum AniProps { opacity, y }

class ToastMessageAnimation extends StatelessWidget {
  final Widget child;
  final int duration;

  ToastMessageAnimation(this.child, this.duration);

  @override
  Widget build(BuildContext context) {
    final _tween = MultiTween<AniProps>()
      ..add(AniProps.y, Tween(begin: 50.0, end: 0.0),
          Duration(milliseconds: 250), Curves.easeIn)
      ..add(AniProps.y, Tween(begin: 0.0, end: 0.0),
          Duration(seconds: duration - 1, milliseconds: 500), Curves.easeIn)
      ..add(AniProps.y, Tween(begin: 0.0, end: 50.0),
          Duration(milliseconds: 250), Curves.easeIn)
      ..add(
        AniProps.opacity,
        Tween(begin: 0.0, end: 1.0),
        Duration(milliseconds: 250),
      )
      ..add(
        AniProps.opacity,
        Tween(begin: 1.0, end: 1.0),
        Duration(seconds: duration - 1, milliseconds: 500),
      )
      ..add(
        AniProps.opacity,
        Tween(begin: 1.0, end: 0.0),
        Duration(milliseconds: 250),
      );

    return PlayAnimation(
      duration: _tween.duration,
      tween: _tween,
      child: child,
      builder: (context, child, value) {
        print("Inside PlayAnimation builder:${child}");
        return Opacity(
          opacity: value.get(AniProps.opacity),
          child: Transform.translate(
              offset: Offset(0, value.get(AniProps.y)), child: child),
        );
      },
    );
  }
}
