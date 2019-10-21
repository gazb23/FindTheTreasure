import 'package:find_the_treasure/presentation/account/screens/account_screen.dart';
import 'package:find_the_treasure/presentation/home/widgets/CupertinoHomeScaffold.dart';
import 'package:find_the_treasure/presentation/home/screens/home_page_screen.dart';
import 'package:find_the_treasure/presentation/home/widgets/tab_item.dart';
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