class AddressModel {
  String streetAddress;
  String city;
  String area;
  String zipCode;

  AddressModel(
      {required this.streetAddress,
      required this.city,
      required this.area,
      required this.zipCode});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'streetAddress': streetAddress,
      'area': area,
      'city': city,
      'zipCode': zipCode
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) => AddressModel(
      streetAddress: map['streetAddress'],
      city: map['city'],
      area: map['area'],
      zipCode: map['zipCode']);
}
