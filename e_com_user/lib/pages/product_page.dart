import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_com_user/auth/auth_service.dart';
import 'package:e_com_user/pages/cart_page.dart';
import 'package:e_com_user/provider/card_provider.dart';
import 'package:e_com_user/provider/user_provider.dart';
import 'package:e_com_user/widgets/main_drawer.dart';
import 'package:e_com_user/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

class ProductPage extends StatefulWidget {
  static const String routeName = '/product';
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int? _value;
  int _current = 0;
  @override
  void didChangeDependencies() {
    _value = 0;
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<CartProvider>(context, listen: false).getCartByUser();
    Provider.of<UserProvider>(context, listen: false).getUserById(AuthService.user!.uid);
    Provider.of<ProductProvider>(context, listen: false)
        .getAllFeaturedProducts();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, CartPage.routeName),
                    icon: const Icon(
                      Icons.shopping_cart,
                      size: 30,
                    )),
                Positioned(
                  left: -4,
                  top: -4,
                  child: Container(
                    alignment: Alignment.center,
                    height: 20,
                    width: 20,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child: FittedBox(
                      child: Consumer<CartProvider>(
                          builder: (context, value, child) =>
                              Text(value.cardListLength.toString())),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      drawer: const MainDrawer(),
      body: Consumer<ProductProvider>(
          builder: (context, provider, _) => Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.categoryNameList.length,
                      itemBuilder: (context, index) {
                        final catName = provider.categoryNameList[index];
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: ChoiceChip(
                            labelStyle: TextStyle(
                                color: _value == index
                                    ? Colors.white
                                    : Colors.black),
                            selectedColor: Theme.of(context).primaryColor,
                            label: Text(catName),
                            selected: _value == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _value = selected ? index : null;
                              });
                              if (_value != null && _value != 0) {
                                provider.getAllProductsByCategory(catName);
                              } else if (_value == 0) {
                                provider.getAllProducts();
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Text('Featured Products',
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                  const Divider(
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          CarouselSlider(
                              items: provider.featuredProductList
                                  .map((e) => Stack(
                                        children: [
                                          FadeInImage.assetNetwork(
                                            fadeInDuration:
                                                const Duration(seconds: 2),
                                            fadeInCurve: Curves.bounceInOut,
                                            placeholder: 'images/gallery.png',
                                            image: e.imageUrl!,
                                            fit: BoxFit.cover,
                                            width: double.maxFinite,
                                          ),
                                          Positioned(
                                              left: 0,
                                              right: 0,
                                              bottom: 0,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    )),
                                                alignment: Alignment.center,
                                                height: 50,
                                                child: Text(
                                                  e.name!,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                              ))
                                        ],
                                      ))
                                  .toList(),
                              options: CarouselOptions(
                                height: 200,
                                aspectRatio: 16 / 9,
                                viewportFraction: 0.7,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                },
                                scrollDirection: Axis.horizontal,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: provider.featuredProductList.map(
                              (image) {
                                //these two lines
                                int index = provider.featuredProductList
                                    .indexOf(image); //are changed
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _current == index
                                          ? const Color.fromRGBO(0, 0, 0, 0.9)
                                          : const Color.fromRGBO(0, 0, 0, 0.4)),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  provider.productList.isEmpty
                      ? const Center(
                          child: Text(
                            'No Product found',
                            style: TextStyle(fontSize: 30),
                          ),
                        )
                      : Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                    childAspectRatio: 0.6),
                            itemCount: provider.productList.length,
                            itemBuilder: (context, index) {
                              final productModel = provider.productList[index];

                              return ProductItem(productModel: productModel);
                            },
                          ),
                        ),
                ],
              )),
    );
  }
}
