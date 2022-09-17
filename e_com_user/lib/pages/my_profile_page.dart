import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/pages/user_address_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../model/user_model.dart';
import '../provider/user_provider.dart';
import '../widgets/main_drawer.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/user_profile';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final txtController = TextEditingController();
  @override
  void dispose() {
    txtController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  //late ImageSource imageSource;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        actions: [
          IconButton(
              onPressed: () {
                AuthService.logout();
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      drawer: const MainDrawer(),
      body: Center(
        child: Consumer<UserProvider>(
          builder: (context, provider, _) =>
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: provider.getUserById(AuthService.user!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userModel =
                          UserModel.fromMap(snapshot.data!.data()!);
                      return ListView(
                        children: [
                          Center(
                              child: userModel.image == null
                                  ? Image.asset(
                                      'images/gallery.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      userModel.image!,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )),
                          ElevatedButton.icon(
                              onPressed: _getImage,
                              icon: const Icon(Icons.edit),
                              label: const Text('Upload Image')),
                          const Divider(
                            color: Colors.red,
                            height: 1,
                          ),
                          ListTile(
                            title: Text(userModel.name ?? 'No display name'),
                            trailing: IconButton(
                              onPressed: () {
                                showInputDialog(
                                    title: 'Display Name',
                                    value: userModel.name,
                                    onSaved: (value) async {
                                      provider.updateProfile(
                                          AuthService.user!.uid,
                                          {'name': value});

                                      //await AuthService.updateDisplayName(value);
                                    });
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ),
                          ListTile(
                            title: Text(
                                userModel.mobile ?? 'No display mobile number'),
                            trailing: IconButton(
                              onPressed: () {
                                showInputDialog(
                                    title: 'Mobile Number ',
                                    value: userModel.mobile,
                                    onSaved: (value) {
                                      provider.updateProfile(
                                          AuthService.user!.uid,
                                          {'mobile': value});
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ),
                          ListTile(
                            title: Text(userModel.email),
                            trailing: IconButton(
                              onPressed: () {
                                showInputDialog(
                                    title: 'Email',
                                    value: userModel.email,
                                    onSaved: (value) async {
                                      // await AuthService.updateEmail(value);
                                      // await provider.updateProfile(AuthService.user!.uid,
                                      //     {'name' : value});
                                    });
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ),

                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(userModel.address == null
                                      ? 'No Address set yet'
                                      : '${userModel.address!.streetAddress},\n '
                                      '${userModel.address!.area},'
                                      '${userModel.address!.city}\n'
                                      '${userModel.address!.zipCode}\n'),
                                  ElevatedButton(clipBehavior: Clip.antiAlias,
                                      style: const ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll<Color>(Colors.purpleAccent)
                                      ),
                                      onPressed: () => Navigator.pushNamed(
                                          context, UserAddressPage.routeName),
                                      child: Text(userModel.address == null
                                          ? 'Set Address'
                                          : 'Update Address'))
                                ],
                              ),
                            ),

                        ],
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text('no data get');
                    }
                    return const CircularProgressIndicator();
                  }),
        ),
      ),
    );
  }

  void _getImage()async {
    final xFile=await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 75);
    if(xFile!=null){
      // final  downloadUrl= await Provider.
      // of<UserProvider>(context,listen: false).
      // updateImage(File(xFile.path));
      final s=await Provider.of<UserProvider>(context,listen: false).updateImage(xFile);

      await Provider.
      of<UserProvider>(context,listen: false).updateProfile(AuthService.user!.uid,
          {'image' : s});
      await AuthService.updatePhotoUrl(s);
    }


  }

  showInputDialog(
      {required String title,
      String? value,
      required Function(String) onSaved}) {
    txtController.text = value ?? '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: txtController,
                  decoration: InputDecoration(hintText: 'Enter $title'),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL')),
                TextButton(
                    onPressed: () {
                      onSaved(txtController.text);
                      Navigator.pop(context);
                    },
                    child: const Text('UPDATE')),
              ],
            ));
  }
}
