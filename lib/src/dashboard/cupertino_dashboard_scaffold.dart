import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'tab_item.dart';

class CupertinoDashboardScaffold extends StatelessWidget {
  const CupertinoDashboardScaffold({
    Key key,
    this.currentTab,
    this.onSelectTab,
    this.widgetBuilders,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem,WidgetBuilder> widgetBuilders;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          _buildItem(TabItem.bookshelves),
          _buildItem(TabItem.account),
          _buildItem(TabItem.cart),
          _buildItem(TabItem.chat),
        ],

        onTap: (index)=>onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item=TabItem.values[index];
            return CupertinoTabView(builder: (context) =>widgetBuilders[item](context));
            },
            );

  }
  BottomNavigationBarItem _buildItem(TabItem tabItem){
    final itemData=TabItemData.allTabs[tabItem];
    final color=currentTab==tabItem? Colors.black:Colors.grey;
    return BottomNavigationBarItem(
      icon:Icon(itemData.icon,color: color,),
     );
  }
}
