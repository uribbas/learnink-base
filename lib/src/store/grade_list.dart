import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/learnink_loading_indicator.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import '../models/grade.dart';
import 'grade_icon.dart';

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

        return LearninkLoadingIndicator(color:Colors.green);
      },
    );
  }

  }

