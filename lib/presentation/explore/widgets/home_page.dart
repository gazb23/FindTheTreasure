import 'package:find_the_treasure/presentation/my_quests/screens/my_quests_screen.dart';
import 'package:find_the_treasure/presentation/Leaderboard/screens/leaderboard_screen.dart';
import 'package:find_the_treasure/presentation/explore/screens/explore_screen.dart';
import 'package:find_the_treasure/presentation/Shop/screens/shop_screen.dart';
import 'package:find_the_treasure/presentation/profile/screens/profile_screen.dart';
import 'package:find_the_treasure/presentation/explore/widgets/CupertinoHomeScaffold.dart';
import 'package:find_the_treasure/presentation/explore/widgets/tab_item.dart';
import 'package:find_the_treasure/services/connectivity_service.dart';

import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  TabItem _currentTab = TabItem.explore;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.profile: GlobalKey<NavigatorState>(),
    TabItem.myquests: GlobalKey<NavigatorState>(),
    TabItem.explore: GlobalKey<NavigatorState>(),
    TabItem.leaderboard: GlobalKey<NavigatorState>(),
    TabItem.shop: GlobalKey<NavigatorState>(),
  };

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
   ConnectivityService.checkNetwork(context);
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
          child: CupertinoHomeScaffold(      
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }



}