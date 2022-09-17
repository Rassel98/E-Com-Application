import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_06/model/date_model.dart';
import 'package:e_com_06/model/purches_model.dart';
import 'package:e_com_06/provider/product_provider.dart';
import 'package:e_com_06/utils/constrains.dart';
import 'package:e_com_06/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../model/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/product_details';
  final ValueNotifier dateValueNotifier = ValueNotifier(DateTime.now());
  ProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String pid = ModalRoute.of(context)!.settings.arguments as String;
    final provider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          // elevation: 0,
          // backgroundColor: Colors.transparent,
          title: const Text(
            'Product Details',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: provider.getProductById(pid),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              final product = ProductModel.fromMap(snapshot.data!.data()!);
              provider.getAllPurchaseOfSpecifiqueProduct(pid);
              return ListView(
                //padding: EdgeInsets.symmetric(horizontal: 5),
                children: [
                  FadeInImage.assetNetwork(
                    fadeInDuration: const Duration(seconds: 1),
                    placeholder: 'images/Loading.gif',
                    image: product.imageUrl!,
                    height: 300,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            _showRePurchase(context, provider, product);
                          },
                          child: const Text('Re-purchase')),
                      TextButton(
                          onPressed: () {
                            _showPurchaseHistory(context, provider);
                          },
                          child: const Text('Purchase-History'))
                    ],
                  ),
                  ListTile(
                    title: Text(product.name!),
                    subtitle: Text('Stock: ${product.stock}'),
                    trailing: IconButton(
                      onPressed: () {
                        _updateDetails(context, provider, pid, false, 'name');
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    title: Text('$currencySymbols${product.salePrice}'),
                    trailing: IconButton(
                      onPressed: () {
                        _updateDetails(
                            context, provider, pid, true, 'salePrice');
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    title: Text(product.category!),
                    trailing: IconButton(
                      onPressed: () {
                        _updateDetails(
                            context, provider, pid, false, 'category');
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  ListTile(
                    title: Text(product.description!),
                    trailing: IconButton(
                      onPressed: () {
                        _updateDetails(
                            context, provider, pid, false, 'description');
                        // provider.updateProduct(pid, 'field', value)
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                  SwitchListTile(
                      title: const Text('Available'),
                      value: product.available,
                      onChanged: (value) {
                        provider.updateProduct(pid, 'available', value);
                      }),
                  SwitchListTile(
                      title: const Text('Featured'),
                      value: product.featured,
                      onChanged: (value) {
                        provider.updateProduct(pid, 'feature', value);
                      }),
                ],
              );
            }
            if (snapshot.hasError) {
              const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Text('No Data Fetch');
          },
        ));
  }

  void _updateDetails(BuildContext context, ProductProvider provider,
      String pid, bool isPrice, String field) {
    final txtController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (context) => ListView(
              padding: const EdgeInsets.all(15),
              children: [
                const ListTile(
                  title: Text(
                    'Update form',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: txtController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Fill the gape'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL')),
                    ElevatedButton(
                        onPressed: () {
                          if (txtController.text.isEmpty) {
                            showDisplayMessage(context, 'Enter update form');
                            return;
                          }
                          EasyLoading.show(
                              status: 'Please Wait', dismissOnTap: false);
                          provider
                              .updateProduct(
                                  pid,
                                  field,
                                  isPrice
                                      ? num.parse(txtController.text)
                                      : txtController.text)
                              .then((value) {
                            EasyLoading.dismiss();
                            txtController.clear();
                            Navigator.pop(context);
                          }).catchError((onError) {
                            showDisplayMessage(context, 'Data not Updating');
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('Update')),
                  ],
                )
              ],
            ));
  }

  void _showPurchaseHistory(BuildContext context, ProductProvider provider) {
    showModalBottomSheet(
        context: context,
        builder: (context) => ListView.builder(
              itemCount: provider.purchaseSpecifiqueOfProduct.length,
              itemBuilder: (context, index) {
                final purchase = provider.purchaseSpecifiqueOfProduct[index];
                return ListTile(
                  title: Text(getFormattedDateTime(
                      purchase.dateModel.timestamp.toDate(), 'dd/MM/yyy')),
                  subtitle: Text('Quantity : ${purchase.quantity}'),
                  trailing: Text('$currencySymbols${purchase.purchasePrice}'),
                );
              },
            ));
  }

  void _showRePurchase(
      BuildContext context, ProductProvider provider, ProductModel product) {
    final qController = TextEditingController();
    final priceController = TextEditingController();
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => ListView(
              children: [
                ListTile(
                  title: Text('Re-Purchase ${product.name}'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: qController,
                  decoration: const InputDecoration(
                      filled: true, labelText: 'Enter Quantity'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  decoration: const InputDecoration(
                      filled: true, labelText: 'Enter New Price/Price'),
                ),
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            _selectedDate(context);
                          },
                          child: const Text('Select Purchase Date')),
                      ValueListenableBuilder(
                        valueListenable: dateValueNotifier,
                        builder: (context, value, child) =>
                            Text(getFormattedDateTime(value, 'dd/MM/yyy')),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL')),
                    ElevatedButton(
                        onPressed: () {
                          if (qController.text.isEmpty) {
                            showDisplayMessage(
                                context, 'Please enter quantity');
                            return;
                          }
                          if (priceController.text.isEmpty) {
                            showDisplayMessage(context, 'Please enter price ');
                            return;
                          }
                          EasyLoading.show(
                              status: 'Please wait', dismissOnTap: false);
                          final model = PurchaseModel(
                              dateModel: DateModel(
                                timestamp:
                                    Timestamp.fromDate(dateValueNotifier.value),
                                day: dateValueNotifier.value.day,
                                month: dateValueNotifier.value.month,
                                year: dateValueNotifier.value.year,
                              ),
                              purchasePrice: num.parse(priceController.text),
                              quantity: num.parse(qController.text),
                              productId: product.id);
                          provider
                              .addPurchase(model, product.category!,product.stock)
                              .then((value) {
                            EasyLoading.dismiss();
                            qController.clear();
                            priceController.clear();
                            Navigator.pop(context);
                          }).catchError((onError) {
                            EasyLoading.dismiss();
                            Navigator.pop(context);
                            showDisplayMessage(context, 'Not inserted data');
                          });
                        },
                        child: const Text('Re-Purchase')),
                  ],
                )
              ],
            ));
  }

  void _selectedDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      dateValueNotifier.value = selectedDate;
    }
  }
}
