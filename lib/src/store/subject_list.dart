import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import '../widgets/learnink_network_image.dart';
class SubjectIcon extends StatelessWidget {

  SubjectIcon({this.subject, this.parentSize}) ;
  final Subject subject;
  final double parentSize;

  @override
  Widget build(BuildContext context) {
    double edgeSize =2.0;
    double itemSize = parentSize - edgeSize * 2.0;
    print('${subject.subjectName},${subject.subjectDescription}');
    return Container(
      padding: EdgeInsets.all(edgeSize),
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        child: SizedBox(
          width: itemSize,
          child:Column(
            children: <Widget>[
              LearninkNetworkImage(subject.subjectImageUrl),
              SizedBox(height:5),
              Text('Class ${subject.gradeId}' ,overflow: TextOverflow.ellipsis, maxLines: 1, textAlign: TextAlign.center, style:TextStyle(color: Colors.black,),),
              SizedBox(height:5),
              Text(subject.subjectName ,overflow: TextOverflow.ellipsis, maxLines: 1, textAlign: TextAlign.center, style:TextStyle(color: Colors.black,),),
              SizedBox(height:5),
              Text(subject.subjectDescription ,overflow: TextOverflow.ellipsis, maxLines: 2, softWrap: true, textAlign: TextAlign.center, style:TextStyle(color:Color(0xff999999)),),
            ],
          ),
        ),
        onPressed: (){},
      ),
    );
  }
}


class SubjectList extends StatelessWidget {
  double height = 190.0;
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

        return CircularProgressIndicator();
      },
    );
  }

}

