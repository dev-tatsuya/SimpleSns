import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum TabItem { jobs, entries, add, account }

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(title: 'Jobs', icon: Icons.work),
    TabItem.entries: TabItemData(title: 'Entries', icon: Icons.view_headline),
    TabItem.add: TabItemData(title: 'Add', icon: Icons.add_box),
    TabItem.account: TabItemData(title: 'Account', icon: Icons.person),
  };
}