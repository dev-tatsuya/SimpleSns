import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum TabItem { home, search, add, account }

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.home: TabItemData(title: 'Home', icon: Icons.home),
    TabItem.search: TabItemData(title: 'Search', icon: Icons.search),
    TabItem.add: TabItemData(title: 'Add', icon: Icons.add_box),
    TabItem.account: TabItemData(title: 'Account', icon: Icons.person),
  };
}