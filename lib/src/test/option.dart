
import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';

class Option extends StatelessWidget {
  Option({this.child,this.isSelected,this.selectOption, this.isFirst, this.isLast});
  final Widget child;
  final bool isSelected;
  final VoidCallback selectOption;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:10.0,bottom:10.0),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black12, width: isFirst ? 2.0 : 1.0),
            bottom: BorderSide(color: Colors.black12, width:isLast ? 2.0 : 1.0),
            left: BorderSide(color: Colors.transparent, width: 1.0),
            right: BorderSide(color: Colors.transparent, width: 1.0),
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right:8.0),
            child: IconButton(icon: Icon(MyFlutterIcons.tick) ,
            color:isSelected?Colors.green:Colors.grey,
            onPressed: selectOption),
          ),

        Container(
          width:MediaQuery.of(context).size.width-120,

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        )
        ],
      ),
    );
  }
}

