import 'package:e_com_06/db/db_helper.dart';

import 'package:flutter/material.dart';

import '../model/order_constant_model.dart';

class OrderProvider extends ChangeNotifier{
  OrderConstantModel orderConstantModel=OrderConstantModel();

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



}