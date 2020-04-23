import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/my_flutter_icons.dart';

enum TabItem {bookshelves,cart,progress,chat,account}

class TabItemData{
  const TabItemData({@ required this.icon});
  final IconData icon;

  static const Map<TabItem,TabItemData> allTabs= {
    TabItem.bookshelves:TabItemData(icon:MyFlutterIcons.bookshelves),
    TabItem.account:TabItemData(icon:MyFlutterIcons.profile),
    TabItem.cart:TabItemData(icon:MyFlutterIcons.shopping_cart),
    TabItem.chat:TabItemData(icon:MyFlutterIcons.dialog_bubble),
    TabItem.progress:TabItemData(icon:MyFlutterIcons.chart),
   };
}

