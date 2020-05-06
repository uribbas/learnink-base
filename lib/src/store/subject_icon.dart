import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'subject_detail_page.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import '../models/chapter.dart';
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
        onPressed: ()=>_onViewSubjectDetail(context,subject),
      ),
    );
  }


  void _onViewSubjectDetail(BuildContext context,Subject subject) async {
    final Database database=Provider.of<Database>(context,listen:false);
    final chapterRef=await database.getCollectionRef('chapters');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          print('Inside onViewSubjectDetail');
          return StreamBuilder(
            stream: database.selectedChaptersRefStream(
                chapterRef.where('gradeId', isEqualTo: subject.gradeId)
                    .where('subjectId', isEqualTo: subject.subjectId)
            ),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                final List<Chapter> chapters = snapshot.data;
                print('onViewSubjectDetail chapters ${chapters.length}');
                return SubjectDetail(subject: subject, chapters: chapters);
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

