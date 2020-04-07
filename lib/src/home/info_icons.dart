import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoIcons extends StatelessWidget {
  const InfoIcons(
      {@required this.imageSrc,
      @required this.primaryText,
      @required this.secondaryText});

  final String imageSrc;
  final String primaryText;
  final String secondaryText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: 40.0,
                ),
                child: Image.asset(
                  imageSrc,
//                height: 118,
//            width: 130,
                ),
              )
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
            ),
            child: Text(
              primaryText,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Text(
              secondaryText,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(0xff999999),
                  fontSize: 15.0,
//                fontWeight: FontWeight.w700
              ),
            ),
          )
        ],
      ),
    );
  }
}
