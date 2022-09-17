import 'package:cloud_firestore/cloud_firestore.dart';

import 'address_model.dart';


class UserModel {
  String uid;
  String? name;
  AddressModel? address;
  String email;
  String? mobile;
  String? image;
  Timestamp userCreationTime;
  String? deviceToken;

  UserModel(
      {required this.uid,
      this.name,
      required this.email,
      this.mobile,
      this.image,
      required this.userCreationTime,
      this.deviceToken,
      this.address});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'address': address?.toMap(),
      'email': email,
      'mobile': mobile,
      'image': image,
      'userCreationTime': userCreationTime,
      'deviceToken': deviceToken
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
      uid: map['uid'],
      name: map['name'],
      address:map['address']==null?null: AddressModel.fromMap(map['address']),
      email: map['email'],
      mobile: map['mobile'],
      userCreationTime: map['userCreationTime'],
      image: map['image'],
      deviceToken: map['deviceToken']);
}
