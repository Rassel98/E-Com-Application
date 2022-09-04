import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_user/model/card_model.dart';
import 'package:e_com_user/model/comments_model.dart';
import 'package:e_com_user/model/order_model.dart';
import 'package:e_com_user/model/rating_model.dart';

import '../model/category_model.dart';
import '../model/user_model.dart';
import '../utils/constrains.dart';

class DBHelper {
  static const String collectionCategory = 'Categories';
  static const String collectionProduct = 'Products';
  static const String collectionRateProduct = 'Rating';
  static const String collectionComments = 'Comments';
  static const String collectionUser = 'Users';
  static const String collectionCart = 'Cart';
  static const String collectionOrder = 'Orders';
  static const String collectionOrderDetails = 'OrderDetails';
  static const String collectionCities = 'Cities';
  static const String collectionOrderSettings = 'Settings';
  static const String documentOrderConstant = 'OrderConstant';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

//all Add function
  static Future<void> addUser(UserModel userModel) =>
      _db.collection(collectionUser).doc(userModel.uid).set(userModel.toMap());
  static Future<void>addComments(CommentModel commentModel)=>
  _db.collection(collectionProduct)
      .doc(commentModel.productId)
      .collection(collectionComments)
      .doc(commentModel.userId).set(commentModel.toMap());

  static Future<void>addRating(RatingModel ratingModel) {
    return _db.collection(collectionProduct).doc(ratingModel.productId)
        .collection(collectionRateProduct).doc(ratingModel.userId).set(ratingModel.toMap());
  }

  static Future<void> addToCart(CartModel cardModel, String uid) => _db
      .collection(collectionUser)
      .doc(uid)
      .collection(collectionCart)
      .doc(cardModel.productId)
      .set(cardModel.toMap());

  static Future<void> removeFromCart(String pid, String uid) => _db
      .collection(collectionUser)
      .doc(uid)
      .collection(collectionCart)
      .doc(pid)
      .delete();

  static Future<void> cleaAllCartItems(String uid, List<CartModel> cartList) {
    final wb = _db.batch();
    final userDoc = _db.collection(collectionUser).doc(uid);
    for (var cartM in cartList) {
      final cartDoc = userDoc.collection(collectionCart).doc(cartM.productId);
      wb.delete(cartDoc);
    }
    return wb.commit();
  }

  static Future<bool>canUserRate(String uid,String pid)async{
    final docSnapshot= await _db.collection(collectionOrder)
        .where('userId',isEqualTo: uid)
        .where('orderStatus',isEqualTo:OrderStatus.delivered).get();
    if(docSnapshot.docs.isEmpty)return false;
    bool flag=false;
    for(var doc in docSnapshot.docs){
     final detailsDoc=await doc.reference.collection(collectionOrderDetails)
          .where('productId',isEqualTo: pid).get();
      if(detailsDoc.docs.isNotEmpty){
        flag=true;
        break;
      }

    }
    return flag;
  }


  static Future<void> updateToCart(String pid, String uid, num quantity) => _db
      .collection(collectionUser)
      .doc(uid)
      .collection(collectionCart)
      .doc(pid)
      .update({cardProductQuantity: quantity});

  static Future<void> addOrder(
      OrderModel orderModel, List<CartModel> cartList) {
    final wb = _db.batch();
    final orderDoc = _db.collection(collectionOrder).doc();
    orderModel.orderId = orderDoc.id;
    wb.set(orderDoc, orderModel.toMap());
    for (var cartM in cartList) {
      final orderDetailsDoc =
          orderDoc.collection(collectionOrderDetails).doc(cartM.productId);
      wb.set(orderDetailsDoc, cartM.toMap());
      final productDoc = _db.collection(collectionProduct).doc(cartM.productId);
      wb.update(productDoc, {'stock': cartM.stock - cartM.quantity});
    }

    return wb.commit();
  }

  static Future<bool> doseUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

//all Get function

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getAllOrderConstant() =>
      _db
          .collection(collectionOrderSettings)
          .doc(documentOrderConstant)
          .snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getAllOrderConstant2() => _db
          .collection(collectionOrderSettings)
          .doc(documentOrderConstant)
          .get();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCities() =>
      _db.collection(collectionCities).snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllComments(String pid) =>
      _db.collection(collectionProduct).doc(pid).collection(collectionComments)
          .where('status',isEqualTo: true)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCartByUser(
          String uid) =>
      _db
          .collection(collectionUser)
          .doc(uid)
          .collection(collectionCart)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() => _db
      .collection(collectionProduct)
      .where('available', isEqualTo: true)
      .snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(
          String catName) =>
      _db
          .collection(collectionProduct)
          .where('category', isEqualTo: catName)
          .snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllFeaturedProducts() =>
      _db
          .collection(collectionProduct)
          .where('feature', isEqualTo: true)
          .snapshots();

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllRatingByProducts(String pid) =>
      _db
          .collection(collectionProduct).doc(pid)
          .collection(collectionRateProduct)
          .get();


  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(
          String pid) =>
      _db.collection(collectionProduct).doc(pid).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserById(
          String uid) =>
      _db.collection(collectionUser).doc(uid).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrderByUserId(
          String uid) =>
      _db
          .collection(collectionOrder)
          .where('userId', isEqualTo: uid)
          .snapshots();

  static Future<void> updateRatingOfProduct(
      String pid, Map<String, dynamic> map) async {
    await _db.collection(collectionProduct).doc(pid).update(map);
  }
  static Future<void> updateProfile(
      String uid, Map<String, dynamic> map) async {
    await _db.collection(collectionUser).doc(uid).update({'address': map});
  }

  static Future<void> updateCategoryProductCount(
      List<CategoryModel> categoryList, List<CartModel> cartList) {
    final wb = _db.batch();
    for (var cartM in cartList) {
      final categoryModel = categoryList
          .firstWhere((categoryM) => categoryM.catName == cartM.category);
      final categoryDoc =
          _db.collection(collectionCategory).doc(categoryModel.catId);
      wb.update(categoryDoc, {
        categoryModelProductCount: categoryModel.productCount - cartM.quantity
      });
    }

    return wb.commit();
  }

  //all update function

//all delete function
//   static Future<void> deleteCategoryById(String id) =>
//       _db.collection(collectionCategory).doc(id).delete();
//
//   static Future<void> deleteProductById(String id) async {
//     //_db.collection(collectionProduct).doc(id).delete()
//     //final wb=_db.batch();
//     //  var removedProductRef = _db.collection(collectionProduct).doc(id);
//     //  var removedPurchaseRef = _db.collection(collectionPurchase).doc(id);
//     // wb.delete(removedProductRef);
//     // wb.delete(removedPurchaseRef);
//     //  wb.commit();
//     // _db.collection(collectionCategory).doc(id).delete();
//   }
}
