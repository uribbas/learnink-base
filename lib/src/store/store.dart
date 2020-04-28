import 'package:flutter/material.dart';
import 'package:learnink/src/widgets/notification_icon_button.dart';
import 'package:learnink/src/widgets/my_flutter_icons.dart';
import 'store_nested_list.dart';

class Store extends StatelessWidget {
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
          title: Text('Store'),
          actions: <Widget>[
            NotificationIconButton(
                size:50,
                icon:MyFlutterIcons.shopping_cart,
            color:Colors.white,
            onPressed: (){},),
            ],
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color:Colors.white,
                border: Border.all(
                    color: Colors.white, width: 2.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              //color: Colors.white,
              child: StoreNestedList()),
        ),
      ),
    ]);
  }
}
