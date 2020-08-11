import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:learnink/src/bookshelves/test_icon.dart';
import 'package:learnink/src/models/test.dart';
import 'package:learnink/src/services/auth.dart';
import 'package:learnink/src/services/database.dart';
import 'package:learnink/src/widgets/custom_divider.dart';
import 'package:learnink/src/widgets/learnink_empty_content.dart';
import 'package:learnink/src/widgets/learnink_loading_indicator.dart';
import 'package:provider/provider.dart';

class TestList extends StatefulWidget {
  @override
  _TestListState createState() => _TestListState();
}

class _TestListState extends State<TestList> {
  List<Test> _newTests=[];
  List<Test> _ongoingTests=[];
  List<Test> _completedTests=[];
  bool _error=false;
  bool _initiated=false;
  Database _database;
  StreamSubscription _subscriptionNew;
  StreamSubscription _subscriptionOngoing;
  StreamSubscription _subscriptionComplete;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp)=>_subscribeToTests());
  }

  void _subscribeToTests() async{
    _database=Provider.of<Database>(context,listen: false);
    AuthBase auth=Provider.of<AuthBase>(context,listen:false);
    User user=await auth.currentUser();
    _subscriptionNew=_database.testListStream(user.uid,['new']).listen((List<Test> tests) {
      _error=false;
      _initiated=true;
      _newTests=tests;
      setState(() {});
    },
    onError:(error){
      print('$error');
      _error=true;
      _initiated=true;
      _newTests=[];
      setState(() {});
    });

    _subscriptionOngoing=_database.testListStream(user.uid,['ongoing']).listen((List<Test> tests) {
      _error=false;
      _initiated=true;
      _ongoingTests=tests;
      setState(() {});
    },
        onError:(error){
          print('$error');
          _error=true;
          _initiated=true;
          _ongoingTests=[];
          setState(() {});
        });
    _subscriptionOngoing=_database.testListStream(user.uid,['complete'],10).listen((List<Test> tests) {
      _error=false;
      _initiated=true;
      _completedTests=tests;
      setState(() {});
    },
        onError:(error){
          print('$error');
          _error=true;
          _initiated=true;
          _completedTests=[];
          setState(() {});
        });

  }

  @override
  void dispose() {
      super.dispose();
      _subscriptionNew.cancel();
      _subscriptionOngoing.cancel();
      _subscriptionComplete.cancel();
    }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: <Widget>[
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
          title: Text('Tests'),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop()),
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
          child: _initiated?_scrollView():LearninkLoadingIndicator(color:Colors.blue),
        ),
      ),
    ]);
  }
  Widget _scrollView(){

    if(_error){
      return Center(
          child:LearninkEmptyContent(imageUrl:'assets/icons/evs.png',
              primaryText:'Some error occured')
      );
    }

    if(_newTests.isEmpty && _ongoingTests.isEmpty && _completedTests.isEmpty){
      return Center(
        child:LearninkEmptyContent(
          imageUrl: 'assets/icons/evs.png',
          primaryText: 'No tests to show',
        )
      );
    }

    List<Widget> customSliverList=[];
     double height=170;
     double width=140;

    if(_ongoingTests.isNotEmpty){
      customSliverList.add(
          SliverToBoxAdapter(
              child:Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDivider(leadingText:'Ongoing tests',onMore:(){} ,),
                  SizedBox(
                    height: height,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _ongoingTests.length,
                        itemBuilder: (BuildContext content, int index) {
                          return TestIcon(test:_ongoingTests[index],parentSize:width,);
                        }),
                  ),
                ],
              )
          )
      );
    }

    if(_newTests.isNotEmpty){
      customSliverList.add(
        SliverToBoxAdapter(
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomDivider(leadingText:'New tests',onMore:(){} ,),
                SizedBox(
                  height: height,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _newTests.length,
                      itemBuilder: (BuildContext content, int index) {
                        return TestIcon(test:_newTests[index],parentSize:width,);
                      }),
                ),
              ],
            )
        )
      );
    }

    if(_completedTests.isNotEmpty){
      customSliverList.add(
          SliverToBoxAdapter(
              child:Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomDivider(leadingText:'Completed tests',onMore:(){} ,),
                  SizedBox(
                    height: height,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _completedTests.length,
                        itemBuilder: (BuildContext content, int index) {
                          return TestIcon(test:_completedTests[index],parentSize:width,);
                        }),
                  ),
                ],
              )
          )
      );
    }


    return CustomScrollView(
      slivers:customSliverList,
    );
  }
}
