// import 'package:e_com_user/auth/auth_service.dart';
// import 'package:e_com_user/db/db_helper.dart';
// import 'package:flutter/material.dart';
//
// import '../model/card_model.dart';
//
// class CartProvider extends ChangeNotifier {
//   List<CartModel> cardList = [];
//
//   int get cardListLength => cardList.length;
//
//   Future<void> addToCart(CartModel cardModel) =>
//       DBHelper.addToCart(cardModel, AuthService.user!.uid);
//
//   Future<void> removeFromCart(String pid) =>
//       DBHelper.removeFromCart(pid, AuthService.user!.uid);
//   Future<void>cleaAllCartItems()=>DBHelper.cleaAllCartItems(AuthService.user!.uid, cardList);
//
//   Future<void> _updateToCart(String pid, num quantity) =>
//       DBHelper.updateToCart(pid, AuthService.user!.uid, quantity);
//
//
//
//   getCartByUser() {
//     DBHelper.getCartByUser(AuthService.user!.uid).listen((event) {
//       cardList = List.generate(event.docs.length,
//           (index) => CartModel.fromMap(event.docs[index].data()));
//       notifyListeners();
//     });
//   }
//
//   bool isInCart(String pid) {
//     bool flag = false;
//     for (var cartM in cardList) {
//       if (cartM.productId == pid) {
//         flag = true;
//         break;
//       }
//     }
//
//     return flag;
//   }
//
//   void increaseQuantity(CartModel cartModel) async {
//     if(cartModel.quantity<cartModel.stock){
//       await _updateToCart(cartModel.productId!, cartModel.quantity + 1);
//     }
//
//   }
//
//  void decreaseQuantity(CartModel cartModel) async {
//     if (cartModel.quantity > 1) {
//       await _updateToCart(cartModel.productId!, cartModel.quantity - 1);
//     }
//   }
//   num getTotalPerUnitePrice(CartModel cartModel)=>cartModel.quantity*cartModel.salePrice;
//
//   num getSubTotal(){
//     num total=0;
//     for(var cartM in cardList){
//       total+=cartM.salePrice * cartM.quantity;
//
//     }
//     return total;
//   }
//
//   // getAllProducts() {
//   //   DBHelper.getAllProducts().listen((snapshot) {
//   //     productList = List.generate(snapshot.docs.length,
//   //             (index) => ProductModel.fromMap(snapshot.docs[index].data()));
//   //     notifyListeners();
//   //   });
//   // }
// }
