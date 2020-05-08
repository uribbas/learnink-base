import 'package:flutter/material.dart';

class LearninkEmptyContent extends StatelessWidget {
  const LearninkEmptyContent({
    @required this.imageUrl,
    @required this.primaryText,
    this.secondaryText:'',
    this.primaryTextColor:Colors.black,
    this.secondaryTextColor:Colors.black26,
  });
  final String primaryText;
  final String secondaryText;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
         child: Column(
           mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height:100,
                width:100,
                child: Image.asset(imageUrl),
            ),
            Text(primaryText,style:TextStyle(color:primaryTextColor,fontSize: 20.0),),
              Text(secondaryText,style:TextStyle(color:secondaryTextColor,fontSize:15.0),),

          ],
        ),
    ),
      
    );
  }
}
