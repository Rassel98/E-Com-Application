import 'package:e_com_user/auth/auth_service.dart';
import 'package:e_com_user/model/address_model.dart';
import 'package:e_com_user/provider/user_provider.dart';
import 'package:e_com_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class UserAddressPage extends StatefulWidget {
  static const String routeName='/user_address';
  const UserAddressPage({Key? key}) : super(key: key);

  @override
  State<UserAddressPage> createState() => _UserAddressPageState();
}

class _UserAddressPageState extends State<UserAddressPage> {
  final fromKey = GlobalKey<FormState>();
  final streetAddressController = TextEditingController();
  final zipCodeController = TextEditingController();
  String? city;
  String? area;
  late UserProvider userProvider;
  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context);
    userProvider.getAllCities();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    streetAddressController.dispose();
    zipCodeController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set User address'),
      ),
      body: Form(
        key: fromKey,
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            TextFormField(
              controller: streetAddressController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Street Address',
                  labelText: 'Street Address',
                  filled: true),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Your Street Address';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: zipCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ZipCode',
                  labelText: 'ZipCode',
                  filled: true),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Your Zip Code';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
                value: city,
                hint: const Text('Select City'),
                items: userProvider.cityList
                    .map((cityName) => DropdownMenuItem<String>(
                          value: cityName.name,
                          child: Text(cityName.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  city = value;
                }),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
                value: area,
                hint: const Text('Select Area'),
                items: userProvider.getCityNameByArea(city)
                    .map((area) => DropdownMenuItem<String>(
                          value: area,
                          child: Text(area),
                        ))
                    .toList(),
                onChanged: (value) {
                  area = value;
                }),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: ElevatedButton(onPressed: _update,
                  child:const Text('UPDATE')),
            )
          ],
        ),
      ),
    );
  }

  void _update() {
    if(fromKey.currentState!.validate()){
      if(city==null && area==null){
        showDisplayMessage(context, 'Please select your Area');
        return;
      }
      EasyLoading.show(status: 'Please wait..',dismissOnTap: false);
      final addressModel=AddressModel(
          streetAddress: streetAddressController.text,
          city: city!,
          area: area!,
          zipCode: zipCodeController.text);
      userProvider.updateProfile(AuthService.user!.uid, addressModel.toMap()).then((value){
        EasyLoading.dismiss();
        Navigator.pop(context);

      });



    }
  }
}
