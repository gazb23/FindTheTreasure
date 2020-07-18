import 'package:find_the_treasure/presentation/explore/widgets/tab_item.dart';
import 'package:find_the_treasure/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  const CupertinoHomeScaffold(
      {Key key,
      @required this.currentTab,
      @required this.onSelectTab,
      @required this.widgetBuilders,
      @required this.navigatorKeys})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      
      tabBar: CupertinoTabBar(
        currentIndex: 2,
        backgroundColor: Colors.grey.shade800,
        items: [
          _buildItem(TabItem.profile),
          _buildItem(TabItem.myquests),
          _buildItem(TabItem.explore),
          _buildItem(TabItem.leaderboard),
          _buildItem(TabItem.shop),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetBuilders[item](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? MaterialTheme.orange : Colors.grey;
    final textColor = Colors.white;
    return BottomNavigationBarItem(      
      icon: Icon(
        itemData.icon,
        color: color,
      ),
      title: Text(
        itemData.title,
        style: TextStyle(color: textColor, fontFamily: 'quicksand', fontSize: 10.0, fontWeight: FontWeight.w600),
      ),
    );
  }
}
