import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../widgets/white_page_template.dart';
import '../services/database.dart';
import '../widgets/learnink_network_image.dart';
import '../widgets/my_flutter_icons.dart';
import '../models/grade.dart';
import 'grade_detail.dart';


class GradePageListItem extends StatelessWidget {
  GradePageListItem({
    this.grade,
    this.isFirst,
    this.isLast,
    this.onSelectItem,
    this.isSelected,
    this.database,
  });

  final Grade grade;
  final VoidCallback onSelectItem;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final Database database;

  @override
  Widget build(BuildContext context) {
    //print('onSelectet Class ${widget.grade.gradeId} ${widget.isCleared}');
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black12, width: isFirst ? 2.0 : 1.0),
            bottom: BorderSide(
                color: Colors.black12, width: isLast ? 2.0 : 1.0),
            left: BorderSide(color: Colors.transparent, width: 1.0),
            right: BorderSide(color: Colors.transparent, width: 1.0),
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            padding: EdgeInsets.all(0.0),
            child: LearninkNetworkImage(grade.gradeImageUrl),
            onPressed: () => _onGradeDetailView(context),),
          Text(
            'Class ${grade.gradeId}', style: TextStyle(color: Colors.black,),),
          IconButton(padding: EdgeInsets.all(0),
            icon: Icon(MyFlutterIcons.tick,
                size: 25,
                color: isSelected ? Colors.greenAccent : Colors.black12),
            onPressed: onSelectItem,
          ),
        ],
      ),
    );
  }

  void _onGradeDetailView(BuildContext context) async {
    final subjectRef=await database.getCollectionRef('subjects');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          print('Inside onViewGradeDetail');
          return StreamBuilder(
            stream: database.selectedSubjectsRefStream(
                subjectRef.where('gradeId', isEqualTo: grade.gradeId)
            ),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                final List<Subject> subjects = snapshot.data;
                print('onViewSubjectDetail chapters ${subjects.length}');
                return GradeDetail(grade: grade, subjects: subjects,database: database,);
              }
              if(snapshot.hasError){
                print('onViewSubjectDetail ${snapshot.error}');
                return WhitePageTemplate(title:'Error!',
                    child:Text('Some error occured',style:
                    TextStyle(color:Colors.red,
                      fontSize: 20.0,
                    ),),);
              }
              return WhitePageTemplate(title:'Laoding...',
                child:Center(child:CircularProgressIndicator(),),);
            },
          );
        },
      ),
    );
  }

  }


