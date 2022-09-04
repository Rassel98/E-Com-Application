class OrderConstantModel {
  num deliveryCharge, discount, vat;

  OrderConstantModel(
      {this.deliveryCharge = 0, this.discount = 0, this.vat = 0});


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deliveryCharge': deliveryCharge,
      'discount': discount,
      'vat': vat
    };
  }

  factory OrderConstantModel.fromMap(Map<String, dynamic> map) =>
      OrderConstantModel(
          deliveryCharge: map['deliveryCharge'],
          discount: map['discount'],
          vat: map['vat']
      );


}
