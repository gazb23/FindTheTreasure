import 'package:find_the_treasure/screens/account/account_page.dart';
import 'package:find_the_treasure/screens/home/CupertinoHomeScaffold.dart';
import 'package:find_the_treasure/screens/home/home_page_scaffold.dart';
import 'package:find_the_treasure/screens/home/tab_item.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.discover;

    Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      
      TabItem.discover : (_) => HomePageScaffold(),
      TabItem.news : (_) => Container(),
      TabItem.profile : (_) => AccountPage(),
    } ;
  }
   void _select(TabItem tabItem) {
    setState(() => _currentTab = tabItem);  
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
      currentTab: _currentTab,
      onSelectTab: _select,
      widgetBuilders: widgetBuilders,
    );
  }

 
}