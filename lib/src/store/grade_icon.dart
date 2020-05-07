import 'package:flutter/material.dart';
import 'package:learnink/src/models/grade.dart';
import 'package:learnink/src/models/subject.dart';
import 'package:learnink/src/services/database.dart';
import 'package:learnink/src/store/grade_detail_page.dart';
import 'package:learnink/src/widgets/learnink_empty_content.dart';
import 'package:learnink/src/widgets/learnink_loading_indicator.dart';
import 'package:learnink/src/widgets/learnink_network_image.dart';
import 'package:learnink/src/widgets/white_page_template.dart';
import 'package:provider/provider.dart';

class GradeIcon extends StatelessWidget {

  GradeIcon({this.grade, this.parentSize}) ;
  final Grade grade;
  final double parentSize;

  @override
  Widget build(BuildContext context) {
    double edgeSize =2.0;
    double itemSize = parentSize - edgeSize * 2.0;
    return Container(
      padding: EdgeInsets.all(edgeSize),
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        child: SizedBox(
          width: itemSize,
          child:Column(
            children: <Widget>[
              LearninkNetworkImage(grade.gradeImageUrl),
              SizedBox(height:5),
              Text('Class ${grade.gradeId}' ,style:TextStyle(color:Colors.black),),
            ],
          ),
        ),
        onPressed: ()=>_onViewGradeDetail(context,grade),
      ),
    );
  }

  void _onViewGradeDetail(BuildContext context,Grade grade) async {
    final Database database=Provider.of<Database>(context,listen:false);
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
                return WhitePageTemplate(title:'',
                  child: LearninkEmptyContent(text:'Some error occured',
                    imageUrl:'assets/icons/evs.png',),);
              }
              return WhitePageTemplate(title:'',
                child: LearninkLoadingIndicator(color:Color(0xff004fe0)),);
            },
          );
        },
      ),
    );
  }
}



