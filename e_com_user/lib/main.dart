import 'package:e_com_user/pages/cart_page.dart';
import 'package:e_com_user/pages/checkout_page.dart';
import 'package:e_com_user/pages/login_page.dart';
import 'package:e_com_user/pages/my_profile_page.dart';
import 'package:e_com_user/pages/phone_varification_page.dart';
import 'package:e_com_user/pages/user_address_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'pages/launcher_page.dart';
import 'pages/my_order_page.dart';
import 'pages/success_order_page.dart';

import 'pages/product_details_page.dart';
import 'pages/product_page.dart';
import 'pages/registration_page.dart';
import 'provider/card_provider.dart';
import 'provider/order_provider.dart';
import 'provider/product_provider.dart';
import 'provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ProductProvider()),
    ChangeNotifierProvider(create: (context) => OrderProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => CartProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {

        ProductPage.routeName: (_) => const ProductPage(),
        LauncherPage.routeName: (_) => const LauncherPage(),
        ProductDetailsPage.routeName: (_) => ProductDetailsPage(),
        PhoneVerificationPage.routeName: (_) => const PhoneVerificationPage(),
        RegisterPage.routeName: (_) =>  const RegisterPage(),
        LoginPage.routeName: (_) =>  const LoginPage(),
        CartPage.routeName: (_) =>   const CartPage(),
        UserAddressPage.routeName: (_) =>   const UserAddressPage(),
        CheckoutPage.routeName: (_) =>   const CheckoutPage(),
        OrderSucessfullPage.routeName: (_) =>   const OrderSucessfullPage(),
        MyOrderPage.routeName: (_) => const  MyOrderPage(),
        ProfilePage.routeName: (_) => const  ProfilePage(),
      },
    );
  }
}
