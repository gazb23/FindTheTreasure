import 'package:flutter/material.dart';


enum TabItem {tours, news, profile,}

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    
    TabItem.tours: TabItemData(title: 'Discover', icon: Icons.public),
    TabItem.news: TabItemData(title: 'News', icon: Icons.new_releases),
    TabItem.profile: TabItemData(title: 'Profile', icon: Icons.person),
    
  };
}