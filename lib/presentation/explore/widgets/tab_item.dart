import 'package:flutter/material.dart';




enum TabItem {profile, myquests, explore, leaderboard, shop}

class TabItemData {
  final String title;
  final IconData icon;

  const TabItemData({@required this.title, @required this.icon});

  static const Map<TabItem, TabItemData> allTabs = {
    
    TabItem.profile: TabItemData(title: 'Profile', icon: Icons.person),
    TabItem.myquests: TabItemData(title: 'Quests', icon: Icons.terrain),
    TabItem.explore: TabItemData(title: 'Explore', icon: Icons.public),
    TabItem.leaderboard: TabItemData(title: 'Leaderboard', icon: Icons.equalizer),
    TabItem.shop: TabItemData(title: 'Shop', icon: Icons.store),
    
  };
}