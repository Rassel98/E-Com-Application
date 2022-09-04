import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/db/db_helper.dart';
import 'package:e_com_user/model/city_model.dart';
import 'package:e_com_user/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProvider extends ChangeNotifier {
  List<CityModel> cityList = [];
  UserModel? userModel;


  getAllCities() {
    DBHelper.getAllCities().listen((snapshot) {
      cityList = List.generate(snapshot.docs.length,
          (index) => CityModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> addUser(UserModel userModel) => DBHelper.addUser(userModel);

  Future<bool> doseUserExist(String uid) => DBHelper.doseUserExist(uid);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserById(String uid) =>
      DBHelper.getUserById(uid);
  Future<void> updateProfile(String uid, Map<String, dynamic> map) =>
      DBHelper.updateProfile(uid, map);

  List<String> getCityNameByArea(String? city){
    if(city!=null){
      return cityList.firstWhere((element) => element.name==city).area;
    }
    return <String>[];

  }

  Future<String> updateImage(XFile xFile) async {
    final imageName = DateTime.now().microsecondsSinceEpoch.toString();
    final photoRef =
        FirebaseStorage.instance.ref().child('ProfilePicture/$imageName');
    final uploadTask = photoRef.putFile(File(xFile.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }
}
