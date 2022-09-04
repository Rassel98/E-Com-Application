import 'package:e_com_06/model/order_constant_model.dart';
import 'package:e_com_06/provider/order_provider.dart';
import 'package:e_com_06/utils/constrains.dart';
import 'package:e_com_06/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  static const String routeName = '/setting';
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late OrderProvider orderProvider;
  double deliveryChargeSliderValue = 0;
  double discountSliderValue = 0;
  double vatChargeSliderValue = 0;
  bool isChange=false;
  @override
  void didChangeDependencies() {
    orderProvider = Provider.of(context, listen: false);
    //orderProvider.getAllOrderConstant();
    orderProvider.getAllOrderConstant2().then((_) {
      setState(() {
        deliveryChargeSliderValue =
            orderProvider.orderConstantModel.deliveryCharge.toDouble();
        discountSliderValue =
            orderProvider.orderConstantModel.discount.toDouble();
        vatChargeSliderValue = orderProvider.orderConstantModel.vat.toDouble();
      });
    });
    // setState(() {
    //   deliveryChargeSliderValue =
    //       orderProvider.orderConstantModel.deliveryCharge.toDouble();
    //   discountSliderValue =
    //       orderProvider.orderConstantModel.discount.toDouble();
    //   vatChargeSliderValue = orderProvider.orderConstantModel.vat.toDouble();
    // });


    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Card(
            elevation: 10,
            child: Column(
              children: [
                ListTile(
                  title: const Text('Delivery Charge'),
                  trailing: Text('$currencySymbols${deliveryChargeSliderValue.round()}'),
                  subtitle: Slider(
                      min: 0,
                      max: 500,
                      divisions: 50,
                      inactiveColor: Colors.grey,
                      activeColor: Colors.blue,
                      label: deliveryChargeSliderValue.toStringAsFixed(0),
                      value: deliveryChargeSliderValue.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          deliveryChargeSliderValue = value;
                          _changeSlider();
                        });
                      }),
                ),
                ListTile(
                  title: const Text('Discount'),
                  trailing: Text('${discountSliderValue.round()}%'),
                  subtitle: Slider(
                      min: 0,
                      max: 100,
                      divisions: 100,
                      inactiveColor: Colors.grey,
                      activeColor: Colors.blue,
                      label: discountSliderValue.toStringAsFixed(0),
                      value: discountSliderValue.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          discountSliderValue = value;
                          _changeSlider();
                        });
                      }),
                ),
                ListTile(
                  title: const Text('Vat'),
                  trailing: Text('${vatChargeSliderValue.round()}%'),
                  subtitle: Slider(
                      min: 0,
                      max: 200,
                      divisions: 200,
                      inactiveColor: Colors.grey,
                      activeColor: Colors.blue,
                      label: vatChargeSliderValue.toStringAsFixed(0),
                      value: vatChargeSliderValue.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          vatChargeSliderValue = value;
                          _changeSlider();
                        });
                      }),
                ),
                ElevatedButton(
                    onPressed:!isChange?null: (){
                      EasyLoading.show(status: 'Uploading..',dismissOnTap: false);
                      final model=OrderConstantModel(
                        deliveryCharge: deliveryChargeSliderValue,
                        discount: discountSliderValue,
                        vat: vatChargeSliderValue
                      );
                      orderProvider.addOrderConstant(model).then((value){
                        EasyLoading.dismiss();
                        setState(() {
                          isChange=false;

                        });
                      }).catchError((onError){
                        showDisplayMessage(context, 'Can not updated');
                      });
                    },

                    child: const Text('Update')
                )

              ],
            ),
          )
        ],
      ),
    );
  }

  void _changeSlider() {
    isChange=deliveryChargeSliderValue !=
        orderProvider.orderConstantModel.deliveryCharge.toDouble()||
    discountSliderValue !=
        orderProvider.orderConstantModel.discount.toDouble()||
    vatChargeSliderValue != orderProvider.orderConstantModel.vat.toDouble();

  }
}
