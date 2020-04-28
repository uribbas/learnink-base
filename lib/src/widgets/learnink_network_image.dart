import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LearninkNetworkImage extends StatelessWidget {
  LearninkNetworkImage(@required this.imageUrl,{this.height:100.0, this.width:100.0});
 final double height;
  final double width;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: Colors.transparent,
      child:CachedNetworkImage(
        imageUrl:imageUrl,
        placeholder: (context,url)=>Image.asset('assets/icons/loader.gif'),
        errorWidget: (context,url,error)=>Icon(Icons.error,),
           )
     // child: Image.network(imageUrl),

    );
  }

}
