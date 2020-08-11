import 'package:flutter/material.dart';
import 'package:learnink/src/models/test.dart';
import 'package:learnink/src/widgets/learnink_network_image.dart';

class TestDetail extends StatelessWidget {

 TestDetail({this.test});

  final Test test;

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
          title: Text('${test.testTitle}'),
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
          child: SingleChildScrollView(
            child:Column(
              children: [
                LearninkNetworkImage(test.testImageUrl,height:200,width:200),
                Divider(color:Colors.black45),
              ],
            )
          ),
        ),
      ),
    ]);
  }
}
