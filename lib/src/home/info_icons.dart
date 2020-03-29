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
          Image.asset(
            imageSrc,
            height: 130,
            width: 130,
          ),
          Text(
            primaryText,
            style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.w500),
          ),
          Text(
            secondaryText,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 8.0,
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
