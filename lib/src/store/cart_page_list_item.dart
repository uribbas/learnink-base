import 'package:flutter/material.dart';
import 'package:learnink/src/models/subject.dart';
import 'package:learnink/src/widgets/learnink_network_image.dart';

class CartPageListItem extends StatelessWidget {
  CartPageListItem({
    this.subject,
    this.isFirst,
    this.isLast,
    this.isSelected,
  });

  final Subject subject;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black12, width: isFirst ? 2.0 : 1.0),
            bottom: BorderSide(color: Colors.black12, width:isLast ? 2.0 : 1.0),
            left: BorderSide(color: Colors.transparent, width: 1.0),
            right: BorderSide(color: Colors.transparent, width: 1.0),
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          LearninkNetworkImage(subject.subjectImageUrl),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text('Class ${subject.gradeId}',style:TextStyle(color:Colors.black,),),
              Text(subject.subjectName,style: TextStyle(color:Colors.black87,fontSize: 15.0,),),
              Flexible(child: Container(
                width:120,
                child: Text(subject.subjectDescription,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 4,
                  style: TextStyle(color:Color(0xff999999),fontSize:12.0,),),
              ),),
               Text('\u{20B9}  ${subject.price["inr"]}',
                   style:TextStyle(color:Colors.green,fontSize: 20.0,),),],),

          Material(
            child: Ink(
              padding: EdgeInsets.all(0.0),
              decoration: BoxDecoration(shape: BoxShape.circle, color:Colors.red),
              child: IconButton(padding:EdgeInsets.all(0),
                icon:Icon(Icons.remove,
                    size:25,
                    color:Colors.white),
                onPressed:()=>_checkOut(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

void _checkOut(BuildContext context){

}

}
