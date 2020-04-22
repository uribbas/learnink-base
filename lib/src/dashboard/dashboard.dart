import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cupertino_dashboard_scaffold.dart';
import 'tab_item.dart';
import 'package:provider/provider.dart';
import '../account.dart';
import '../bookshelves.dart';
import '../cart.dart';
import '../chat.dart';
import '../login/auth.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 TabItem _currentTab=TabItem.bookshelves;

 Map<TabItem,WidgetBuilder> get widgetBuilders{
   return {
     TabItem.bookshelves:(_)=>CupertinoPageScaffold(child:BookShelves(),),
     TabItem.account:(context){
       AuthBase auth=Provider.of<AuthBase>(context);
        return CupertinoPageScaffold(child: Account(auth:auth),);},
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

}
