import 'package:e_com_06/model/date_model.dart';

class PurchaseModel {
  String? id;
  String? productId;
  DateModel dateModel;
  num purchasePrice;
  num quantity;

  PurchaseModel(
      {this.id,
      this.productId,
      required this.dateModel,
      required this.purchasePrice,
      required this.quantity});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'purchaseDate': dateModel.toMap(),
      'purchasePrice': purchasePrice,
      'quantity': quantity,
    };
  }

  factory PurchaseModel.fromMap(Map<String, dynamic> map) => PurchaseModel(
        id: map['id'],
        productId: map['productId'],
        dateModel: DateModel.fromMap(map['purchaseDate']),
        purchasePrice: map['purchasePrice'],
        quantity: map['quantity'],
      );
}
