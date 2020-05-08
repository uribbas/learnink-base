import 'package:flutter/material.dart';
import 'package:align_positioned/align_positioned.dart';
import 'package:provider/provider.dart';
import '../services/database.dart';
import 'cart_page_animated.dart';

class NotificationIconButton extends StatelessWidget {

NotificationIconButton({
  this.size,
  this.icon,
  this.color,
  });

  final double size;
  final IconData icon;
  final Color color;



  @override
  Widget build(BuildContext context) {
//    print("Notification NotificationIconButton wizard stream");
    final Database database = Provider.of<Database>(context,listen: false);
    int counter = 0;
    final double newSize=size;
     return StreamBuilder(
         stream: database.userCartStream(),
         builder: (context, snapshot) {
           if(snapshot.hasData){
             counter = snapshot.data.total;
           }
           if(snapshot.hasError){
             print("Cart data has error for user ${snapshot.error} ");
             return Container(
               child: Center(
                 child: Text('${snapshot.error} '),
               ),
             );
           }
           return Padding(
             padding:EdgeInsets.only(right:20.0),
             child: Container(
               //padding:EdgeInsets.only(right:20.0),
               height: newSize,
               width: newSize,
               child: Stack(
                 fit: StackFit.expand,
                 children: <Widget>[
                   Padding(
                     padding:EdgeInsets.only(top:5.0,right:20.0,bottom:20.0),
                     child: IconButton(
                         padding: EdgeInsets.all(0),
                         alignment: Alignment.center,
                         icon: Icon(
                           icon,
                           color: color,
                           size:newSize*0.75,
                         ),
                         onPressed: ()=>_openCart(context),),
                   ),
                   counter!=0?AlignPositioned(
                     alignment: Alignment.topRight,
                     //touch: Touch.inside,
                     child: Container(
                       height:newSize*0.4,
                       width:newSize*0.4,
                       padding: EdgeInsets.all(2),
                       decoration: new BoxDecoration(
                         color: Colors.red,
                         borderRadius: BorderRadius.circular(newSize*0.2),
                         border:Border.all(color:Colors.white,)
                       ),
                       constraints: BoxConstraints(
                         minWidth: 15,
                         minHeight: 15,
                       ),
                       child: Center(
                         child: Text(
                           '$counter',
                           style: TextStyle(
                             color: Colors.white,
                             fontSize: 10,
                           ),
                           textAlign: TextAlign.center,
                         ),
                       ),
                     ),
                   ):Container(),
                 ],
               ),
             ),
           );
         }
     );
  }
  void _openCart(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(
      builder:(context)=>CartPage(),
    fullscreenDialog: true),
    );
  }
}
