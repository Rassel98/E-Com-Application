import 'package:flutter/material.dart';

class DashboardItem{
  IconData icon;
  String title;

  DashboardItem({required this.icon, required this.title});

  static const String product = 'Product';
  static const String category = 'Category';
  static const String orders = 'Orders';
  static const String users = 'Users';
  static const String setting = 'Setting';
  static const String report = 'Report';
}
// final List<DashboardItem>das=[
//   DashboardItem(icon: Icons.ac_unit, title: DashboardItem.product)
// ];

final List<DashboardItem> dashboardItems = [
  DashboardItem(icon: Icons.card_giftcard, title: DashboardItem.product),
  DashboardItem(icon: Icons.category, title: DashboardItem.category),
  DashboardItem(icon: Icons.monetization_on, title: DashboardItem.orders),
  DashboardItem(icon: Icons.person, title: DashboardItem.users),
  DashboardItem(icon: Icons.settings, title: DashboardItem.setting),
  DashboardItem(icon: Icons.area_chart, title: DashboardItem.report),
];