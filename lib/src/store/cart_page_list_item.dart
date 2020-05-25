import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learnink/src/models/cart.dart';
import 'package:learnink/src/models/subject.dart';
import 'package:learnink/src/widgets/learnink_network_image.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import 'package:learnink/src/widgets/learnink_loading_indicator.dart';
import '../services/toast_message.dart';

class CartPageListItem extends StatelessWidget {
  CartPageListItem({
    this.subject,
    this.isFirst,
    this.isLast,
    this.isSelected,
    this.animation,
    this.remove,
   });

  final Subject subject;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final Animation<double> animation;
  final VoidCallback remove;
  BuildContext listContext;

  StreamSubscription _userCart;
  Cart _userCartData;

  @override
  Widget build(BuildContext context) {
    final Database database=Provider.of<Database>(context,listen:false);
    listContext=Scaffold.of(context).context;
    _userCart = database.userCartStream().listen((data)=>_userCartData=data);
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
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: Container(
          height:100,
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
                color: Colors.white,
                child: Ink(
                  padding: EdgeInsets.all(0.0),
                  decoration: BoxDecoration(shape: BoxShape.circle, color:Colors.white),
                  child: IconButton(padding:EdgeInsets.all(0),
                    icon:Icon(Icons.delete,
                        size:25,
                        color:Color(0xffff8a80),
                    ),
                    onPressed:()=>_delete(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    ToastMessage.showToast(
        '',
        context,
        widget: Center(child: LearninkLoadingIndicator(color:Color(0xff004fe0))),
        backgroundColor: Colors.white70,duration: 20);
    Database database=Provider.of<Database>(context,listen:false);
    remove();
    //  First remove item from the cart items then set the cart
    List<Subject> _newItems= _userCartData.items;
    _newItems.removeWhere((i)=>i.documentId==subject.documentId);
    String toastMessage="Removed ${subject.subjectName} of class ${subject.gradeId} from cart";
    //BuildContext oldContext=context;
    await database.setCart(Cart (
      total: _newItems.length,
      items: _newItems,
    ));
    //ScaffoldState parentState=Scaffold.of(context);

    ToastMessage.showToast(
      toastMessage,
      listContext,
      backgroundColor:Color(0xffff8a80),);

  }

}
