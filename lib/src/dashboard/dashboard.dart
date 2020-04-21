import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learnink/src/dashboard/cupertino_dashboard_scaffold.dart';
import 'package:learnink/src/dashboard/tab_item.dart';
import '../account.dart';
import '../bookshelves.dart';
import '../cart.dart';
import '../chat.dart';
import '../login/auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key, this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 TabItem _currentTab=TabItem.bookshelves;

 Map<TabItem,WidgetBuilder> get widgetBuilders{
   return {
     TabItem.bookshelves:(_)=>CupertinoPageScaffold(child:BookShelves(),),
     TabItem.account:(_)=>CupertinoPageScaffold(child: Account(),),
     TabItem.chat:(_)=>CupertinoPageScaffold(child: Chat(),),
     TabItem.cart:(_)=>CupertinoPageScaffold(child:Cart(),),
   };
 }
  @override
  Widget build(BuildContext context){
    return CupertinoDashboardScaffold(
      currentTab:_currentTab,
      onSelectTab: (item){setState(() {
        _currentTab=item;
      });
      },
      widgetBuilders: widgetBuilders,
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await widget.auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
