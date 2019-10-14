import 'package:find_the_treasure/screens/home/tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({Key key, @required this.currentTab, @required this.onSelectTab, this.widgetBuilders}) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;



  

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [          
          _buildItem(TabItem.discover),
          _buildItem(TabItem.news),
          _buildItem(TabItem.profile),
          
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
    final color = currentTab == tabItem ? Colors.redAccent : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(itemData.icon, color: color,),
      title: Text(itemData.title, style: TextStyle(color: color),),
      
    );
  }
}