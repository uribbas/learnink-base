import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learnink/src/models/cart.dart';
import 'package:learnink/src/models/subject.dart';
import 'package:learnink/src/services/database.dart';
import 'package:learnink/src/store/cart_page_list_item.dart';
import 'package:learnink/src/store/cart_page_list_model.dart';
import 'package:learnink/src/widgets/custom_outline_button.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Cart _cart;
  StreamSubscription _cartListStream;
  Database _database;
  CartPageListModel<Subject> _list;
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();

  @override
  void initState(){
    super.initState();
    initCartStream();

  }

  Future<void> initCartStream() async {
  await Future.delayed(Duration.zero,(){_database=Provider.of<Database>(context,listen:false);});
  _cartListStream=_database.userCartStream().listen((data){
    print('Inside userCartStreamListener, ${data}');
    _cart=data;
    print('Inside userCartStreamListener, ${_cart.total}');
    setState(() {
      _list= CartPageListModel<Subject>(
        listKey: _listKey,
        initialItems: _cart.items,
        removedItemBuilder: _buildRemovedItem,
      );
    });

  });

  print('Inside intiCartStream ${_list==null}');
}

  Widget _buildRemovedItem(Subject item, BuildContext context, Animation<double> animation) {
    return CartPageListItem(
      subject:item,
      isFirst: false,
      isLast:false,
      animation: animation,
     );
  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return CartPageListItem(
        subject: _list[index],
        animation: animation,
        isFirst: index == 0,
        isLast: index == _list.length,
        remove: () {
          _list.removeAt(index);
          setState((){});
        }

    );
  }

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
            child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAnimatedList(
                      key: _listKey,
                      initialItemCount: _list.length,
                      itemBuilder: _buildItem,
                    ),

//                  SliverFixedExtentList(
//                      itemExtent: 120.0,
//                      delegate: SliverChildBuilderDelegate(
//                            (BuildContext context, int index) {
//                          return Padding(
//                            padding:EdgeInsets.all(0),
//                            child: CartPageListItem(subject: _list[index],
//                              isFirst: index==0,
//                              isLast: index==_list.length-1,),
//                          );
//                        },
//                        childCount: _list.length,
//                      ),
//                    ),
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
                ),
    ),
    ),
    ],
    );

  }
}

