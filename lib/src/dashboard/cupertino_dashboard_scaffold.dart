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
          _buildItem(TabItem.bookshelves, 'Bookshelves'),
          _buildItem(TabItem.cart, 'Store'),
          _buildItem(TabItem.progress,'Progress'),
          _buildItem(TabItem.chat,'Discuss'),
          _buildItem(TabItem.account,'My Account'),
        ],
        //border:Border(top:BorderSide(color:Colors.black,width:2.0,),),
        onTap: (index)=>onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item=TabItem.values[index];
            return CupertinoTabView(builder: (context) =>widgetBuilders[item](context));
            },
            );

  }
  BottomNavigationBarItem _buildItem(TabItem tabItem, String title ){
    final itemData=TabItemData.allTabs[tabItem];
    final color=currentTab==tabItem? Colors.blueAccent:Colors.grey;
    return BottomNavigationBarItem(
      icon:Icon(itemData.icon,color: color,size:30.0,),
      title: Text(title),
     );
  }
}
