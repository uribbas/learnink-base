import 'package:flutter/material.dart';
import 'package:learnink/src/models/subject.dart';
import 'package:learnink/src/store/grade_detail.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import '../models/grade.dart';
import '../widgets/learnink_network_image.dart';
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
                return Container(color:Colors.white,
                  child: Center(child: Text('${snapshot.error}', style: TextStyle(fontSize: 14.0),)),
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}




class GradeList extends StatelessWidget {
  double height = 160.0;
  double width=140.0;
  @override
  Widget build(BuildContext context) {
    final Database database=Provider.of<Database>(context);
    return StreamBuilder(
      stream:database.gradesStream(),
      builder:(context,snapshot) {

        if(snapshot.hasData) {
          final List<Grade> grades = snapshot.data;
          if (grades.isNotEmpty) {
            return SizedBox(
              height: height,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: grades.length,
                  itemBuilder: (BuildContext content, int index) {
                    return GradeIcon(grade:grades[index],parentSize:width,);
               }),
            );
          }
        return SizedBox(
          height:height,
          child:Text('Nothing to show here',style:TextStyle(color:Colors.black),)
        );
      }
        if(snapshot.hasError){
          return Center(
              child:Text('Some error has ocurred',style:TextStyle(color:Colors.black,),),);
        }

        return CircularProgressIndicator();
      },
    );
  }

  }

