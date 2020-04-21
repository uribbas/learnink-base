import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem {bookshelves,account,cart,chat}

class TabItemData{
  const TabItemData({@ required this.icon});
  final IconData icon;

  static const Map<TabItem,TabItemData> allTabs= {
    TabItem.bookshelves:TabItemData(icon:CupertinoIcons.home),
    TabItem.account:TabItemData(icon:CupertinoIcons.profile_circled),
    TabItem.cart:TabItemData(icon:CupertinoIcons.shopping_cart),
    TabItem.chat:TabItemData(icon:CupertinoIcons.conversation_bubble),
   };
}

