import 'package:e_com_user/model/card_model.dart';
import 'package:e_com_user/model/product_model.dart';
import 'package:e_com_user/pages/product_details_page.dart';
import 'package:e_com_user/provider/card_provider.dart';
import 'package:e_com_user/utils/constrains.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  final ProductModel productModel;
  const ProductItem({Key? key, required this.productModel}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>Navigator.pushNamed(context, ProductDetailsPage.routeName,arguments: widget.productModel.id),
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: FadeInImage.assetNetwork(
                    fadeInDuration: const Duration(seconds: 2),
                    fadeInCurve: Curves.bounceInOut,
                    placeholder: 'images/gallery.png',
                    image: widget.productModel.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.maxFinite,
                  ),
                ),
                Text(
                  widget.productModel.name!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$currencySymbols${widget.productModel.salePrice}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Consumer<CartProvider>(
                  builder: (context, value, child) {
                    final isInCart = value.isInCart(widget.productModel.id!);
                    return ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:isInCart?MaterialStateProperty.all(Colors.red)
                            :MaterialStateProperty.all(Colors.blue)
                      ),
                        onPressed: () {
                          if (isInCart) {
                            value.removeFromCart(widget.productModel.id!);
                          } else {
                            final cardModel = CartModel(
                              productId: widget.productModel.id!,
                              productName: widget.productModel.name,
                              category: widget.productModel.category,
                              salePrice: widget.productModel.salePrice,
                              stock: widget.productModel.stock,
                              imageUrl: widget.productModel.imageUrl,
                            );
                            value.addToCart(cardModel);
                          }
                        },
                        icon: Icon(isInCart
                            ? Icons.remove_shopping_cart
                            : Icons.add_shopping_cart),
                        label: Text(isInCart ? 'Remove' : 'ADD'));
                  },
                )
              ],
            ),
            if (widget.productModel.stock <= 0)
              Container(
                alignment: Alignment.center,
                color: Colors.black54,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Out Of Stock',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),

                    ElevatedButton(
                        onPressed: (){

                        },
                        child: const Text('Add WishList'))
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
