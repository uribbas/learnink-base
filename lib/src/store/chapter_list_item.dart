import 'package:flutter/material.dart';
import '../models/chapter.dart';
import '../widgets/learnink_network_image.dart';
import '../widgets/my_flutter_icons.dart';

class ChapterListItem extends StatelessWidget {
  ChapterListItem({
    this.chapter,
    this.isFirst,
    this.isLast,
    this.isSelected,
  });

  final Chapter chapter;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
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
          LearninkNetworkImage(chapter.chapterImageUrl,),
          Column(
            children: <Widget>[
              Container(
                width:120,
                child: Text(chapter.chapterTitle,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 3,
                  style: TextStyle(color: Colors.black,fontSize: 15.0,),),
              ),
              Container(
                  width:120,
                  alignment: Alignment.centerLeft,
                  child: Text('${chapter.chapterPopularityRating}',style: TextStyle(color: Colors.black,fontSize: 15.0,),)
              )
            ],
          ),

          Icon(MyFlutterIcons.tick,
              size:25,
              color:isSelected?Colors.greenAccent:Colors.black12),
        ],
      ),
    );
  }
}