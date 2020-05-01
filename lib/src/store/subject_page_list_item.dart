import 'package:flutter/material.dart';
import 'package:learnink/src/models/chapter.dart';
import 'package:learnink/src/services/database.dart';
import 'package:learnink/src/store/subject_detail.dart';
import 'package:learnink/src/widgets/learnink_network_image.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';
import '../models/subject.dart';

class SubjectPageListItem extends StatelessWidget {
  SubjectPageListItem({
    this.subject,
    this.isFirst,
    this.isLast,
    this.onSelectItem,
    this.isSelected,
    this.database,
  });

  final Subject subject;
  final VoidCallback onSelectItem;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final Database database;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black12, width: isFirst ? 2.0 : 1.0),
            bottom: BorderSide(color: Colors.black12, width:isLast ? 2.0 : 1.0),
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
              child: LearninkNetworkImage(subject.subjectImageUrl),
          onPressed:()=> _onSubjectDetailView(context),),
          Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children:[
                Text('Class ${subject.gradeId}',style:TextStyle(color:Colors.black,),),
                Text(subject.subjectName,style: TextStyle(color:Colors.black87,fontSize: 15.0,),),
                Flexible(child: Container(
                    width:120,
                  child: Text(subject.subjectDescription,
                     overflow: TextOverflow.ellipsis,
                     softWrap: false,
                     maxLines: 4,
                     style: TextStyle(color:Color(0xff999999),fontSize:12.0,),),
                ),),
               ],),
          IconButton(padding:EdgeInsets.all(0),
            icon:Icon(MyFlutterIcons.tick,
                size:25,
                color:isSelected?Colors.greenAccent:Colors.black12),
            onPressed:onSelectItem,
          ),
        ],
      ),
    );
  }

  void _onSubjectDetailView(BuildContext context) async {
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
