import 'package:e_com_06/pages/dashboard_items_page.dart';
import 'package:e_com_06/pages/launcher_page.dart';
import 'package:e_com_06/pages/login_page.dart';
import 'package:e_com_06/pages/order_page.dart';
import 'package:e_com_06/pages/product_details_page.dart';
import 'package:e_com_06/pages/product_page.dart';
import 'package:e_com_06/pages/report_page.dart';
import 'package:e_com_06/pages/setting_page.dart';
import 'package:e_com_06/pages/user_page.dart';
import 'package:e_com_06/provider/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';


import 'pages/catagory_page.dart';
import 'pages/new_product_page.dart';
import 'provider/order_provider.dart';
import 'provider/product_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ProductProvider()),
    ChangeNotifierProvider(create: (context) =>OrderProvider()),
    ChangeNotifierProvider(create: (context) =>UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder:  EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        DashboardPage.routeName: (context) => const DashboardPage(),
        OrderPage.routeName: (_) => const OrderPage(),
        SettingPage.routeName: (_) => const SettingPage(),
        ReportPage.routeName: (_) => const ReportPage(),
        ProductPage.routeName: (_) => const ProductPage(),
        UserPage.routeName: (_) => const UserPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        CategoryPage.routeName: (_) => const CategoryPage(),
        LauncherPage.routeName: (_) => const LauncherPage(),
        NewProductPage.routeName: (_) => NewProductPage(),
        ProductDetailsPage.routeName: (_) => ProductDetailsPage(),
      },
    );
  }
}
