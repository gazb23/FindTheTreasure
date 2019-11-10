import 'package:find_the_treasure/presentation/my_quests/screens/my_quests_screen.dart';
import 'package:find_the_treasure/presentation/Leaderboard/screens/leaderboard_screen.dart';
import 'package:find_the_treasure/presentation/explore/screens/explore_screen.dart';
import 'package:find_the_treasure/presentation/Shop/screens/shop_screen.dart';
import 'package:find_the_treasure/presentation/profile/screens/profile_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/CupertinoHomeScaffold.dart';
import 'package:find_the_treasure/presentation/explore/widgets/tab_item.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.explore;

    Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.profile : (_) => ProfileScreen(),
      TabItem.myquests: (_) => MyQuestsScreen(), 
      TabItem.explore : (_) => ExploreScreen(),       
      TabItem.leaderboard : (_) => LeaderboardScreen(),
      TabItem.shop : (_) => ShopScreen(),
      
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