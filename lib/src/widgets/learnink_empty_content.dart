import 'package:flutter/material.dart';

class LearninkEmptyContent extends StatelessWidget {
  const LearninkEmptyContent({@required this.text,@required this.imageUrl});
  final String text;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
        children: <Widget>[
          Container(
            height:100,
              width:100,
              child: Image.asset(imageUrl),
          ),
          Text(text,style:TextStyle(color:Colors.green,fontSize: 20.0),
          ),
        ],
      ),
      
    );
  }
}
