import 'package:flutter/material.dart';
import 'layout_type.dart';
import 'info_icons.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import '../login/sign_in_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:HeroPage(),
    );
  }
}

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
            top:true,
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    fullscreenDialog: true,
                    builder: (context) => SignInPage.create(context),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
            top: 100,
            left: 20,
            child: Container(
              color: Colors.transparent,
              height: 50,
              width: 50,
              child: Image.asset(
                'assets/icons/science.png',
                fit: BoxFit.cover,
              ),
            )
        ),
        Positioned(
          top: 150.0,
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
            ],
          ),
        ),
        Positioned(
          top: 200.0,
          left: 22.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                  'the',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 240.0,
          left: 20.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text(
                  'Difference',
                  style: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 310.0,
          left: 0.0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 35.0,
//            margin: EdgeInsets.only(top:200.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
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

//  final List<String> assetNames = [
//    'assets/icons/assistive-learning.png',
//    'assets/icons/create-test.png',
//    'assets/icons/daily-dose.png',
//    'assets/icons/wild-choice.png',
//    'assets/icons/progress-report.png',
//    'assets/icons/truly-adaptive.png',
//    'assets/icons/percentage.png',
//    'assets/icons/math.png',
//  ];

  final List<Widget> assetNames = [
    InfoIcons(
      imageSrc: 'assets/icons/create-test.png',
      primaryText: 'Create Test',
      secondaryText: 'Why not build your own test?',
    ),
    InfoIcons(
      imageSrc: 'assets/icons/daily-dose.png',
      primaryText: 'Daily Dose',
      secondaryText: 'Knowledge pills for you',
    ),
    InfoIcons(
      imageSrc: 'assets/icons/wild-choice.png',
      primaryText: 'Wild Choices',
      secondaryText: 'Be Wild,be wise',
    ),
    InfoIcons(
      imageSrc: 'assets/icons/assistive-learning.png',
      primaryText: 'Assistive Inbuilt',
      secondaryText: 'Fun and interestingly helpful',
    ),
    InfoIcons(
      imageSrc: 'assets/icons/truely-adaptive.png',
      primaryText: 'Truly Adaptive',
      secondaryText: 'Adapts to what you need',
    ),
    InfoIcons(
      imageSrc: 'assets/icons/progress-report.png',
      primaryText: 'Progress Report',
      secondaryText: 'Know your progress',
    ),
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
      color: Colors.white,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: false,
            delegate: HeroHeader(
              layoutGroup: layoutGroup,
              onLayoutToggle: onLayoutToggle,
              minExtent: 340.0,
              maxExtent: 340.0,
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 205.0,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  padding: _edgeInsetsForIndex(index),
                  child: assetNames[index],
                );
              },
              childCount: assetNames.length,
            ),
          ),
        ],
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
