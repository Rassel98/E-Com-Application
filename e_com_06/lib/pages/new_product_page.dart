import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_06/model/date_model.dart';
import 'package:e_com_06/model/product_model.dart';
import 'package:e_com_06/model/purches_model.dart';
import 'package:e_com_06/provider/product_provider.dart';
import 'package:e_com_06/utils/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewProductPage extends StatefulWidget {
  static const String routeName = '/new_product';

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final nameController = TextEditingController();
  final saleController = TextEditingController();
  final desController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final quantityController = TextEditingController();

  DateTime? _purchaseDate;
  String? _category;
  String? _imageUrl;
  ImageSource _imageSource = ImageSource.camera;
  bool isUpload = false;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    saleController.dispose();
    desController.dispose();
    purchasePriceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        actions: [
          IconButton(onPressed: _addProduct, icon: const Icon(Icons.save))
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Card(
                          child: _imageUrl == null
                              ? isUpload
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Image.asset(
                                      'images/gallery.png',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                              : FadeInImage.assetNetwork(
                                  fadeInDuration: const Duration(seconds: 1),
                                  placeholder: 'images/Loading.gif',
                                  image: _imageUrl!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              _imageSource = ImageSource.camera;
                              _getImage();
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.camera,
                                  color: Colors.purpleAccent,
                                ),
                                Text(
                                  'Camera',
                                  style: TextStyle(color: Colors.purpleAccent),
                                ),
                              ],
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        TextButton(
                            onPressed: () {
                              _imageSource = ImageSource.gallery;
                              _getImage();
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.photo, color: Colors.purpleAccent),
                                Text('Gallery',
                                    style:
                                        TextStyle(color: Colors.purpleAccent)),
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Product Name",
                  prefixIcon: Icon(Icons.production_quantity_limits),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                controller: desController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Product Description",
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: saleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Product Sale Price",
                  prefixIcon: Icon(Icons.monetization_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: purchasePriceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Purchase Price",
                  prefixIcon: Icon(Icons.monetization_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: quantityController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Quantity",
                  prefixIcon: Icon(Icons.do_not_disturb_on_total_silence),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<ProductProvider>(
                builder: (context, provider, _) => DropdownButtonFormField(
                  hint: const Text('Select Category'),
                  items: provider.categoryList
                      .map((model) => DropdownMenuItem<String>(
                          value: model.catName, child: Text(model.catName!)))
                      .toList(),
                  value: _category,
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: _selectedDate,
                        child: const Text('Select Purchase Date')),
                    Text(_purchaseDate == null
                        ? 'No Date Selected'
                        : getFormattedDateTime(_purchaseDate!, 'dd/MM/yyy')),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void _addProduct() async {
    if (_category == null) {
      showDisplayMessage(context, 'Please select category');
      return;
    }
    if (_purchaseDate == null) {
      showDisplayMessage(context, 'Please select purchase date');
      return;
    }
    if (formKey.currentState!.validate()) {
      EasyLoading.show(dismissOnTap: false, status: 'Please Wait..');
      final productModel = ProductModel(
          name: nameController.text,
          description: desController.text,
          category: _category,
          salePrice: num.parse(saleController.text),
          imageUrl: _imageUrl);
      final purchaseModel = PurchaseModel(
          dateModel: DateModel(
            timestamp: Timestamp.fromDate(_purchaseDate!),
            day: _purchaseDate!.day,
            month: _purchaseDate!.month,
            year: _purchaseDate!.year,
          ),
          purchasePrice: num.parse(purchasePriceController.text),
          quantity: num.parse(quantityController.text));
      final catModel =
          context.read<ProductProvider>().getCategoryByName(_category!);
      context
          .read<ProductProvider>()
          .addProduct(productModel, purchaseModel, catModel)
          .then((value) {
        EasyLoading.dismiss();
        setState(() {
          nameController.clear();
          desController.clear();
          purchasePriceController.clear();
          _purchaseDate = null;
          saleController.clear();
          quantityController.clear();
          _category = null;
          _imageUrl = null;
        });
      });
    }
  }

  void _selectedDate() async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      setState(() {
        _purchaseDate = selectedDate;
      });
    }
  }

  void _getImage() async {
    final selectedImage = await ImagePicker().pickImage(source: _imageSource);
    if (selectedImage != null) {
      isUpload = true;
      try {
        final url =
            await context.read<ProductProvider>().updateImage(selectedImage);
        setState(() {
          _imageUrl = url;
          isUpload = false;
        });
      } catch (e) {}
    }
  }
}
