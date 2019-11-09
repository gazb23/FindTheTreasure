import 'package:find_the_treasure/presentation/explore/widgets/tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold(
      {Key key,
      @required this.currentTab,
      @required this.onSelectTab,
      this.widgetBuilders})
      : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.white,
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
          builder: (context) => widgetBuilders[item](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? Colors.orangeAccent : Colors.black38;
    return BottomNavigationBarItem(
      
      icon: Icon(
        itemData.icon,
        color: color,
      ),
      title: Text(
        itemData.title,
        style: TextStyle(color: color, fontFamily: 'quicksand', fontSize: 13.0, fontWeight: FontWeight.w600),
      ),
    );
  }
}
