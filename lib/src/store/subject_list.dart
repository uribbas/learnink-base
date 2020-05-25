import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/learnink_loading_indicator.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import 'subject_icon.dart';

class SubjectList extends StatelessWidget {
  double height = 210.0;
  double width=140.0;
  @override
  Widget build(BuildContext context) {
    final Database database=Provider.of<Database>(context);
    return StreamBuilder(
      stream:database.subjectsStream(),
      builder:(context,snapshot) {

        if(snapshot.hasData) {
          final List<Subject> subjects = snapshot.data;
          if (subjects.isNotEmpty) {
            return SizedBox(
              height: height,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: subjects.length,
                  itemBuilder: (BuildContext content, int index) {
                    return SubjectIcon(subject:subjects[index],parentSize:width,);
                  },),
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

        return Container(child: Center(child: LearninkLoadingIndicator(color:Color(0xff004fe0))));
      },
    );
  }

}

