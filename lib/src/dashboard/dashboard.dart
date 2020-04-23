import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../progress.dart';
import 'cupertino_dashboard_scaffold.dart';
import 'tab_item.dart';
import '../account.dart';
import '../bookshelves.dart';
import '../cart.dart';
import '../chat.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 TabItem _currentTab=TabItem.bookshelves;

 Map<TabItem,WidgetBuilder> get widgetBuilders{
   return {
     TabItem.bookshelves:(_)=>CupertinoPageScaffold(child:BookShelves(),),
     TabItem.cart:(_)=>CupertinoPageScaffold(child:Cart(),),
     TabItem.progress:(_)=>CupertinoPageScaffold(child:Progress(),),
     TabItem.chat:(_)=>CupertinoPageScaffold(child: Chat(),),
     TabItem.account:(_)=> CupertinoPageScaffold(child: Account(),),

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
