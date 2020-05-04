import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learnink/src/widgets/custom_outline_button.dart';
import 'package:learnink/src/widgets/learnink_network_image.dart';
import '../models/subject.dart';
import '../models/chapter.dart';
import '../models/cart.dart';
import '../widgets/my_flutter_icons.dart';
import '../widgets/notification_icon_button.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';

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

class SubjectDetail extends StatelessWidget {

  SubjectDetail({this.subject, this.chapters});

  final Subject subject;
  final List<Chapter> chapters;

  StreamSubscription _userCart;
  Cart _userCartData;

  void _onAddtoBag(Database database)
  async {
    //  First create the cart items then set the cart
    List<Subject> _newItems=_userCartData !=null ? _userCartData.items : [];
    _newItems.indexWhere((i)=>i.documentId==subject.documentId) == -1 ?
    _newItems.add(subject)
        :
    null;
    await database.setCart(Cart (
      total: _newItems.length,
      items: _newItems,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Database database = Provider.of<Database>(context,listen: false);
    _userCart = database.userCartStream().listen((data)=>_userCartData=data);
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
                      return ChapterListItem(chapter:chapters[index],
                          isFirst: index==0,
                          isLast: index==chapters.length-1,
                          isSelected: true,
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
                        onPressed: ()=>_onAddtoBag(database),
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

