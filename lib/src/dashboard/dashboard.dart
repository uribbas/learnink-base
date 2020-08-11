import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'material_dashboard_scaffold.dart';
import '../progress.dart';
import 'tab_item.dart';
import '../account.dart';
import '../bookshelves/bookshelves.dart';
import '../store/store.dart';
import '../chat.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 TabItem _currentTab=TabItem.bookshelves;

 Map<TabItem,Widget> get widgetBuilders{
   return {
     TabItem.bookshelves:Bookshelves(),
     TabItem.store:Store(),
     TabItem.progress:Progress(),
     TabItem.chat:Chat(),
     TabItem.account: Account(),

   };
 }
  @override
  Widget build(BuildContext context){
    return MaterialDashboardScaffold(
      currentTab:_currentTab,
      onSelectTab: (item){setState(() {
        _currentTab=TabItem.values[item];
      });
      },
      widgetBuilders: widgetBuilders,
    );
  }

}
