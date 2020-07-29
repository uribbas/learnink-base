import 'package:flutter/material.dart';
import 'package:learnink/src/models/chapter.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';


class ChapterList extends StatelessWidget {
  ChapterList({ this.chapters,this.removeChapter,this.error});

  final List<Chapter> chapters;
  final ValueChanged<int> removeChapter;
  final bool error;
  @override
  Widget build(BuildContext context) {
    List<InlineSpan> _widgetSpan=[];

    for(int i=0;i<chapters.length;i++){
      Chapter chapter=chapters[i];
      _widgetSpan.add(WidgetSpan(
        child:Padding(
          padding: const EdgeInsets.only(left:4.0,right:4.0),
          child: OutlineButton(
            padding: EdgeInsets.all(4),
            //borderSide: BorderSide(width: 1, color: Colors.red),
            shape: RoundedRectangleBorder(
              //side: BorderSide(width:1, color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          child: Row( mainAxisSize: MainAxisSize.min,
              children:[
               Text('${chapter.chapterTitle}',style: TextStyle(color:Colors.black,fontSize: 14),),
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Icon(MyFlutterIcons.cross,color:Colors.red,size:10),
                )],),
          onPressed:()=> removeChapter(i),),
        ), ),);
    }

    return chapters.isNotEmpty?
         Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children:[
             Divider(color:Colors.black45),
             Text.rich(TextSpan(text: '', children: _widgetSpan),)]
          ,):
          Text('Please add chapters by tapping the + ',
           style: TextStyle(color:error?Colors.red:Colors.blue,fontSize: 12.0),);
  }
}
