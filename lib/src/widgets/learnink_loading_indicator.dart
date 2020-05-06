import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class LearninkLoadingIndicator extends StatelessWidget {

  LearninkLoadingIndicator({ this.color:Colors.white});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SpinKitFoldingCube(color:color,duration: Duration(milliseconds: 1800),);
  }
}
