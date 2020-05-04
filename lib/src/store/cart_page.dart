import 'package:flutter/material.dart';
import 'package:learnink/src/models/subject.dart';
import 'package:learnink/src/services/database.dart';
import 'package:learnink/src/store/cart_page_list_item.dart';
import 'package:learnink/src/widgets/custom_outline_button.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Database database=Provider.of<Database>(context);
    double _totalAmount = 0.00;
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
          title: Text('Cart'),

        ),
        backgroundColor: Colors.transparent,
        body: Container(
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
            child: StreamBuilder(
              stream:database.userCartStream(),
              builder:(context,snapshot){
                List<Subject> cartList=[];
                _totalAmount = 0.00;
                if(snapshot.hasData) {
                  print('snapshot value ${snapshot.data}');
                  if (snapshot.data != null) {
                    cartList=snapshot.data.items;
                    cartList.forEach((s)=>_totalAmount = _totalAmount + s.price['inr']);
                  }
                }

                if(snapshot.hasError){
                  cartList=[];
                }
                return CustomScrollView(
                  slivers: <Widget>[

                    SliverFixedExtentList(
                      itemExtent: 120.0,
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Padding(
                                padding:EdgeInsets.all(0),
                                child: CartPageListItem(subject: cartList[index],
                                  isFirst: index==0,
                                  isLast: index==cartList.length-1,),
                              );
                        },
                        childCount: cartList.length,
                      ),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 45.0,
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Center(
                            child: Padding(
                              padding:EdgeInsets.all(10),
                              child: Text( _totalAmount > 0 ? 'Total Cart Value   \u{20B9}  ${_totalAmount}' : 'No items in the cart',
                                style:TextStyle(color:Colors.green,fontSize: 20.0,),
                              ),
                            ),
                          );
                        },
                        childCount: 1,
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      // fillOverscroll: true, // Set true to change overscroll behavior. Purely preference.
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: _totalAmount > 0 ? CustomOutlineButton(
                            child: Text('Check Out',
                              style:TextStyle(color:Colors.black),
                            ),
                            borderColor: Colors.black,
                            elevationColor: Colors.black,
                            onPressed: (){},
                          ) : Container(),
                        ),
                      ),
                    )
                  ],
                );
              },
            )
        ),
      ),
    ]);

  }
  }

