import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../model/product_model.dart';
import '../provider/product_provider.dart';
import '../utils/constrains.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/product_details';

  ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductProvider provider;
  late String pid;
  final txtController = TextEditingController();
  @override
  void dispose() {
    txtController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    pid = ModalRoute.of(context)!.settings.arguments as String;
    provider = Provider.of<ProductProvider>(context, listen: false);
    provider.getAllComments(pid);

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // elevation: 0,
          //  backgroundColor: Colors.transparent,
          title: const Text(
            'Product Details',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: provider.getProductById(pid),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  final product = ProductModel.fromMap(snapshot.data!.data()!);

                  return ListView(
                    shrinkWrap: true,
                    //padding: EdgeInsets.symmetric(horizontal: 5),
                    children: [
                      FadeInImage.assetNetwork(
                        fadeInDuration: const Duration(seconds: 1),
                        placeholder: 'images/Loading.gif',
                        image: product.imageUrl!,
                        height: 200,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      ),
                      ListTile(
                        title: Text(product.name!),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${product.rating}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            RatingBar.builder(
                              itemSize: 15,
                              ignoreGestures: true,
                              initialRating: product.rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            Text('(${product.ratingCount})'),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text('$currencySymbols${product.salePrice}'),
                      ),
                      ListTile(
                        title: Text(product.category!),
                      ),
                      ListTile(
                        title: Text(product.description!),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            EasyLoading.show(
                                status: 'Please Wait..', dismissOnTap: false);
                            final status =
                                await provider.canUserRate(product.id!);
                            EasyLoading.dismiss();
                            if (status) {
                              _ratingProduct(context, product, (value) async {
                                EasyLoading.show(status: 'Please wait..');
                                await provider
                                    .addRating(product.id!, value)
                                    .then((value) {
                                  EasyLoading.dismiss();
                                });
                              });
                            } else {
                              showDisplayMessage(context, 'you can not Rate');
                            }
                          },
                          child: const Text('Rate This Product')),

                      // Comments(pid: pid)
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
            ),
            provider.commentsList.isEmpty
                ? const Text('No comment Found')
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.commentsList.length,
                    itemBuilder: (context, index) {
                      final comM = provider.commentsList[index];
                      return ListTile(
                        title: Text(comM.comment),
                      );
                    },
                  ),
            ElevatedButton(
                onPressed: () {
                  _addComments(context);
                },
                child: const Text('Add your comment'))
            // Row(
            //   children: [
            //     TextField(
            //       controller: txtController,
            //       decoration: const InputDecoration(
            //           hintText: 'Enter You Comments',
            //           suffixIcon: Icon(Icons.message)
            //       ),
            //
            //     ),
            //    // ElevatedButton(onPressed: txtController.text.isEmpty?null:(){}, child:const Text('Sent'))
            //   ],
            // )
          ],
        ));
  }

  void _ratingProduct(
      BuildContext context, ProductModel product, Function(double) onRate) {
    double userRate = 0.0;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(product.name!),
              content: RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  userRate = rating;
                },
              ),
              actions: [
                Row(
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL')),
                    TextButton(
                        onPressed: () {
                          onRate(userRate);
                          Navigator.pop(context);
                        },
                        child: const Text('RATE')),
                  ],
                )
              ],
            ));
  }

  void _addComments(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add your Comments'),
              content: TextField(
                controller: txtController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    hintText: 'Enter comments', filled: false),
              ),
              actions: [
                Row(
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL')),
                    TextButton(
                        onPressed: () {
                          if (txtController.text.isEmpty) {
                            return;
                          }
                          EasyLoading.show(status: 'Please wait..');
                          provider
                              .addComments(pid, txtController.text)
                              .then((value) {
                            EasyLoading.dismiss();
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('COMMENTS')),
                  ],
                )
              ],
            ));
  }
}
