import 'package:e_com_06/auth/auth_service.dart';
import 'package:e_com_06/model/dashboard_item_model.dart';
import 'package:e_com_06/pages/catagory_page.dart';
import 'package:e_com_06/pages/launcher_page.dart';
import 'package:e_com_06/pages/order_page.dart';
import 'package:e_com_06/pages/product_page.dart';
import 'package:e_com_06/pages/report_page.dart';
import 'package:e_com_06/pages/setting_page.dart';
import 'package:e_com_06/pages/user_page.dart';
import 'package:e_com_06/widgets/dashboard_item_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class DashboardPage extends StatelessWidget {
  static const String routeName = '/dashboard';
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(onPressed: () {

                AuthService.logout();
                Navigator.pushReplacementNamed(context, LauncherPage.routeName);
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
            itemCount: dashboardItems.length,
            itemBuilder: (context, index) => DashboardItemView(
                item: dashboardItems[index],
                onPressed: (value) {
                  navigate(context,value);
                  // final route=navigate( value);
                  // Navigator.pushNamed(context, route);
                })),
      ),
    );
  }

  void navigate(BuildContext context, String value) {//Return Sting
    //String route='';
    switch (value) {
      case DashboardItem.product:
        //route=ProductPage.routeName;
        Navigator.pushNamed(context, ProductPage.routeName);
        break;
      case DashboardItem.category:
  Navigator.pushNamed(context, CategoryPage.routeName);
        break;
      case DashboardItem.users:
  Navigator.pushNamed(context, UserPage.routeName);
        break;
      case DashboardItem.orders:
  Navigator.pushNamed(context, OrderPage.routeName);
        break;
      case DashboardItem.setting:
        Navigator.pushNamed(context, SettingPage.routeName);
        break;
      case DashboardItem.report:
      Navigator.pushNamed(context, ReportPage.routeName);
        break;
    }
    //return route;
  }
}
