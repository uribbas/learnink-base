import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog(
      {@required String title, @required PlatformException exception})
      : super(
            title: title, content: _message(exception), defaultActionText: 'OK');

  static String _message(PlatformException exception){
    return exception.message;
  }
}
