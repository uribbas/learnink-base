import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/learnink_network_image.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';
import '../models/grade.dart';

class GradePageListItem extends StatefulWidget {
  GradePageListItem({this.grade, this.onSelectItem,this.isCleared});

  final Grade grade;
  final VoidCallback onSelectItem;
  final bool isCleared;

  @override
  _GradePageListItemState createState() => _GradePageListItemState();
}

class _GradePageListItemState extends State<GradePageListItem> {
  bool _selected=false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        LearninkNetworkImage(widget.grade.gradeImageUrl),
        Text('Class ${widget.grade.gradeId}',style:TextStyle(color:Colors.black,),),
        IconButton(padding:EdgeInsets.all(0),
            icon:Icon(MyFlutterIcons.tick,
                         size:30,
                     color:!widget.isCleared && _selected?Colors.green:Colors.grey),
          onPressed:_onSelectItem,
        ),

      ],);
  }
  void _onSelectItem()
  {
    setState(() {
      _selected=!_selected;
    });
    widget.onSelectItem();
  }

}


class GradePageList extends StatelessWidget {
  GradePageList({this.grades,this.isCleared,this.onSelectItem});
  final bool isCleared;
  final List<Grade> grades;
  final ValueChanged<int> onSelectItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
          //shrinkWrap: true,
          //physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context,index) {
             if(index==0 || index==grades.length+1){
                 return Container();
                }
             return Padding(
               padding:EdgeInsets.all(10),
               child: GradePageListItem(grade:grades[index-1],
                    onSelectItem:()=>onSelectItem(index-1),
                    isCleared: isCleared,),
             );
           },
          separatorBuilder:(_,__)=>Divider(height:0.5,color:Colors.black),
          itemCount: grades.length+2),
    );
  }
}
