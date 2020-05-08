import 'dart:async';
import 'package:flutter/material.dart';
import 'package:learnink/src/models/cart.dart';
import 'package:learnink/src/models/subject.dart';
import 'package:learnink/src/services/database.dart';
import 'package:learnink/src/store/cart_page_list_item.dart';
import 'package:learnink/src/store/cart_page_list_model.dart';
import 'package:learnink/src/widgets/custom_outline_button.dart';
import 'package:learnink/src/widgets/learnink_empty_content.dart';
import 'package:learnink/src/widgets/learnink_loading_indicator.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    initCartStream();

  }

  @override
  void dispose() {
    _cartListStream.cancel();
    super.dispose();
  }


  Future<void> initCartStream() async {
  await Future.delayed(Duration.zero,(){_database=Provider.of<Database>(context,listen:false);});
  _cartListStream=_database.userCartStream().listen((data) {
      print('Inside userCartStreamListener, ${data}');
      _cart=data;
      _list= CartPageListModel<Subject>(
        listKey: _listKey,
        initialItems: _cart.items,
        removedItemBuilder: _buildRemovedItem,
      );
      if(mounted){
        print('Inside userCartStreamListener, ${_cart.total}');
        setState(() {});
      }
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
          if(mounted){ setState((){});}
        }

    );
  }

  @override
  Widget build(BuildContext context) {
    print('Inside build _totalAmount ...');
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
        key:_scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text('Cart'),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop()),

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
                    _list!=null ? SliverAnimatedList(
                      key: _listKey,
                      initialItemCount: _list.length,
                      itemBuilder: _buildItem,
                    )
                    :
                    SliverFixedExtentList(
                      itemExtent: 200.0,
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return  Center(child: LearninkLoadingIndicator(
                            color:Color(0xff004fe0),
                          ),);
                        },
                        childCount: 1,
                      ),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 45.0,
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if(_cart!=null){
                                _cart.items.forEach((s)=>_totalAmount = _totalAmount + s.price['inr']);
                              }
                          return Center(
                            child: Padding(
                              padding:EdgeInsets.all(10),
                              child: _totalAmount > 0
                                  ?Text( 'Total Cart Value   \u{20B9}  ${_totalAmount}',
                                  style:TextStyle(color:Colors.green,fontSize: 20.0,),)
                              : Container(),

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
                          child: _cart != null && _cart.items.length > 0 ? CustomOutlineButton(
                            child: Text('Check Out',
                              style:TextStyle(color:Colors.black),
                            ),
                            borderColor: Colors.black,
                            elevationColor: Colors.black,
                            onPressed: (){},
                          ) :LearninkEmptyContent(primaryText: 'No item in your cart',
                              primaryTextColor: Colors.green,
                              imageUrl: 'assets/icons/evs.png'),
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

