import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/auth/auth_service.dart';
import 'package:e_com_user/model/address_model.dart';
import 'package:e_com_user/model/date_model.dart';
import 'package:e_com_user/model/order_model.dart';
import 'package:e_com_user/model/user_model.dart';
import 'package:e_com_user/pages/success_order_page.dart';
import 'package:e_com_user/pages/product_page.dart';
import 'package:e_com_user/pages/user_address_page.dart';
import 'package:e_com_user/provider/card_provider.dart';
import 'package:e_com_user/provider/order_provider.dart';
import 'package:e_com_user/provider/product_provider.dart';
import 'package:e_com_user/provider/user_provider.dart';
import 'package:e_com_user/utils/constrains.dart';
import 'package:e_com_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late CartProvider cartProvider;
  late OrderProvider orderProvider;
  late UserProvider userProvider;

  String paymentGroupValue = PaymentMethod.cod;
  @override
  void didChangeDependencies() {
    cartProvider = Provider.of<CartProvider>(context);
    orderProvider = Provider.of<OrderProvider>(context);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    orderProvider.getAllOrderConstant();
    //cartProvider.getCartByUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  'Product Info',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Card(
                  elevation: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: cartProvider.cardList
                        .map((cartM) => ListTile(
                              title: Text(cartM.productName!),
                              trailing: Text('${cartM.quantity} '
                                  'X $currencySymbols${cartM.salePrice} '),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Payment Info',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal '),
                          Text('$currencySymbols${cartProvider.getSubTotal()}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Charge '),
                          Text(
                              '$currencySymbols${orderProvider.orderConstantModel.deliveryCharge}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Discount(${orderProvider.orderConstantModel.discount.round()}%)'),
                          Text(
                              '-$currencySymbols${orderProvider.getDiscount(cartProvider.getSubTotal()).round()}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Vat(${orderProvider.orderConstantModel.vat}%)'),
                          Text(
                              '$currencySymbols${orderProvider.getVatAmount(cartProvider.getSubTotal())}'),
                        ],
                      ),
                      const Divider(
                        height: 1.5,
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            '$currencySymbols${orderProvider.getGrandTotalAmount(cartProvider.getSubTotal())}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Delivery Address',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: userProvider.getUserById(AuthService.user!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userM = UserModel.fromMap(snapshot.data!.data()!);
                      userProvider.userModel = userM;
                      return Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(userM.address == null
                                  ? 'No Address set yet'
                                  : '${userM.address!.streetAddress}\n '
                                      '${userM.address!.area},'
                                      '${userM.address!.city}\n'
                                      '${userM.address!.zipCode}\n'),
                              ElevatedButton(
                                  onPressed: () => Navigator.pushNamed(
                                      context, UserAddressPage.routeName),
                                  child: Text(userM.address == null
                                      ? 'Set Address'
                                      : 'Update Address'))
                            ],
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text('Can not fetch data');
                    }
                    return const Center(
                      child: Text('Please Wait..'),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Payment Info',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Radio<String>(
                        value: PaymentMethod.cod,
                        groupValue: paymentGroupValue,
                        onChanged: (value) {
                          paymentGroupValue = value!;
                        }),
                    const Text(PaymentMethod.cod),
                    const SizedBox(
                      height: 15,
                    ),
                    Radio<String>(
                        value: PaymentMethod.online,
                        groupValue: paymentGroupValue,
                        onChanged: (value) {
                          paymentGroupValue = value!;
                        }),
                    const Text(PaymentMethod.online)
                  ],
                )
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (userProvider.userModel?.address == null) {
                  showDisplayMessage(context, 'Please chose delivery address');
                  return;
                }
                EasyLoading.show(status: 'Please wait..', dismissOnTap: false);
                final orderModel = OrderModel(
                    userId: AuthService.user!.uid,
                    orderStatus: OrderStatus.pending,
                    paymentMethod: paymentGroupValue,
                    deliveryAddress: AddressModel(
                        streetAddress:
                            userProvider.userModel!.address!.streetAddress,
                        city: userProvider.userModel!.address!.city,
                        area: userProvider.userModel!.address!.area,
                        zipCode: userProvider.userModel!.address!.zipCode),
                    deliveryCharge:
                        orderProvider.orderConstantModel.deliveryCharge,
                    discount: orderProvider.orderConstantModel.discount
                        .roundToDouble(),
                    vat: orderProvider.orderConstantModel.vat,
                    grantTotal: orderProvider
                        .getGrandTotalAmount(cartProvider.getSubTotal()),
                    orderDate: DateModel(
                        timestamp: Timestamp.fromDate(DateTime.now()),
                        day: DateTime.now().day,
                        month: DateTime.now().month,
                        year: DateTime.now().year));
                orderProvider
                    .addOrder(orderModel, cartProvider.cardList)
                    .then((_) async {
                  await Provider.of<ProductProvider>(context, listen: false)
                      .updateCategoryProductCount(cartProvider.cardList);

                  await cartProvider.cleaAllCartItems();
                  EasyLoading.dismiss();
                  if (!mounted) {
                    return;
                  }
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      OrderSucessfullPage.routeName,
                      ModalRoute.withName(ProductPage.routeName));
                }).catchError((e) {
                  EasyLoading.dismiss();
                  showDisplayMessage(context, e);
                });
              },
              child: const Text('Order Place')),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
