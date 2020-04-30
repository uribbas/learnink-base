import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:learnink/src/widgets/custom_outline_button.dart';
import 'package:learnink/src/widgets/learnink_network_image.dart';
import '../models/subject.dart';
import '../models/chapter.dart';
import '../widgets/my_flutter_icons.dart';
import '../widgets/notification_icon_button.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectDetailHeader implements SliverPersistentHeaderDelegate {
  SubjectDetailHeader({this.subject, this.maxExtent, this.minExtent});

  final Subject subject;
  final double maxExtent;
  final double minExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxExtent,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LearninkNetworkImage(subject.subjectImageUrl,
              height: 200, width: 200),
          SizedBox(height: 5.0),
          Text(
            'Class ${subject.gradeId}',
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          SizedBox(height: 5.0),
          Text(
            subject.subjectName,
            style: TextStyle(color: Colors.black, fontSize: 18.0),
          ),
          SizedBox(height: 5.0),
          Text(
            subject.subjectDescription,
            style: TextStyle(color: Colors.black, fontSize: 15.0),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
}

class SubjectDetailBody extends StatelessWidget {
  SubjectDetailBody({this.subject, this.chapters});

  final Subject subject;
  final List<Chapter> chapters;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff004fe0),
                Color(0xff002d7f),
              ],
              stops: [0.2, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
            top: true,
            child: Container(
              color: Colors.transparent,
//                height: 50,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/icons/bg-art.png',
              ),
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text('${subject.subjectName}'),
            actions: <Widget>[
              NotificationIconButton(
                size: 50,
                icon: MyFlutterIcons.shopping_cart,
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.white, width: 2.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            //color: Colors.white,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPersistentHeader(
                  pinned: false,
                  delegate: SubjectDetailHeader(
                      subject: subject, maxExtent: 350.0, minExtent: 350.0),
                ),
                SliverFixedExtentList(
                  itemExtent: 120.0,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child:Container(
                          child: Text('Grade: ${chapters[index].gradeId} Title: ${chapters[index].chapterTitle}', style: TextStyle(color: Colors.redAccent),),
                        ),
                      );
                    },
                    childCount: chapters.length,
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  // fillOverscroll: true, // Set true to change overscroll behavior. Purely preference.
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: CustomOutlineButton(
                        child: Text(
                          'Add to Bag',
                          style: TextStyle(color: Colors.black),
                        ),
                        borderColor: Colors.black,
                        elevationColor: Colors.black,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SubjectDetail extends StatelessWidget {
  SubjectDetail({this.subject, this.chapters});

  final Subject subject;
  final List<Chapter> chapters;

  @override
  Widget build(BuildContext context) {
    print("Chapters length ${chapters.length} ${subject.subjectId}");
    return SubjectDetailBody(subject: subject, chapters: chapters,);
//    final Database database=Provider.of<Database>(context);
//    return StreamBuilder(
//      stream: database.chaptersStream(),
//      builder:(context,snapshot) {
//        if (snapshot.hasData) {
//          final List<Chapter> chapters = snapshot.data;
//          if (chapters.isNotEmpty) {
//            return SubjectDetailBody(subject: subject, chapters: chapters,);
//          }
//          return SizedBox(
//              height: 20.0,
//              child: Text(
//                'Nothing to show here', style: TextStyle(color: Colors.black),)
//          );
//        }
//        if (snapshot.hasError) {
//          return Center(
//            child: Text('Some error has ocurred',
//              style: TextStyle(color: Colors.black,),),);
//        }
//
//        return CircularProgressIndicator();
//      }
//    );
  }
}
