import 'package:flutter/material.dart';
import 'package:learnink/src/bookshelves/test_detail.dart';
import 'package:learnink/src/models/test.dart';
import 'package:learnink/src/widgets/learnink_network_image.dart';

class TestIcon extends StatelessWidget {

  TestIcon({this.test, this.parentSize}) ;
  final Test test;
  final double parentSize;

  @override
  Widget build(BuildContext context) {
    double edgeSize =2.0;
    double itemSize = parentSize - edgeSize * 2.0;
    return Container(
      padding: EdgeInsets.all(edgeSize),
      child: FlatButton(
        padding: EdgeInsets.all(0.0),
        child: SizedBox(
          width: itemSize,
          child:Column(
            children: <Widget>[
              LearninkNetworkImage(test.testImageUrl),
              SizedBox(height:5),
              Text('${test.testTitle}'.substring(0,15)+(test.testTitle.length >15?'...':'') ,style:TextStyle(color:Colors.black),),
              Text('${test.testDate!=null?test.testDate.toIso8601String():""}',style:TextStyle(color:Colors.black38),)
            ],
          ),
        ),
        onPressed: ()=>_onViewTestDetail(test,context),
      ),
    );
  }

  void _onViewTestDetail(Test test,BuildContext context){
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          print('Inside onViewGradeDetail');
          return TestDetail(test:test);
        },
      ));

  }
}



