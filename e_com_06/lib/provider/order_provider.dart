import 'package:e_com_06/db/db_helper.dart';
import 'package:e_com_06/model/order_model.dart';

import 'package:flutter/material.dart';

import '../model/order_constant_model.dart';
import '../utils/constrains.dart';

class OrderProvider extends ChangeNotifier{
  OrderConstantModel orderConstantModel=OrderConstantModel();
  List<OrderModel>orderList=[];
  getAllOrders() {
    DBHelper.getAllOrders().listen((snapshot) {
      orderList = List.generate(snapshot.docs.length,
              (index) => OrderModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllOrderConstant(){
    DBHelper.getAllOrderConstant().listen((event) {
      if(event.exists){
        orderConstantModel=OrderConstantModel.fromMap(event.data()!);
        notifyListeners();
      }

    });
  }

  Future<void>getAllOrderConstant2()async{
    final snapshot=await DBHelper.getAllOrderConstant2();
      orderConstantModel=OrderConstantModel.fromMap(snapshot.data()!);


  }
  Future<void>addOrderConstant(OrderConstantModel model)=>
      DBHelper.addOrderConstant(model);

  List<OrderModel> getFilteredListBySingleDay(DateTime dt) {
    return orderList.where((orderM) =>
    orderM.orderDate.timestamp.toDate().day == dt.day &&
        orderM.orderDate.timestamp.toDate().month == dt.month &&
        orderM.orderDate.timestamp.toDate().year == dt.year).toList();
  }

  List<OrderModel> getFilteredListByWeek(DateTime dt) {
    return orderList.where((orderM) =>
        orderM.orderDate.timestamp.toDate().isAfter(dt)).toList();
  }

  List<OrderModel> getFilteredListByDateRange(DateTime dt) {
    return orderList.where((orderM) =>
    orderM.orderDate.timestamp.toDate().month == dt.month &&
        orderM.orderDate.timestamp.toDate().year == dt.year).toList();
  }

  num getTotalSaleBySingleDate(DateTime dt) {
    num total = 0;
    final list = getFilteredListBySingleDay(dt);
    for(var order in list) {
      total += order.grantTotal;
    }
    return total.round();
  }

  num getTotalSaleByWeek(DateTime dt) {
    num total = 0;
    final list = getFilteredListByWeek(dt);
    for(var order in list) {
      total += order.grantTotal;
    }
    return total.round();
  }

  num getTotalSaleByDateRange(DateTime dt) {
    num total = 0;
    final list = getFilteredListByDateRange(dt);
    for(var order in list) {
      total += order.grantTotal;
    }
    return total.round();
  }

  num getTotalAllTimeSale() {
    num total = 0;
    for(var order in orderList) {
      total += order.grantTotal;
    }
    return total.round();
  }

  List<OrderModel> getFilteredList(OrderFilter filter) {
    var list = <OrderModel>[];
    switch(filter) {
      case OrderFilter.TODAY:
        list = getFilteredListBySingleDay(DateTime.now());
        break;
      case OrderFilter.YESTERDAY:
        list = getFilteredListBySingleDay(DateTime.now().subtract(const Duration(days: 1)));
        break;
      case OrderFilter.SEVEN_DAYS:
        list = getFilteredListByWeek(DateTime.now().subtract(const Duration(days: 7)));
        break;
      case OrderFilter.THIS_MONTH:
        list = getFilteredListByDateRange(DateTime.now());
        break;
      case OrderFilter.ALL_TIME:
        list = orderList;
        break;
    }
    return list;
  }

}