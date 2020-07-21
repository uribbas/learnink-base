import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog(
      {@required this.title,
        @required this.content,
        @required this.defaultActionText,
        this.cancelActionText,});

  final String title;
  final String content;
  final String defaultActionText;
  final String cancelActionText;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title,style: TextStyle(color: Colors.black,fontSize: 18.0),),
      content: Text(content,softWrap:true, style: TextStyle(color: Colors.black,fontSize: 18.0),),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title,style: TextStyle(color: Colors.black,fontSize: 18.0),),
      content: Text(content,softWrap:true, style: TextStyle(color: Colors.black,fontSize: 18.0),),
      actions: _buildActions(context),
    );
  }

  Future<bool> show(BuildContext context) async {
    final rVal= Platform.isIOS ?
    await showCupertinoDialog<bool>(
      context: context,
      builder: (context)=>this,
    )
        :await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => this,
    );
    print(rVal);
    return rVal;
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions =<Widget>[] ;

    if(cancelActionText !=null) {
      actions.add(PlatformDialogAction(
        child: Text(cancelActionText),
        onPressed: () => Navigator.of(context).pop(false),
      ),);
    }
    if(defaultActionText !=null){
      print('PlatformAlertDialog:Inside defaultActionText');
    actions.add(
      PlatformDialogAction(
        child: Text(defaultActionText),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    }

    return actions;
  }
}

class PlatformDialogAction extends PlatformWidget {
  final Widget child;
  final VoidCallback onPressed;
  PlatformDialogAction({this.child, this.onPressed});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}