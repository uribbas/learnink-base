import 'package:flutter/material.dart';
import '../widgets/my_flutter_icons.dart';

enum TabItem {bookshelves,store,progress,chat,account}

class TabItemData{
  const TabItemData({@ required this.icon,@required this.title});
  final IconData icon;
  final String title;

  static const Map<TabItem,TabItemData> allTabs= {
    TabItem.bookshelves:TabItemData(icon:MyFlutterIcons.bookshelves,title:'Bookshelves',),
    TabItem.account:TabItemData(icon:MyFlutterIcons.profile,title:'Account',),
    TabItem.store:TabItemData(icon:MyFlutterIcons.shopping_cart,title:'Store',),
    TabItem.chat:TabItemData(icon:MyFlutterIcons.dialog_bubble,title:'Chat',),
    TabItem.progress:TabItemData(icon:MyFlutterIcons.chart,title:'Progress',),
   };
}

