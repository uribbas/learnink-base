import 'package:flutter/material.dart';
import 'layout_type.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';

class HeroHeader implements SliverPersistentHeaderDelegate {
  HeroHeader({
    this.layoutGroup,
    this.onLayoutToggle,
    this.minExtent,
    this.maxExtent,
  });
  final LayoutGroup layoutGroup;
  final VoidCallback onLayoutToggle;
  double maxExtent;
  double minExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SafeArea(
          child: Image.asset(
            'assets/icons/bg-art.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 20.0,
          top: 20.0,
          child: SafeArea(
            top: true,
            right: true,
            child: FlatButton(
              color: Colors.transparent,
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ),
        Positioned(
          top: 180.0,
          left: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                  'Experience',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                child: Text(
                  'the',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Text(
                'Difference',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
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

class HeroPage extends StatelessWidget implements HasLayoutGroup {
  HeroPage({Key key, this.layoutGroup, this.onLayoutToggle}) : super(key: key);
  final LayoutGroup layoutGroup;
  final VoidCallback onLayoutToggle;

  final List<String> assetNames = [
    'assets/icons/assistive-learning.png',
    'assets/icons/create-test.png',
    'assets/icons/daily-dose.png',
    'assets/icons/wild-choice.png',
    'assets/icons/progress-report.png',
    'assets/icons/truly-adaptive.png',
    'assets/icons/percentage.png',
    'assets/icons/math.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _scrollView(context),
    );
  }

  Widget _scrollView(BuildContext context) {
    // Use LayoutBuilder to get the hero header size while keeping the image aspect-ratio
    return Container(
      decoration: BoxDecoration(
          //color: Colors.blue[800],
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue[500], Colors.blue[900]])),
      child: Container(
        margin: EdgeInsets.only(top:200.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: false,
              delegate: HeroHeader(
                layoutGroup: layoutGroup,
                onLayoutToggle: onLayoutToggle,
                minExtent: 150.0,
                maxExtent: 250.0,
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 0.0,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    padding: _edgeInsetsForIndex(index),
                    child: Image.asset(
                      assetNames[index % assetNames.length],
                    ),
                  );
                },
                childCount: assetNames.length * 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  EdgeInsets _edgeInsetsForIndex(int index) {
    if (index % 2 == 0) {
      return EdgeInsets.only(top: 4.0, left: 8.0, right: 4.0, bottom: 4.0);
    } else {
      return EdgeInsets.only(top: 4.0, left: 4.0, right: 8.0, bottom: 4.0);
    }
  }
}
