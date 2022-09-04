import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/model/user_model.dart';
import 'package:e_com_user/pages/phone_varification_page.dart';

import 'package:e_com_user/provider/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import 'launcher_page.dart';

class RegisterPage extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  bool isLogin = true, isObscureText = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';
  @override
  void didChangeDependencies() {
    phoneController.text=ModalRoute.of(context)!.settings.arguments as String;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xfff637ec),
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              TextFormField(

                textInputAction: TextInputAction.next,
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Enter Full Name',
                    prefixIcon: Icon(Icons.person),
                    fillColor: Colors.white,
                    filled: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    fillColor: Colors.white,
                    filled: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                enabled: false,
                textInputAction: TextInputAction.next,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile',
                    hintText: 'Enter Mobile Number',
                    prefixIcon: Icon(Icons.phone),
                    fillColor: Colors.white,
                    filled: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: isObscureText,
                textInputAction: TextInputAction.done,
                controller: passController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                  hintText: 'Password',
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(isObscureText
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => setState(() {
                      isObscureText = !isObscureText;
                    }),
                  ),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffA66CFF),
                  ),
                  onPressed: () {
                    isLogin = true;
                    authenticate();
                  },
                  child: const Text('REGISTER'),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              Text(
                errMsg,
                style: TextStyle(color: Theme.of(context).errorColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  authenticate() async {
    if (formKey.currentState!.validate()) {
      try {
        final status =
            await AuthService.register(emailController.text, passController.text);
        if (status) {
          if(!mounted){
            return;
          }
          EasyLoading.show(status: 'Please Wait',dismissOnTap: false);
          final userModel=UserModel(
              uid: AuthService.user!.uid,
              name: nameController.text,
              email: AuthService.user!.email!,
              mobile: phoneController.text,
              userCreationTime: Timestamp.fromDate(AuthService.user!.metadata.creationTime!)
          );
          Provider.of<UserProvider>(context,listen: false).addUser(userModel)
              .then((value) {
                EasyLoading.dismiss();
                Navigator.pushNamedAndRemoveUntil(context, LauncherPage.routeName, (route) => false);
          });
        } else {
          AuthService.logout();
          setState(() {
            errMsg = 'You are not an Admin';
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }
}
