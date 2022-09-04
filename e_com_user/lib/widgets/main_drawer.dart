
import 'package:e_com_user/pages/cart_page.dart';
import 'package:e_com_user/pages/my_order_page.dart';
import 'package:flutter/material.dart';


import '../auth/auth_service.dart';
import '../pages/login_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Consumer<UserProvider>(
          //   builder:(context,provider,_) {
          //   // final userModel= provider.getUserById(AuthService.user!.uid);
          //
          //     return    UserAccountsDrawerHeader(
          //           accountName: Text(AuthService.user!.displayName == null
          //               ? 'No Display name'
          //               : AuthService.user!.displayName!),
          //           accountEmail: Text(AuthService.user!.email!),
          //           //currentAccountPicture: Image.network(AuthService.user!.photoURL),
          //         );
          //
          //   }
          // ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            onTap: () {},
               // Navigator.pushReplacementNamed(context, ProfilePage.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Cart'),
            onTap: () {
              Navigator.pushNamed(context, CartPage.routeName);
            },
          ),


          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Order'),
            onTap: () {
              Navigator.pushNamed(context, MyOrderPage.routeName);
            },
          ),
          ListTile(
            leading:const Icon(Icons.logout),
            title: const Text('LogOut '),
            onTap: ()async {
              AuthService.logout();
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            }
          ),
        ],
      ),
    );
  }
}
