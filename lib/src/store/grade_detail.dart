import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../services/database.dart';
import 'subject_page_list_item.dart';
import '../models/grade.dart';
import '../widgets/custom_outline_button.dart';
import '../widgets/learnink_network_image.dart';
import '../models/subject.dart';
import '../widgets/my_flutter_icons.dart';
import '../widgets/notification_icon_button.dart';

class GradeDetailHeader implements SliverPersistentHeaderDelegate {
  GradeDetailHeader({
    this.grade,
    this.maxExtent,
    this.minExtent,
  });

  final Grade grade;
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
          LearninkNetworkImage(grade.gradeImageUrl, height: 200, width: 200),
          SizedBox(height: 5.0),
          Text(
            'Class ${grade.gradeId}',
            style: TextStyle(color: Colors.black, fontSize: 20.0),
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

class GradeDetail extends StatelessWidget {
  GradeDetail({this.grade, this.subjects,this.database});

  final Grade grade;
  final List<Subject> subjects;
  List<int> _selected = [];
  final Database database;
  StreamController<List<int>> _selectedController = StreamController();

  void _onSelectItem(int index) {
    List<int> selectedList = _selected;
    selectedList.contains(index)
        ? selectedList.remove(index)
        : selectedList.add(index);
    _selected = List.from(selectedList);
    _selectedController.add(_selected);
  }

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
            title: Text('Class ${grade.gradeId}'),
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
          body: StreamBuilder(
            stream: _selectedController.stream,
            initialData: _selected,
            builder: (context, snapshot) {
              List<int> _selectedList = [];
              if (snapshot.hasData) {
                print('snapshot value ${snapshot.data}');
                _selectedList = List.from(snapshot.data);
              }

              if (snapshot.hasError) {
                _selectedList = [];
              }

              return Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                      style: BorderStyle.solid),
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
                      delegate: GradeDetailHeader(
                        grade: grade,
                        maxExtent: 250.0,
                        minExtent: 250.0,
                      ),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 120.0,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return SubjectPageListItem(
                            subject: subjects[index],
                            isFirst: index == 0,
                            isLast: index == subjects.length - 1,
                            isSelected: _selectedList.contains(index),
                            onSelectItem: () => _onSelectItem(index),
                            database: database,
                          );
                        },
                        childCount: subjects.length,
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
              );
            },
          ),
        ),
      ],
    );
  }
}
