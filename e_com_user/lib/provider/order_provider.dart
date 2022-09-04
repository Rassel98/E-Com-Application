
import 'package:e_com_user/auth/auth_service.dart';
import 'package:e_com_user/model/order_model.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../model/card_model.dart';
import '../model/order_constant_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantModel orderConstantModel = OrderConstantModel();
  List<OrderModel> orderListCurrentUser = [];

  Future<void> addOrder(OrderModel orderModel, List<CartModel> cartList) =>
      DBHelper.addOrder(orderModel, cartList);

  //Future<QuerySnapshot<Map<String, dynamic>>> getAllOrderByUserId()=>DBHelper.getAllOrderByUserId(AuthService.user!.uid);
  getAllOrderByUserId() {
    DBHelper.getAllOrderByUserId(AuthService.user!.uid).listen((event) {
      orderListCurrentUser = List.generate(event.docs.length,
          (index) => OrderModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  getAllOrderConstant() {
    DBHelper.getAllOrderConstant().listen((event) {
      if (event.exists) {
        orderConstantModel = OrderConstantModel.fromMap(event.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> getAllOrderConstant2() async {
    final snapshot = await DBHelper.getAllOrderConstant2();
    orderConstantModel = OrderConstantModel.fromMap(snapshot.data()!);
  }

  num getDiscount(num subtotal) {
    if (subtotal > 2000) {
      return (subtotal * orderConstantModel.discount) / 100;
    }
    return subtotal;
  }

  num getVatAmount(num subtotal) {
    final afterDis = subtotal - getDiscount(subtotal);
    return (afterDis * orderConstantModel.vat) / 100;
  }

  num getGrandTotalAmount(num subtotal) {
    final afterDis = subtotal - getDiscount(subtotal);
    return afterDis +
        getVatAmount(subtotal) +
        orderConstantModel.deliveryCharge;
  }
}
