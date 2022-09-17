import 'package:e_com_06/pages/new_product_page.dart';
import 'package:e_com_06/pages/product_details_page.dart';
import 'package:e_com_06/utils/constrains.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class ProductPage extends StatelessWidget {
  static const String routeName = '/product';
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NewProductPage.routeName),
        child: const Icon(Icons.add),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) => provider.productList.isEmpty
            ? const Center(
                child: Text(
                  'No Product found',
                  style: TextStyle(fontSize: 30),
                ),
              )
            : ListView.builder(
                itemCount: provider.productList.length,
                itemBuilder: (context, index) {
                  final product = provider.productList[index];

                  return Card(
                    child: ListTile(
                      title: Text(' ${product.name}'),
                      subtitle: Text('Stock: ${product.stock}'),
                      trailing: Text('$currencySymbols ${product.salePrice.toString()}'),
                      onTap: ()=>Navigator.pushNamed(context, ProductDetailsPage.routeName,arguments: product.id),
                      ),
                    );

                },
              ),
      ),
    );
  }
}
