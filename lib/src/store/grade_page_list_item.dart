import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/learnink_network_image.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';
import '../models/grade.dart';


class GradePageListItem extends StatelessWidget {
  GradePageListItem({
    this.grade,
    this.isFirst,
    this.isLast,
    this.onSelectItem,
    this.isSelected,
  });

  final Grade grade;
  final VoidCallback onSelectItem;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
@override
  Widget build(BuildContext context) {
    //print('onSelectet Class ${widget.grade.gradeId} ${widget.isCleared}');
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black12, width: isFirst ? 2.0 : 1.0),
            bottom: BorderSide(color: Colors.black12, width:isLast ? 2.0 : 1.0),
            left: BorderSide(color: Colors.transparent, width: 1.0),
            right: BorderSide(color: Colors.transparent, width: 1.0),
          )
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            LearninkNetworkImage(grade.gradeImageUrl),
            Text('Class ${grade.gradeId}',style:TextStyle(color:Colors.black,),),
            IconButton(padding:EdgeInsets.all(0),
                icon:Icon(MyFlutterIcons.tick,
                             size:25,
                         color:isSelected?Colors.greenAccent:Colors.black12),
              onPressed:onSelectItem,
            ),
          ],
      ),
    );
  }
}

