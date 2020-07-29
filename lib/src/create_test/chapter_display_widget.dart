import 'package:flutter/material.dart';
import 'package:learnink/src/models/chapter.dart';
import 'package:learnink/src/widgets/custom_outline_button.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';

class ChapterDisplayWidget extends StatefulWidget {
 ChapterDisplayWidget({this.chapters,this.selectedChapters,this.onAddChapters});

  final List<Chapter> chapters;
  final List<Chapter> selectedChapters;
  final ValueChanged<List<Chapter>> onAddChapters;

  @override
  _ChapterDisplayWidgetState createState() => _ChapterDisplayWidgetState();
}

class _ChapterDisplayWidgetState extends State<ChapterDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      alignment: Alignment.center,
      color: Colors.black45,

      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width - 100,
        color: Colors.transparent,

        child: Card(
          color: Colors.white,
          elevation: 20.0,
          child: Padding(
            padding: const EdgeInsets.only(left:20.0,right:20,bottom:30),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder:(BuildContext context,int index){
                  if(index==0){
                    return Text('Add chapters',style:TextStyle(color:Colors.black,fontSize: 18.0),);
                  }
                  else if(index < widget.chapters.length+1) {
                  return Row(
                   children: [
                    Text('${widget.chapters[index-1].chapterTitle}',
                     style: TextStyle(color: Colors.black, fontSize: 16.0),),
                    Spacer(),
                    IconButton(icon: Icon(MyFlutterIcons.tick),
                     color: widget.selectedChapters.contains(widget.chapters[index-1])
                         ? Colors.green
                         : Colors.grey,
                     onPressed: ()=>_onSelectChapter(index -1),
                    ),

                   ],
                  );
                 }else if(index==widget.chapters.length+1){
                    return widget.selectedChapters.isEmpty?
                         Text('Please select atleast one chapter',
                           style:TextStyle(color: Colors.red,fontSize: 12.0),)
                        :Container();
                  }
                  else{
                  return Row(
                    children:[
                      Spacer(),
                      FlatButton(
                          child:Text('Add',
                          style: TextStyle(color:Colors.blue,fontSize: 16.0),),
                          onPressed: _onAddChapters,
                       ),
                    ],
                  );
                 }
                },
                separatorBuilder: (BuildContext context,int index){
                      return index < widget.chapters.length+1?
                      Divider(color: Colors.black45,):
                      Container();
                   },
                itemCount: widget.chapters.length+3
            ),
          ),
        ),
      ),
    );
  }
  void _onSelectChapter(int index){
    if (widget.selectedChapters.contains(widget.chapters[index])) {
       widget.selectedChapters.remove(widget.chapters[index]);
    } else {
       widget.selectedChapters.add(widget.chapters[index]);
    }
    setState(() {});
  }
  void _onAddChapters(){
    if(widget.selectedChapters.isEmpty){
      setState(() {});

    }else {
      widget.onAddChapters(widget.selectedChapters);
    }

  }
}
