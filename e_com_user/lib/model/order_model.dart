import 'package:e_com_user/model/address_model.dart';
import 'package:e_com_user/model/date_model.dart';


class OrderModel{
  String? orderId,userId;
  String orderStatus,paymentMethod;
  AddressModel deliveryAddress;
  num deliveryCharge,discount,vat,grantTotal;
  DateModel orderDate;

  OrderModel(
      {this.orderId,
      this.userId,
      required this.orderStatus,
      required this.paymentMethod,
      required this.deliveryAddress,
      required this.deliveryCharge,
      required this.discount,
      required this.vat,
      required this.grantTotal,
      required this.orderDate}
      );
  Map<String,dynamic>toMap(){
    return<String,dynamic>{
      'orderId':orderId,
      'userId':userId,
      'orderStatus':orderStatus,
      'paymentMethod':paymentMethod,
      'deliveryAddress':deliveryAddress.toMap(),
      'deliveryCharge':deliveryCharge,
      'discount':discount,
      'vat':vat,
      'grantTotal':grantTotal,
      'orderDate':orderDate.toMap()
    };
  }
  factory OrderModel.fromMap(Map<String,dynamic>map)=>
      OrderModel(
        orderId: map['orderId'],
          userId: map['userId'],
          orderStatus:map ['orderStatus'],
          paymentMethod:map ['paymentMethod'],
          deliveryAddress:AddressModel.fromMap(map ['deliveryAddress']),
          deliveryCharge: map['deliveryCharge'],
          discount: map['discount'],
          vat: map['vat'],
          grantTotal:map ['grantTotal'],
          orderDate:DateModel.fromMap(map ['orderDate'])
      );
}