import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
import 'package:learnink/src/bookshelves/test_list.dart';
import '../services/database.dart';
import '../create_test/create_test.dart';
import 'package:provider/provider.dart';
import '../test/test_manager.dart';


class BookshelvesHeader implements SliverPersistentHeaderDelegate {
  BookshelvesHeader({
    this.minExtent,
    this.maxExtent,
  });

  double maxExtent;
  double minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) =>true;

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;


  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Image.asset(
                'assets/icons/bg-art.png',
              ),
            ),
          ),
        ),

        AlignPositioned(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 35.0,
//            margin: EdgeInsets.only(top:200.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                  style: BorderStyle.solid
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class Bookshelves extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Database database=Provider.of<Database>(context);
    return FlatButton(child:Text('Open Test page',
        style:TextStyle(color:Colors.blue)
    ),
    onPressed: (){
        Navigator.of(context).push(
        MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => TestList(),
        ),
        );
    }

    );

}
}