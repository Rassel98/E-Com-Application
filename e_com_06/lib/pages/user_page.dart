import 'package:e_com_06/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  static const String routeName='/user';
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      body:Consumer<UserProvider>(
        builder: (context, provider, child) =>ListView.builder(
          itemCount: provider.userList.length,
          itemBuilder: (context, index) {
            final user=provider.userList[index];
            return ListTile(
              title: Text(user.name!=null?'${user.name}'
                  : user.email),
              subtitle: Text(user.mobile!=null?'Phone : ${user.mobile}'
                  : 'No valid phone number'),
            );
          }
        )
      ) ,
    );
  }
}
