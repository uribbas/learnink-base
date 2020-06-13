
import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';

class Option extends StatelessWidget {
  Option({this.child,this.isSelected,this.selectOption});
  final Widget child;
  final bool isSelected;
  final VoidCallback selectOption;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right:8.0),
          child: IconButton(icon: Icon(MyFlutterIcons.tick) ,
          color:isSelected?Colors.green:Colors.grey,
          onPressed: selectOption),
        ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      )
      ],
    );
  }
}

