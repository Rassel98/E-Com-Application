import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_06/db/db_helper.dart';
import 'package:e_com_06/model/category_model.dart';
import 'package:e_com_06/model/purches_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../model/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  List<PurchaseModel> purchaseSpecifiqueOfProduct = [];
  List<CategoryModel> categoryList = [];


//all get function
  getAllCategories() {
    DBHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length,
          (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
  getAllProducts() {
    DBHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
              (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllPurchaseOfSpecifiqueProduct(String id) {
    DBHelper.getAllPurchase(id).listen((snapshot) {
      purchaseSpecifiqueOfProduct = List.generate(snapshot.docs.length,
              (index) => PurchaseModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String pid)=>
  DBHelper.getProductById(pid);



//all ADD function



  Future<void> addProduct(ProductModel productModel,
      PurchaseModel purchaseModel, CategoryModel categoryModel) {
    final count = categoryModel.productCount + purchaseModel.quantity;
    return DBHelper.addProduct(
        categoryModel.catId!, count, productModel, purchaseModel);
  }

  Future<void> addCategory(String categoryName) {
    final categoryModel = CategoryModel(
      catName: categoryName,
    );
    return DBHelper.addCategory(categoryModel);
  }
  Future<void> addPurchase(PurchaseModel purchaseModel, String category)async {
    final catModel=getCategoryByName(category);
    catModel.productCount+=purchaseModel.quantity;
    DBHelper.addPurchase(purchaseModel,catModel);
  }




  CategoryModel getCategoryByName(String name) {
    final model = categoryList.firstWhere((element) => element.catName == name);
    return model;
  }


//all Update function


  Future<String> updateImage(XFile xFile) async {
    final imageName = DateTime.now().microsecondsSinceEpoch.toString();
    final photoRef =
        FirebaseStorage.instance.ref().child('Pictures/$imageName');
    final uploadTask = photoRef.putFile(File(xFile.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }
  Future<void>updateProduct(String id,String field,dynamic value) async{
    await DBHelper.updateProduct(id, {field:value});
  }
// delete function
  Future<void> deleteCategoryById(String id)=>
      DBHelper.deleteCategoryById(id);

}
