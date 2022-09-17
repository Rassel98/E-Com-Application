import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../auth/auth_service.dart';
import '../db/db_helper.dart';
import '../model/city_model.dart';
import '../model/user_model.dart';

class UserProvider extends ChangeNotifier {
  List<CityModel> cityList = [];
  UserModel? userModel;
  List<UserModel>userList=[];

  getAllCities() {
    // DBHelper.getAllCities().listen((snapshot) {
    //   cityList = List.generate(snapshot.docs.length,
    //       (index) => CityModel.fromMap(snapshot.docs[index].data()));
    //   notifyListeners();
    // });
  }
  getAllUsers(){
    DBHelper.getAllUsers().listen((event) {
      userList=List.generate(event.docs.length, (index) =>
      UserModel.fromMap(event.docs[index].data())
      );

    });
  }


  // Stream<DocumentSnapshot<Map<String, dynamic>>> getUserById(String uid) =>
  //     DBHelper.getUserById(uid);




  List<String> getCityNameByArea(String? city) {
    if (city != null) {
      return cityList.firstWhere((element) => element.name == city).area;
    }
    return <String>[];
  }

  Future<String> updateImage(XFile xFile) async {
    final imageName = DateTime.now().microsecondsSinceEpoch.toString();
    final photoRef =
        FirebaseStorage.instance.ref().child('UserProfilePicture/$imageName');
    final uploadTask = photoRef.putFile(File(xFile.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }
}
