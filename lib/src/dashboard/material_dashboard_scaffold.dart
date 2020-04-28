import 'package:flutter/material.dart';
import 'tab_item.dart';

class MaterialDashboardScaffold extends StatefulWidget {
  const MaterialDashboardScaffold({this.currentTab,
    this.onSelectTab,
    this.widgetBuilders}) ;
  final TabItem currentTab;
  final ValueChanged<int> onSelectTab;
  final Map<TabItem,Widget> widgetBuilders;

  @override
  _MaterialDashboardScaffoldState createState() => _MaterialDashboardScaffoldState();
}

class _MaterialDashboardScaffoldState extends State<MaterialDashboardScaffold> with TickerProviderStateMixin<MaterialDashboardScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: TabItem.values.indexOf(widget.currentTab),
          children: TabItem.values.map<Widget>((TabItem tabItem) {
            return widget.widgetBuilders[tabItem];
          }).toList(),
        ),
      ),
      bottomNavigationBar: Container(
        height:60.0,
        width:MediaQuery.of(context).size.width,
        decoration:BoxDecoration(
          boxShadow: [BoxShadow( color:Colors.black54,blurRadius:10.0,spreadRadius: 3.0),]
        ),
        child: BottomNavigationBar(
          currentIndex: TabItem.values.indexOf(widget.currentTab),
          onTap: widget.onSelectTab,
          items: TabItem.values.map((TabItem tabItem) {
            return _buildItem(tabItem);
          }).toList(),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem ){
    final itemData=TabItemData.allTabs[tabItem];
    final color=widget.currentTab==tabItem? Colors.blueAccent:Colors.grey;
    return BottomNavigationBarItem(
      icon:Icon(itemData.icon,color: color,size:30.0,),
      title: Text(itemData.title,style:TextStyle(color:color,fontSize: 10.0),),
    );
  }
}
