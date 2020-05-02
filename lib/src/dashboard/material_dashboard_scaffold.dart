import 'package:flutter/material.dart';
import '../widgets/tab_navigator.dart';
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
  Map<TabItem,GlobalKey<NavigatorState>> navigatorkeys={
     TabItem.bookshelves:GlobalKey<NavigatorState>(),
     TabItem.store:GlobalKey<NavigatorState>(),
     TabItem.account:GlobalKey<NavigatorState>(),
     TabItem.progress:GlobalKey<NavigatorState>(),
     TabItem.chat:GlobalKey<NavigatorState>(),
   };
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async =>
      !await navigatorkeys[widget.currentTab].currentState.maybePop(),
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Stack(
            children: TabItem.values.map<Widget>((TabItem tabItem) {
              return _buildOffstageNavigator(tabItem);
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

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: widget.currentTab != tabItem,
      child: TabNavigator(
        key:navigatorkeys[tabItem],
        tab:tabItem,
        initialRoute: '/',
        onGenerateRoute: (_) => MaterialPageRoute<dynamic>(
             builder: (_) => widget.widgetBuilders[tabItem],
        ),
      ),
    );
  }
}
