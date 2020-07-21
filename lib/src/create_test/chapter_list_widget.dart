import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';
import 'chapter_list.dart';

class ChapterListWidget extends StatelessWidget {
  ChapterListWidget({
    this.chapters,
    this.addedChapters,
    this.addChapters,
    this.modifyWeights,
    this.removeChapter,
    this.error,
  });
  final List<String> chapters;
  List<String> addedChapters;
  final VoidCallback modifyWeights;
  final VoidCallback addChapters;
  final ValueChanged<int> removeChapter;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:10.0),
      child: Card(
        shadowColor: Colors.black,
        elevation: 10.0,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Chapters',
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  Spacer(),
                  IconButton(
                    icon:Icon(MyFlutterIcons.settings),
                    color:addedChapters.length==0?Colors.grey:Colors.blue ,
                    onPressed:modifyWeights,),

                  IconButton(
                    icon: Icon(Icons.add),
                    color: chapters.isEmpty?Colors.grey:Colors.blue,
                    onPressed:addChapters,
                  ),
                ],
              ),
              ChapterList(
                chapters: addedChapters,
                removeChapter:removeChapter,
                error:error,
              )
            ],
          ),
        ),
      ),
    );
  }
}
