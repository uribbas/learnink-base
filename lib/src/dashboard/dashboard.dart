import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../bookshelves.dart';
import 'package:provider/provider.dart';
import '../account.dart';
import '../cart.dart';
import '../chat.dart';
import '../login/auth.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key key, this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context){
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart),
            ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.conversation_bubble),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: BookShelves(),
              );
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Account(),
              );
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Cart(),
              );
            });
          case 3:
            return CupertinoTabView(builder:(context){
              return CupertinoPageScaffold(
                child: Chat(),
              );
            });
        }
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
