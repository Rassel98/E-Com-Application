import 'package:e_com_user/pages/checkout_page.dart';
import 'package:e_com_user/provider/card_provider.dart';
import 'package:e_com_user/utils/constrains.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  static const String routeName = '/cart';
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Page'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: provider.cardList.length,
                itemBuilder: (context, index) {
                  final cartM = provider.cardList[index];
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(cartM.imageUrl!),
                      ),
                      title: Text(cartM.productName!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Unit price $currencySymbols${cartM.salePrice}'),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    provider.decreaseQuantity(cartM);
                                  },
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    size: 30,
                                  )),
                              Text(
                                cartM.quantity.toString(),
                                style: const TextStyle(fontSize: 17),
                              ),
                              IconButton(
                                  onPressed: () {
                                    provider.increaseQuantity(cartM);
                                  },
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    size: 30,
                                  )),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    provider.removeFromCart(cartM.productId!);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 30,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      trailing: Text(
                          'Total price $currencySymbols${provider.getTotalPerUnitePrice(cartM)}'),
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'SubTotal : $currencySymbols${provider.getSubTotal()}',
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                      onPressed: provider.cardListLength == 0 ? null : () =>Navigator.pushNamed(context, CheckoutPage.routeName),
                      child: const Text('CHECKOUT'))
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
