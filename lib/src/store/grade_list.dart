import 'package:flutter/material.dart';
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
        onPressed: (){},
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

