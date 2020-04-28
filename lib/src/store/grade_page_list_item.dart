import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/learnink_network_image.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';
import '../models/grade.dart';


class GradePageListItem extends StatefulWidget {
  GradePageListItem({this.grade, this.isFirst, this.isLast, this.onSelectItem,this.isCleared});

  final Grade grade;
  final VoidCallback onSelectItem;
  final bool isCleared;
  final bool isFirst;
  final bool isLast;

  @override
  _GradePageListItemState createState() => _GradePageListItemState();
}

class _GradePageListItemState extends State<GradePageListItem> {
  bool _selected=false;
  @override
  Widget build(BuildContext context) {
    print('onSelectet Class ${widget.grade.gradeId} ${widget.isCleared}');
    _selected= widget.isCleared ? false :_selected;
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black12, width: widget.isFirst ? 2.0 : 1.0),
            bottom: BorderSide(color: Colors.black12, width: widget.isLast ? 2.0 : 1.0),
            left: BorderSide(color: Colors.transparent, width: 1.0),
            right: BorderSide(color: Colors.transparent, width: 1.0),
          )
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            LearninkNetworkImage(widget.grade.gradeImageUrl),
            Text('Class ${widget.grade.gradeId}',style:TextStyle(color:Colors.black,),),
            IconButton(padding:EdgeInsets.all(0),
                icon:Icon(MyFlutterIcons.tick,
                             size:25,
                         color:!widget.isCleared && _selected?Colors.greenAccent:Colors.black12),
              onPressed:_onSelectItem,
            ),
          ],
      ),
    );
  }
  void _onSelectItem()
  {
    setState(() {
      _selected= !_selected;
    });
    widget.onSelectItem();
  }

}

