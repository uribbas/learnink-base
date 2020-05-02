import 'package:flutter/material.dart';
import '../dashboard/tab_item.dart';

class TabNavigator extends Navigator {
  const TabNavigator(
      {Key key,
        @required this.tab,
        String initialRoute,
        @required RouteFactory onGenerateRoute,
        RouteFactory onUnknownRoute,
        List<NavigatorObserver> observers = const <NavigatorObserver>[]})
      : assert(onGenerateRoute != null),
        assert(tab != null),
        super(
        key: key,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: onUnknownRoute,
        observers: observers,
      );

  // when id is null, the `of` function returns top most navigator
  final TabItem tab;

  static NavigatorState of(BuildContext context, {TabItem tab, ValueKey<String> key}) {
    final NavigatorState state = Navigator.of(context,rootNavigator: tab == null,);
    if (state.widget is TabNavigator) {
      // ignore: avoid_as
      if ((state.widget as TabNavigator).tab == tab) {
        return state;
      }
      else {
        return of(state.context, tab: tab);
      }
    }
    return state;
  }
}