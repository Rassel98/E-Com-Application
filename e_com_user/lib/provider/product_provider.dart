import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/auth/auth_service.dart';

import 'package:flutter/foundation.dart';

import '../db/db_helper.dart';

import '../model/card_model.dart';
import '../model/category_model.dart';
import '../model/comments_model.dart';
import '../model/product_model.dart';
import '../model/rating_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  List<ProductModel> featuredProductList = [];

  List<CategoryModel> categoryList = [];
  List<String> categoryNameList = [];
  List<RatingModel> ratingList = [];
  List<CommentModel> commentsList = [];

  Future<bool> canUserRate(String pid) =>
      DBHelper.canUserRate(AuthService.user!.uid, pid);

  Future<void> addComments(String pid, String userComment) async {
    final commentModel = CommentModel(
        userId: AuthService.user!.uid, productId: pid, comment: userComment);
    await DBHelper.addComments(commentModel);
  }

  Future<void> addRating(String pid, double value) async {
    final ratingM = RatingModel(
        userId: AuthService.user!.uid, productId: pid, rating: value);
    await DBHelper.addRating(ratingM);
    final qSnapshot = await DBHelper.getAllRatingByProducts(pid);
    ratingList = List.generate(qSnapshot.docs.length,
        (index) => RatingModel.fromMap(qSnapshot.docs[index].data()));
    double sumOfRating = 0.0;
    for (var ratM in ratingList) {
      sumOfRating += ratM.rating;
    }
    final avgRating = sumOfRating / ratingList.length;
    await DBHelper.updateRatingOfProduct(
        pid, {'rating': avgRating, 'ratingCount': ratingList.length});
  }
  getAllComments(String pid){
    DBHelper.getAllComments(pid).listen((event) {
      commentsList=List.generate(event.docs.length,
              (index) => CommentModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });

  }

//all get function
  getAllCategories() {
    DBHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length,
          (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
      categoryNameList = List.generate(
          categoryList.length, (index) => categoryList[index].catName!);
      categoryNameList.insert(0, 'All');
      notifyListeners();
    });
  }

  Future<void> updateCategoryProductCount(List<CartModel> cartList) =>
      DBHelper.updateCategoryProductCount(categoryList, cartList);

  getAllProductsByCategory(String category) {
    DBHelper.getAllProductsByCategory(category).listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
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

  getAllFeaturedProducts() {
    DBHelper.getAllFeaturedProducts().listen((snapshot) {
      featuredProductList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String pid) =>
      DBHelper.getProductById(pid);
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllComments2(String pid) =>
      DBHelper.getAllComments(pid);

  CategoryModel getCategoryByName(String name) {
    final model = categoryList.firstWhere((element) => element.catName == name);
    return model;
  }

//all Update function

// delete function
//   Future<void> deleteCategoryById(String id)=>
//       DBHelper.deleteCategoryById(id);

}
